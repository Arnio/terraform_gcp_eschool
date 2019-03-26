resource "google_compute_firewall" "ssh_firewall" {
  name    = "allow-ssh"
  network = "${google_compute_network.my_vpc_network.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  source_tags = ["ssh"]
}
resource "google_compute_firewall" "web_firewall" {
  name    = "allow-web"
  network = "${google_compute_network.my_vpc_network.name}"

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
  source_ranges = ["0.0.0.0/0"]
  source_tags = ["web"]
}