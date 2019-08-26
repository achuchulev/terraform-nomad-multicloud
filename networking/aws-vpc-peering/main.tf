// ************* Get data from "aws-vpcs" module tfstate ************* //

data "terraform_remote_state" "aws_vpc_peering" {
  backend = "local"

  config = {
    path = "../aws-vpcs/terraform.tfstate"
  }
}


module "vpc_peering" {
  source = "git@github.com:achuchulev/terraform-aws-existing-vpcs-peering.git"

  requester_aws_access_key = var.requester_aws_access_key
  requester_aws_secret_key = var.requester_aws_secret_key
  requester_region         = var.requester_region

  accepter_aws_access_key = var.accepter_aws_access_key
  accepter_aws_secret_key = var.accepter_aws_secret_key
  accepter_region         = var.accepter_region

  requester_vpc_id = data.terraform_remote_state.aws_vpc_peering.outputs.requester_vpc_id
  accepter_vpc_id  = data.terraform_remote_state.aws_vpc_peering.outputs.accepter_vpc_id

}
