variable "requester_aws_access_key" {
}

variable "requester_aws_secret_key" {
}

variable "requester_region" {
}

variable "accepter_aws_access_key" {
}

variable "accepter_aws_secret_key" {
}

variable "accepter_region" {
}

variable "activate_peering" {
  description = "Set to false to prevent the module from creating or accessing any resources"
  default     = "true"
}

variable "requester_vpc_name" {
  description = "Set a VPC name"
  default     = ""
}

variable "accepter_vpc_name" {
  description = "Set a VPC name"
  default     = ""
}

variable "requester_vpc_cidr_block" {
  description = "Define requester VPC cidr blocks"
  default     = "10.100.0.0/16"
}

variable "accepter_vpc_cidr_block" {
  description = "Define accepter VPC cidr block"
  default     = "10.200.0.0/16"
}

variable "requester_vpc_subnet_cidr_blocks" {
  type        = list(string)
  description = "Define VPC subnet cidr blocks"
  default     = ["10.100.0.0/24", "10.100.1.0/24"]
}

variable "accepter_vpc_subnet_cidr_blocks" {
  type        = list(string)
  description = "Define VPC subnet cidr blocks"
  default     = ["10.200.0.0/24", "10.200.1.0/24"]
}

