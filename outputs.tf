// AWS Part outs

# NW

output "aws_vpc_id" {
  value = module.new_aws_vpc.vpc_id
}

output "aws_vpc_name" {
  value = module.new_aws_vpc.vpc_name
}


output "aws_subnet_ids" {
  value = module.new_aws_vpc.subnet_ids
}

# Nomad

output "aws_server_private_ips" {
  value = module.nomad_cluster_on_aws.server_private_ips
}

output "aws_client_private_ips" {
  value = module.nomad_cluster_on_aws.client_private_ips
}

output "aws_frontend_public_ip" {
  value = module.nomad_cluster_on_aws.frontend_public_ip
}

output "AWS_Nomad_UI_URL" {
  value = module.nomad_cluster_on_aws.ui_url
}

// GCP Outs

# NW

output "gcp_vpc_network_id" {
  value = module.new_gcp_vpc.gcp_vpc_network_id
}

output "gcp_vpc_network_subnet_id" {
  value = module.new_gcp_vpc.gcp_vpc_network_subnet_id
}

# Nomad

output "gcp_server_private_ips" {
  value = module.nomad_cluster_on_gcp.server_private_ips
}

output "gcp_client_private_ips" {
  value = module.nomad_cluster_on_gcp.client_private_ips
}

output "gcp_frontend_public_ip" {
  value = module.nomad_cluster_on_gcp.frontend_public_ip
}

output "gcp_Nomad_UI_URL" {
  value = module.nomad_cluster_on_gcp.ui_url
}

# Client VPN

output "client_vpn_id" {
  value = module.aws-client-vpn.client_vpn_endpoint_id
}
