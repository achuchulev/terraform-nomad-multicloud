// AWS VARs

# Networking
variable "access_key" {}
variable "secret_key" {}
variable "aws_region" {}

variable "gcp_credentials_file_path" {}
variable "gcp_region" {}
variable "gcp_project_id" {}
variable "gcp_subdomain_name" {}

variable "cloudflare_email" {}
variable "cloudflare_token" {}
variable "cloudflare_zone" {}
variable "aws_subdomain_name" {}

variable "vpc_name" {
  description = "Set a VPC Name tag"
  default     = ""
}

variable "region" {
  description = "Set a VPC Side tag"
  default     = ""
}

variable "vpc_cidr_block" {
  description = "Define requester VPC cidr blocks"
  default     = "10.100.0.0/16"
}

variable "vpc_subnet_cidr_blocks" {
  type        = list(string)
  description = "Define VPC subnet cidr blocks"
  default     = ["10.100.0.0/24", "10.100.1.0/24"]
}

variable "gcp_subnet1_cidr" {
  description = "Define gcp VPC cidr blocks"
  default     = "10.200.0.0/24"
}

variable "nomad_region_aws" {
  default = "aws"
}

variable "nomad_region_gcp" {
  default = "gcp"
}

variable "authoritative_region" {
  default = "aws"
}