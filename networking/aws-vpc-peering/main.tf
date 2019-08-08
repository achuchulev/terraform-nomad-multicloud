
module "vpc_requester" {
  source = "git@github.com:achuchulev/terraform-aws-vpc.git"

  aws_access_key = var.requester_aws_access_key
  aws_secret_key = var.requester_aws_secret_key
  aws_region     = var.requester_region

  vpc_cidr_block         = var.requester_vpc_cidr_block
  vpc_subnet_cidr_blocks = var.requester_vpc_subnet_cidr_blocks

  vpc_tags = {
    Name = var.requester_vpc_name
    Side = "Requester"
  }
}

module "vpc_accepter" {
  source = "git@github.com:achuchulev/terraform-aws-vpc.git"

  aws_access_key = var.accepter_aws_access_key
  aws_secret_key = var.accepter_aws_secret_key
  aws_region     = var.accepter_region

  vpc_cidr_block         = var.accepter_vpc_cidr_block
  vpc_subnet_cidr_blocks = var.accepter_vpc_subnet_cidr_blocks

  vpc_tags = {
    Name = var.accepter_vpc_name
    Side = "Accepter"
  }
}

module "inter_vpc_peering" {
  source = "git@github.com:achuchulev/terraform-aws-vpc-peering.git"

  enabled = var.activate_peering

  requester_aws_access_key = var.requester_aws_access_key
  requester_aws_secret_key = var.requester_aws_secret_key
  requester_region         = var.requester_region

  accepter_aws_access_key = var.accepter_aws_access_key
  accepter_aws_secret_key = var.accepter_aws_secret_key
  accepter_region         = var.accepter_region

  requester_vpc_id = module.vpc_requester.vpc_id
  accepter_vpc_id  = module.vpc_accepter.vpc_id

  requester_vpc_tags = {
    Name = module.vpc_requester.vpc_name
    Side = "Requester"
  }

  accepter_vpc_tags = {
    Name = module.vpc_accepter.vpc_name
    Side = "Accepter"
  }

  requester_peer_tags = {
    Name = "VPC peering between ${module.vpc_requester.vpc_name} and ${module.vpc_accepter.vpc_name}"
    Side = "Requester"
  }

  accepter_peer_tags = {
    Name = "VPC peering between ${module.vpc_requester.vpc_name} and ${module.vpc_accepter.vpc_name}"
    Side = "Accepter"
  }
}