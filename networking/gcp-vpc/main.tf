
# New VPC networking resources for GCP

resource "google_compute_network" "gcp-vpc-network" {
  name                    = "gcp-vpc-network"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "gcp-vpc-subnet1" {
  name          = "gcp-vpc-subnet1"
  ip_cidr_range = var.gcp_subnet1_cidr
  network       = google_compute_network.gcp-vpc-network.name
  region        = var.gcp_region
}

resource "google_compute_router" "router" {
  name    = "router"
  region  = google_compute_subnetwork.gcp-vpc-subnet1.region
  network = google_compute_network.gcp-vpc-network.self_link
  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "simple-nat" {
  name                               = "nat-1"
  router                             = google_compute_router.router.name
  region                             = var.gcp_region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = google_compute_subnetwork.gcp-vpc-subnet1.self_link
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

# Allow ICMP
resource "google_compute_firewall" "gcp-allow-icmp" {
  name    = "${google_compute_network.gcp-vpc-network.name}-gcp-allow-icmp"
  network = google_compute_network.gcp-vpc-network.name

  allow {
    protocol = "icmp"
  }

  source_ranges = [
    "0.0.0.0/0",
  ]
}

# Allow SSH
resource "google_compute_firewall" "gcp-allow-ssh" {
  name    = "${google_compute_network.gcp-vpc-network.name}-gcp-allow-ssh"
  network = google_compute_network.gcp-vpc-network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = [
    "0.0.0.0/0",
  ]
}

# Allow TCP traffic from the Internet
# resource "google_compute_firewall" "gcp-allow-internet" {
#   name    = "${google_compute_network.gcp-vpc-network.name}-gcp-allow-internet"
#   network = google_compute_network.gcp-vpc-network.name

#   allow {
#     protocol = "tcp"
#     ports    = ["80", "443"]
#   }

#   source_ranges = [
#     "0.0.0.0/0",
#   ]
# }

