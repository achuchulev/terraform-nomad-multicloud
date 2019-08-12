output "aws_vpn_gateway_id" {
  value = aws_vpn_gateway.aws-vpn-gw.id
}
output "aws_customer_gateway_id" {
  value = aws_customer_gateway.aws-cgw.id
}
output "google_compute_vpn_gateway_id" {
  value = google_compute_vpn_gateway.gcp-vpn-gw.id
}
output "google_compute_vpn_tunnel1_status" {
  value = google_compute_vpn_tunnel.gcp-tunnel1.detailed_status
}
output "google_compute_vpn_tunnel2_status" {
  value = google_compute_vpn_tunnel.gcp-tunnel2.detailed_status
}

