output "gcp_vpc_network_id" {
  value = google_compute_network.gcp-vpc-network.name
}

output "gcp_vpc_network_subnet_id" {
  value = google_compute_subnetwork.gcp-vpc-subnet1.name
}

