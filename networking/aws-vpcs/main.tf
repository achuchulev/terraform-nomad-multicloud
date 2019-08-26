
module "vpc_requester" {
  source = "git@github.com:achuchulev/terraform-aws-vpc-public-private-subnets.git"

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
  source = "git@github.com:achuchulev/terraform-aws-vpc-public-private-subnets.git"

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