
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
resource "google_compute_firewall" "gcp-allow-internet" {
  name    = "${google_compute_network.gcp-vpc-network.name}-gcp-allow-internet"
  network = google_compute_network.gcp-vpc-network.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = [
    "0.0.0.0/0",
  ]
}

