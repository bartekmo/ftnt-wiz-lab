resource "google_compute_network" "pub" {
    name = "public"
    auto_create_subnetworks = false
}

resource "google_compute_network" "priv" {
    name = "private"
    auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "pub" {
  name          = "public-subnet"
  ip_cidr_range = "172.18.0.0/24"
  region        = var.gcp_region
  network       = google_compute_network.pub.id
}

resource "google_compute_subnetwork" "priv" {
  name          = "private-subnet"
  ip_cidr_range = "172.18.1.0/24"
  region        = var.gcp_region
  network       = google_compute_network.priv.id
  secondary_ip_range {
    range_name    = "gkepods"
    ip_cidr_range = "10.0.1.0/24"
  }
  secondary_ip_range {
    range_name    = "gkeservices"
    ip_cidr_range = "10.0.2.0/24"
  }
}

resource "google_compute_firewall" "open_pub" {
  name    = "allow-all-public"
  network = google_compute_network.pub.name

  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "open_priv" {
  name    = "allow-all-private"
  network = google_compute_network.priv.name

  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_route" "via_fgt" {
  name        = "default-via-fgt"
  dest_range  = "0.0.0.0/0"
  network     = google_compute_network.priv.name
  next_hop_instance = google_compute_instance.fgt.id
  priority    = 10
}