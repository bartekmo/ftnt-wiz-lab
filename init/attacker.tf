resource "google_compute_instance" "fake_attacker" {
    name = "fake-attacker"
    machine_type = "e2-micro"
    zone = var.gcp_zone

    boot_disk {
        initialize_params {
            image = "ubuntu-os-cloud/ubuntu-2204-lts"
            labels = {
                my_label = "value"
            }
        }
    }

    network_interface {
        subnetwork = google_compute_subnetwork.pub.id
        access_config {}
    }

    metadata_startup_script = <<EOF
apt update && apt install nginx -y
mkdir /var/www/html/1
touch /var/www/html/1/xmrig
touch /var/www/html/1/xmrig.so
mkdir /var/www/html/incoming/access_data
touch /var/www/html/incoming/access_data/k8.php
touch /var/www/html/incoming/access_data/aws.php
sed -i '24 i error_page  405     =200 $uri;' default
systemctl restart nginx
EOF
}

# error_page  405     =200 $uri;

resource "google_dns_managed_zone" "xmrig" {
  name        = "fake-xmrig-com"
  dns_name    = "xmrig.com."

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = google_compute_network.priv.id
    }
  }
}

resource "google_dns_managed_zone" "c2" {
  name        = "c2"
  dns_name    = "c2."

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = google_compute_network.priv.id
    }
  }
}

resource "google_dns_record_set" "xmrig" {
  name = "fakepool.${google_dns_managed_zone.xmrig.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.xmrig.name

  rrdatas = [google_compute_instance.fake_attacker.network_interface[0].access_config[0].nat_ip]
}

resource "google_dns_record_set" "c2" {
  name = "attacker.${google_dns_managed_zone.c2.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.c2.name

  rrdatas = [google_compute_instance.fake_attacker.network_interface[0].access_config[0].nat_ip]
}