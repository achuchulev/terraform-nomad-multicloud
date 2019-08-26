// ************* GLOBAL Part ************* //

resource "null_resource" "generate_self_ca" {
  provisioner "local-exec" {
    # script called with private_ips of nomad backend servers
    command = "${path.root}/scripts/gen_self_ca.sh ${var.nomad_aws_region1} ${var.nomad_aws_region2} ${var.nomad_gcp_region}"
  }
}

resource "random_id" "server_gossip" {
  byte_length = 16
}

// ************* Get output data from "aws-vpc-peering" module tfstate ************* //

data "terraform_remote_state" "aws_vpcs" {
  backend = "local"

  config = {
    path = "./networking/aws-vpcs/terraform.tfstate"
  }
}

// ************* Get output data from "gcp-vpc" module tfstate ************* //

data "terraform_remote_state" "gcp_vpc" {
  backend = "local"

  config = {
    path = "./networking/gcp-vpc/terraform.tfstate"
  }
}

// ************* AWS Part ************* //

// Module to create needed security groups for nomad

module "nomad_security_groups_region1" {
  source     = "./modules/security_groups"
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
  aws_vpc_id = data.terraform_remote_state.aws_vpcs.outputs.accepter_vpc_id
}

module "nomad_security_groups_region2" {
  source     = "./modules/security_groups"
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region2
  aws_vpc_id = data.terraform_remote_state.aws_vpcs.outputs.requester_vpc_id
}

# Module that creates Nomad server instances in AWS region A, Nomad region A and Nomad dc1
module "aws-region1-nomad_server" {
  source = "./modules/aws/nomad_instance"

  access_key           = var.access_key
  secret_key           = var.secret_key
  region               = var.region
  nomad_instance_count = var.servers_count
  aws_vpc_id           = data.terraform_remote_state.aws_vpcs.outputs.accepter_vpc_id
  availability_zone    = data.terraform_remote_state.aws_vpcs.outputs.accepter_azs[1]
  subnet_id            = data.terraform_remote_state.aws_vpcs.outputs.accepter_subnet_ids[1]
  dc                   = var.nomad_aws_region1_dc
  ami                  = var.server_ami
  instance_type        = var.instance_type
  public_key           = var.public_key
  sg_id                = module.nomad_security_groups_region1.security_group_id
  nomad_region         = var.nomad_aws_region1
  authoritative_region = var.authoritative_region
  domain_name          = var.subdomain_name
  zone_name            = var.cloudflare_zone
  secure_gossip        = random_id.server_gossip.b64_std
}

# Module that creates Nomad server instances in AWS region B, Nomad region B and Nomad dc1
module "aws-region2-nomad_server" {
  source = "./modules/aws/nomad_instance"

  region               = var.region2
  aws_vpc_id           = data.terraform_remote_state.aws_vpcs.outputs.requester_vpc_id
  availability_zone    = data.terraform_remote_state.aws_vpcs.outputs.requester_azs[1]
  subnet_id            = data.terraform_remote_state.aws_vpcs.outputs.requester_subnet_ids[1]
  nomad_region         = var.nomad_aws_region2
  ami                  = var.region2_server_ami
  dc                   = var.nomad_aws_region2_dc
  authoritative_region = var.authoritative_region
  nomad_instance_count = var.servers_count
  access_key           = var.access_key
  secret_key           = var.secret_key
  instance_type        = var.instance_type
  public_key           = var.public_key
  sg_id                = module.nomad_security_groups_region2.security_group_id
  domain_name          = var.subdomain_name
  zone_name            = var.cloudflare_zone
  secure_gossip        = random_id.server_gossip.b64_std
}

# Module that creates Nomad client instances in AWS region A, Nomad region A and Nomad dc1
module "aws-region1-nomad_client" {
  source = "./modules/aws/nomad_instance"

  region               = var.region
  nomad_region         = var.nomad_aws_region1
  aws_vpc_id           = data.terraform_remote_state.aws_vpcs.outputs.accepter_vpc_id
  availability_zone    = data.terraform_remote_state.aws_vpcs.outputs.accepter_azs[1]
  subnet_id            = data.terraform_remote_state.aws_vpcs.outputs.accepter_subnet_ids[1]
  dc                   = var.nomad_aws_region1_dc
  instance_role        = "client"
  ami                  = var.client_ami
  nomad_instance_count = var.clients_count
  access_key           = var.access_key
  secret_key           = var.secret_key
  instance_type        = var.instance_type
  public_key           = var.public_key
  sg_id                = module.nomad_security_groups_region1.security_group_id
  domain_name          = var.subdomain_name
  zone_name            = var.cloudflare_zone
}

