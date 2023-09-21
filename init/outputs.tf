output "fgt_address" {
    value = google_compute_instance.fgt.network_interface[0].access_config[0].nat_ip
}

output "fgt_password" {
    value = google_compute_instance.fgt.instance_id
}