resource "google_compute_firewall" "allow-http" {
  name = "fw-allow-http"
  network = var.network
  source_ranges = ["0.0.0.0/0"]
  direction     = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
}
# allow https traffic
resource "google_compute_firewall" "allow-https" {
  name = "fw-allow-https"
  network = var.network
  source_ranges = ["0.0.0.0/0"]
  direction     = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
}
# allow ssh traffic
resource "google_compute_firewall" "allow-ssh" {
  name = "fw-allow-ssh"
  network = var.network
  source_ranges = ["0.0.0.0/0"]
  direction     = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

# allow kubectl traffic
resource "google_compute_firewall" "allow-kubectl" {
  name = "fw-allow-kubectl"
  network = var.network
  source_ranges = ["0.0.0.0/0"]
  direction     = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["6643"]
  }
}