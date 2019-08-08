// ************* GLOBAL VARS ************** //

variable "servers_count" {
  description = "The number of servers to provision."
  default     = "3"
}

variable "clients_count" {
  description = "The number of clients to provision."
  default     = "3"
}

variable "instance_role" {}

// ************** Nomad VARS *************** //

variable "nomad_aws_region1" {
  description = "The name of Nomad region."
  type        = string
  default     = "global"
}

variable "nomad_aws_region1_dc" {
  description = "The name of Nomad datacenter."
  type        = string
  default     = "dc1"
}

variable "nomad_aws_region2" {
  description = "The name of Nomad region."
  type        = string
  default     = "global"
}

variable "nomad_aws_region2_dc" {
  description = "The name of Nomad datacenter."
  type        = string
  default     = "dc1"
}

variable "nomad_gcp_region" {
  description = "The name of Nomad region."
  type        = string
  default     = "global"
}

variable "nomad_gcp_region_dc" {
  description = "The name of Nomad datacenter."
  type        = string
  default     = "dc1"
}

variable "authoritative_region" {
  description = "Points the Nomad's authoritative region."
  type        = string
  default     = "global"
}


// ************ Frontend VARS ************** //

variable "cloudflare_email" {}

variable "cloudflare_token" {}

variable "cloudflare_zone" {}

variable "subdomain_name" {}

// ************** AWS VARS **************** //


variable "access_key" {}

variable "secret_key" {}

variable "public_key" {}

variable "region" {
  default = "us-east-1"
}

variable "region2" {
  default = "us-east-2"
}

# variable "availability_zone" {
#   default = "us-east-1b"
# }

# variable "region2_availability_zone" {
#   default = "us-east-2c"
# }

variable "instance_type" {}

# variable "vpc_id" {}

# variable "region2_vpc_id" {}

# variable "subnet_id" {}

# variable "region2_subnet_id" {}

variable "server_ami" {
  default = "ami-0ac8c1373dae0f3e5"
}

variable "client_ami" {
  default = "ami-02ffa51d963317aaf"
}

variable "region2_server_ami" {
  default = "ami-0e2aa4ea219d7657e"
}

variable "region2_client_ami" {
  default = "ami-0e431df20c101e6b7"
}

// ************** GCP VARS **************** //

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

# variable "gcp-vpc-network" {
# }

# variable "gcp-subnet1-name" {
# }

variable "gcp_instance_type" {
  description = "Machine Type. Correlates to an network egress cap."
  default     = "n1-standard-1"
}

variable "gcp_disk_image" {
  description = "Boot disk for gcp_instance_type."
  default     = "nomad-multiregion/ubuntu-1604-xenial-nomad-server-v093"
}

variable "gcp_client_disk_image" {
  description = "Client boot disk for gcp_instance_type."
  default     = "nomad-multiregion/ubuntu-1604-xenial-nomad-client-v093"
}

variable "gcp_frontend_disk_image" {
  description = "Frontend boot disk for gcp_instance_type."
  default     = "nomad-multiregion/ubuntu-1604-xenial-nginx-v001"
}
