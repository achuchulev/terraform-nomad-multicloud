variable "requester_aws_access_key" {}

variable "requester_aws_secret_key" {}

variable "requester_region" {}

variable "accepter_aws_access_key" {}

variable "accepter_aws_secret_key" {}

variable "accepter_region" {}

variable "enabled" {
  description = "Set to false to prevent the module from creating or accessing any resources"
  default     = "true"
}

variable "requester_vpc_id" {
  type        = string
  description = "Requester VPC ID"
}

variable "accepter_vpc_id" {
  type        = string
  description = "Acceptor VPC ID"
}