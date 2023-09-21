data "google_compute_image" "fgt_image" {
  project         = "fortigcp-project-001"
  family          = "fortigate-74-payg"
}

data "google_compute_default_service_account" "default" {}

resource "google_compute_instance" "fgt" {
  zone                   = var.gcp_zone
  name                   = "fortigate"
  machine_type           = "e2-standard-4"
  can_ip_forward         = true
  tags                   = ["fgt"]

  boot_disk {
    initialize_params {
      image              = data.google_compute_image.fgt_image.self_link
    }
  }
  attached_disk {
    source               = google_compute_disk.logdisk.name
  }

  service_account {
    email                = data.google_compute_default_service_account.default.email
    scopes               = ["cloud-platform"]
  }

  metadata = {
    user-data            = file("fgt.config")
    serial-port-enable   = true
  }

  network_interface {
    subnetwork           = google_compute_subnetwork.pub.id
    access_config {}
  }
  network_interface {
    subnetwork           = google_compute_subnetwork.priv.id
  }
} //fgt-vm



resource "google_compute_disk" "logdisk" {
  name                   = "fgt-logdisk"
  size                   = 10
  type                   = "pd-ssd"
  zone                   = var.gcp_zone
}