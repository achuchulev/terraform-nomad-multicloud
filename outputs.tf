// AWS Part outs

## Outputs  AWS Region A
output "aws-region1-nomad_server_public_ip" {
  value = module.aws-region1-nomad_server.instance_public_ip
}

output "aws-region1-nomad_server_private_ip" {
  value = module.aws-region1-nomad_server.instance_private_ip
}

output "aws-region1-nomad_server_tags" {
  value = module.aws-region1-nomad_server.instance_tags
}

output "aws-region1-nomad_client_public_ip" {
  value = module.aws-region1-nomad_client.instance_public_ip
}

output "aws-region1-nomad_client_private_ip" {
  value = module.aws-region1-nomad_client.instance_private_ip
}

output "aws-region1-nomad_server_private_ips" {
  value = module.aws-region1-nomad_server.private_ips
}

output "aws-region1-nomad_client_tags" {
  value = module.aws-region1-nomad_client.instance_tags
}

## Outputs AWS Region B

output "aws-region2-nomad_server_public_ip" {
  value = module.aws-region2-nomad_server.instance_public_ip
}

output "aws-region2-nomad_server_private_ip" {
  value = module.aws-region2-nomad_server.private_ips
}

output "aws-region2-nomad_server_tags" {
  value = module.aws-region2-nomad_server.instance_tags
}

output "aws-region2-nomad_client_public_ip" {
  value = module.aws-region2-nomad_client.instance_public_ip
}

output "aws-region2-nomad_client_private_ip" {
  value = module.aws-region2-nomad_client.instance_private_ip
}

output "aws-region2-nomad_client_tags" {
  value = module.aws-region2-nomad_client.instance_tags
}

## Output frontend

output "frontend_server_public_ip" {
  value = module.nomad_frontend.public_ip
}



// GCP Outs

output "gcp-region-nomad_server_public_ip" {
  value = module.gcp-nomad_server.instance_public_ip
}

output "gcp-region-nomad_server_private_ip" {
  value = module.gcp-nomad_server.instance_private_ip
}

output "gcp-region-nomad_client_public_ip" {
  value = module.gcp-nomad_client.instance_public_ip
}

output "gcp-region-nomad_client_private_ip" {
  value = module.gcp-nomad_client.instance_private_ip
}