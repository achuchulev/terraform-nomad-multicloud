variable "gcp_credentials_file_path" {
  description = "Locate the GCP credentials .json file"
  type        = string
}

variable "gcp_project_id" {
  description = "GCP Project ID."
  type        = string
}

variable "gcp_region" {
  description = "Default to N.Virginia region"
  default     = "us-east4"
}

variable "gcp_subnet1_cidr" {
  description = "VPC subnet CIDR block"
  default     = "10.24.0.0/24"
}

