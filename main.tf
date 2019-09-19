// ************* GLOBAL Part ************* //

# generate a new private CA
resource "null_resource" "generate_self_ca" {
  provisioner "local-exec" {
    command = "${path.root}/scripts/gen_self_ca.sh .terraform/modules/nomad_cluster_on_aws/ca_certs .terraform/modules/nomad_cluster_on_gcp/ca_certs"
  }
}

# generate a new secure gossip encryption key
resource "random_id" "server_gossip" {
  byte_length = 16
}

// ************* Networking ************* //

# Module that creates new VPC with one Public and one or more Private subnets on AWS
module "new_aws_vpc" {
  source = "git@github.com:achuchulev/terraform-aws-vpc-natgw.git"

  aws_access_key = var.access_key
  aws_secret_key = var.secret_key
  aws_region     = var.aws_region

  vpc_cidr_block         = var.vpc_cidr_block
  vpc_subnet_cidr_blocks = var.vpc_subnet_cidr_blocks

  vpc_tags = {
    Name = var.vpc_tag_name
    Side = var.vpc_tag_side
  }
}

# Module that creates new VPC on GCP
module "new_gcp_vpc" {
  source = "git@github.com:achuchulev/terraform-gcp-vpc.git"

  gcp_credentials_file_path = var.gcp_credentials_file_path
  gcp_project_id            = var.gcp_project_id
  gcp_region                = var.gcp_region
  gcp_subnet1_cidr          = var.gcp_subnet1_cidr
}

# Module that creates new VPN between AWS <-> GCP

module "aws-gcp-vpn" {
  source = "git@github.com:achuchulev/terraform-aws-gcp-vpn.git"

  gcp_credentials_file_path = var.gcp_credentials_file_path
  gcp_project_id            = var.gcp_project_id
  gcp_network_name          = module.new_gcp_vpc.gcp_vpc_network_id
  gcp_subnet_name           = module.new_gcp_vpc.gcp_vpc_network_subnet_id
  gcp_region                = var.gcp_region
  access_key                = var.access_key
  secret_key                = var.secret_key
  aws_region                = var.aws_region
  aws_vpc_id                = module.new_aws_vpc.vpc_id
  aws_subnet_cidrs          = var.vpc_subnet_cidr_blocks
}


module "aws-client-vpn" {
  source = "git@github.com:achuchulev/terraform-aws-client-vpn-endpoint.git"

  aws_access_key = var.access_key
  aws_secret_key = var.secret_key
  aws_region     = var.aws_region
  subnet_id      = module.new_aws_vpc.subnet_ids[0]
  domain         = "ntry.site"
}


// ************* NOMAD ************* //

# Module that creates Nomad cluster (servers/clients/frontend) on AWS

module "nomad_cluster_on_aws" {
  source = "git@github.com:achuchulev/terraform-aws-nomad.git"

  access_key                 = var.access_key
  secret_key                 = var.secret_key
  aws_vpc_id                 = module.new_aws_vpc.vpc_id
  frontend_subnet_id         = module.new_aws_vpc.subnet_ids[0]
  server_subnet_id           = module.new_aws_vpc.subnet_ids[1]
  client_subnet_id           = module.new_aws_vpc.subnet_ids[1]
  secure_gossip              = random_id.server_gossip.b64_std
  cloudflare_email           = var.cloudflare_email
  cloudflare_token           = var.cloudflare_token
  cloudflare_zone            = var.cloudflare_zone
  subdomain_name             = var.aws_subdomain_name
  private_subnet_with_nat_gw = "true"
  dc                         = var.aws_region
  nomad_region               = var.nomad_region_aws
  authoritative_region       = var.authoritative_region
}

# Module that creates Nomad cluster (servers/clients/frontend) on GCP

module "nomad_cluster_on_gcp" {
  source = "git@github.com:achuchulev/terraform-gcp-nomad.git"

  gcp_credentials_file_path = var.gcp_credentials_file_path
  gcp_project_id            = var.gcp_project_id
  gcp_vpc_network           = module.new_gcp_vpc.gcp_vpc_network_id
  gcp_subnet_name           = module.new_gcp_vpc.gcp_vpc_network_subnet_id
  secure_gossip             = random_id.server_gossip.b64_std
  cloudflare_email          = var.cloudflare_email
  cloudflare_token          = var.cloudflare_token
  cloudflare_zone           = var.cloudflare_zone
  subdomain_name            = var.gcp_subdomain_name
  dc                        = var.gcp_region
  nomad_region              = var.nomad_region_gcp
  authoritative_region      = var.authoritative_region
}

// ************* NOMAD Cluster Federetaion ************* //

resource "null_resource" "nomad_federation_aws" {
  count = var.make_federation == "true" ? 1 : 0
  depends_on = [
    module.nomad_cluster_on_aws,
    module.nomad_cluster_on_gcp,
    module.aws-gcp-vpn,
    module.aws-client-vpn
  ]

  provisioner "remote-exec" {
    # create nomad multi-region federation
    inline = [
      "export NOMAD_ADDR=${module.nomad_cluster_on_aws.ui_url}",
      "nomad server join '${module.nomad_cluster_on_gcp.server_private_ips[0]}'",
    ]

    connection {
      host        = module.nomad_cluster_on_aws.server_private_ips[0]
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
    }
  }
}