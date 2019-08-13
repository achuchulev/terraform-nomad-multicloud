// Check ERs related to Client VPN Endpoint terraform resource and replace aws cli with the new resource attributes
// https://github.com/terraform-providers/terraform-provider-aws/issues/7494
// https://github.com/terraform-providers/terraform-provider-aws/pull/7564
// https://github.com/terraform-providers/terraform-provider-aws/issues/7831
// https://github.com/terraform-providers/terraform-provider-aws/issues/7523


// ************* Get data from "aws-vpc-peering" module tfstate ************* //

data "terraform_remote_state" "aws_vpc_peering" {
  backend = "local"

  config = {
    path = "../aws-vpc-peering/terraform.tfstate"
  }
}

resource "aws_acm_certificate" "client_cert" {
  private_key       = file("easy-rsa/${var.cert_dir}/client1.${var.domain}.key")
  certificate_body  = file("easy-rsa/${var.cert_dir}/client1.${var.domain}.crt")
  certificate_chain = file("easy-rsa/${var.cert_dir}/ca.crt")
}

resource "aws_acm_certificate" "server_cert" {
  private_key       = file("easy-rsa/${var.cert_dir}/server.key")
  certificate_body  = file("easy-rsa/${var.cert_dir}/server.crt")
  certificate_chain = file("easy-rsa/${var.cert_dir}/ca.crt")
}

resource "aws_ec2_client_vpn_endpoint" "client-vpn-endpoint" {
  description            = "terraform-clientvpn-endpoint"
  server_certificate_arn = aws_acm_certificate.server_cert.arn
  client_cidr_block      = "10.10.0.0/16"

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = aws_acm_certificate.client_cert.arn
  }

  connection_log_options {
    enabled = false
  }

  tags = {
    Name = "test"
  }
}

resource "aws_ec2_client_vpn_network_association" "client-vpn-network-association" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client-vpn-endpoint.id
  subnet_id              = data.terraform_remote_state.aws_vpc_peering.outputs.requester_subnet_ids[0]
}

resource "null_resource" "authorize-client-vpn-ingress" {
  provisioner "local-exec" {
    command = "aws --region ${var.aws_region} ec2 authorize-client-vpn-ingress --client-vpn-endpoint-id ${aws_ec2_client_vpn_endpoint.client-vpn-endpoint.id} --target-network-cidr 0.0.0.0/0 --authorize-all-groups"
  }

  depends_on = [aws_ec2_client_vpn_endpoint.client-vpn-endpoint]
}

resource "null_resource" "create-client-vpn-route" {
  provisioner "local-exec" {
    command = "aws --region ${var.aws_region} ec2 create-client-vpn-route --client-vpn-endpoint-id ${aws_ec2_client_vpn_endpoint.client-vpn-endpoint.id} --destination-cidr-block 0.0.0.0/0 --target-vpc-subnet-id ${data.terraform_remote_state.aws_vpc_peering.outputs.requester_subnet_ids[0]} --description Internet-Access"
  }

  depends_on = [aws_ec2_client_vpn_endpoint.client-vpn-endpoint]
}

resource "null_resource" "export-client-config" {
  provisioner "local-exec" {
    command = "aws --region ${var.aws_region} ec2 export-client-vpn-client-configuration --client-vpn-endpoint-id ${aws_ec2_client_vpn_endpoint.client-vpn-endpoint.id} --output text>${path.root}/client-config.ovpn"
  }

  depends_on = [
    aws_ec2_client_vpn_endpoint.client-vpn-endpoint,
    null_resource.authorize-client-vpn-ingress,
    null_resource.create-client-vpn-route,
    aws_ec2_client_vpn_network_association.client-vpn-network-association,
  ]
}

resource "null_resource" "append-client-config-certs" {
  provisioner "local-exec" {
    command = "scripts/client_config_append_certs_path.sh ${path.root} ${var.cert_dir} ${var.domain}"
  }

  depends_on = [null_resource.export-client-config]
}