# Module that creates Nomad client instances in AWS region B, Nomad region B and Nomad dc1
module "aws-region2-nomad_client" {
  source = "./modules/aws/nomad_instance"

  region               = var.region2
  aws_vpc_id           = data.terraform_remote_state.aws_vpcs.outputs.requester_vpc_id
  availability_zone    = data.terraform_remote_state.aws_vpcs.outputs.requester_azs[1]
  subnet_id            = data.terraform_remote_state.aws_vpcs.outputs.requester_subnet_ids[1]
  dc                   = var.nomad_aws_region2_dc
  ami                  = var.region2_client_ami
  nomad_region         = var.nomad_aws_region2
  instance_role        = "client"
  nomad_instance_count = var.clients_count
  access_key           = var.access_key
  secret_key           = var.secret_key
  instance_type        = var.instance_type
  sg_id                = module.nomad_security_groups_region2.security_group_id
  domain_name          = var.subdomain_name
  public_key           = var.public_key
  zone_name            = var.cloudflare_zone
}

# Module that creates Nomad frontend instance
module "nomad_frontend" {
  source = "./modules/nomad_frontend"

  region              = var.region
  aws_vpc_id          = data.terraform_remote_state.aws_vpcs.outputs.accepter_vpc_id
  availability_zone   = data.terraform_remote_state.aws_vpcs.outputs.accepter_azs[0]
  subnet_id           = data.terraform_remote_state.aws_vpcs.outputs.accepter_subnet_ids[0]
  frontend_region     = var.nomad_aws_region1
  access_key          = var.access_key
  secret_key          = var.secret_key
  instance_type       = var.instance_type
  public_key          = var.public_key
  backend_private_ips = module.aws-region1-nomad_server.instance_private_ip
  cloudflare_token    = var.cloudflare_token
  cloudflare_zone     = var.cloudflare_zone
  subdomain_name      = var.subdomain_name
  cloudflare_email    = var.cloudflare_email
  nomad_region        = var.nomad_aws_region1
}

// ************* GCP Part ************* //

# Module that creates Nomad server instances
module "gcp-nomad_server" {
  source = "./modules/gcp/nomad_instance"

  gcp_project_id            = var.gcp_project_id
  gcp_credentials_file_path = var.gcp_credentials_file_path
  gcp_region                = var.gcp_region
  nomad_instance_count      = var.servers_count
  gcp_disk_image            = var.gcp_disk_image
  dc                        = var.nomad_gcp_region_dc
  nomad_region              = var.nomad_gcp_region
  authoritative_region      = var.authoritative_region
  gcp_instance_type         = var.gcp_instance_type
  gcp-vpc-network           = data.terraform_remote_state.gcp_vpc.outputs.gcp_vpc_network_id
  gcp-subnet1-name          = data.terraform_remote_state.gcp_vpc.outputs.gcp_vpc_network_subnet_id
  domain_name               = var.subdomain_name
  zone_name                 = var.cloudflare_zone
  secure_gossip             = random_id.server_gossip.b64_std
}

# Module that creates Nomad client instances
module "gcp-nomad_client" {
  source = "./modules/gcp/nomad_instance"

  gcp_project_id            = var.gcp_project_id
  gcp_credentials_file_path = var.gcp_credentials_file_path
  gcp_region                = var.gcp_region
  dc                        = var.nomad_gcp_region_dc
  nomad_region              = var.nomad_gcp_region
  instance_role             = "client"
  nomad_instance_count      = var.clients_count
  gcp_disk_image            = var.gcp_client_disk_image
  gcp_instance_type         = var.gcp_instance_type
  gcp-vpc-network           = data.terraform_remote_state.gcp_vpc.outputs.gcp_vpc_network_id
  gcp-subnet1-name          = data.terraform_remote_state.gcp_vpc.outputs.gcp_vpc_network_subnet_id
  domain_name               = var.subdomain_name
  zone_name                 = var.cloudflare_zone
}

// ************* NOMAD Cluster Federetaion ************* //

resource "null_resource" "nomad_federation_aws" {
  depends_on = [
    module.aws-region1-nomad_server,
    module.aws-region2-nomad_server,
    module.gcp-nomad_server,
    module.nomad_frontend,
  ]

  provisioner "remote-exec" {
    # create nomad multi-region federation
    inline = [
      "export NOMAD_ADDR=https://${var.subdomain_name}.${var.cloudflare_zone}",
      "nomad server join '${module.aws-region2-nomad_server.private_ips[0]}'",
      "nomad server join '${module.gcp-nomad_server.instance_private_ip[0]}'",
    ]

    connection {
      host        = module.aws-region1-nomad_server.private_ips[0]
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
    }
  }
}