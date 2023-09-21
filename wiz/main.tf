#resource "google_compute_network" "default" {
#  name                    = var.network_name
#  auto_create_subnetworks = false
#}

#resource "google_compute_subnetwork" "default" {
#  name                     = var.network_name
#  ip_cidr_range            = "172.18.1.0/24"
#  network                  = google_compute_network.default.self_link
#  region                   = var.region
#  private_ip_google_access = true
#}

data "google_client_config" "current" {
}

data "google_container_engine_versions" "default" {
  location = var.location
}

resource "google_container_cluster" "default" {
  name               = var.cluster_name
  location           = var.location
  initial_node_count = 1
  min_master_version = data.google_container_engine_versions.default.latest_master_version
  network            = var.network_name
  subnetwork         = var.sub_network_name
  enable_intranode_visibility = true
  default_snat_status {
    disabled = true
  }

  ip_allocation_policy {
    cluster_secondary_range_name = "gkepods"
    services_secondary_range_name = "gkeservices"
  }

  // Use legacy ABAC until these issues are resolved: 
  //   https://github.com/mcuadros/terraform-provider-helm/issues/56
  //   https://github.com/terraform-providers/terraform-provider-kubernetes/pull/73
  enable_legacy_abac = true

  // Wait for the GCE LB controller to cleanup the resources.
  // Wait for the GCE LB controller to cleanup the resources.
  provisioner "local-exec" {
    when    = destroy
    command = "sleep 90"
  }
}

#output "network" {
#  value = google_compute_subnetwork.default.network
#}

#output "subnetwork_name" {
#  value = google_compute_subnetwork.default.name
#}

output "cluster_name" {
  value = google_container_cluster.default.name
}

output "cluster_region" {
  value = var.region
}

output "cluster_location" {
  value = google_container_cluster.default.location
}

data "google_secret_manager_secret_version_access" "holq_image_pull_pwd" {
provider = google
project = "185351165646" # project ID hosts secrets
secret  = "holq_image_pull_pwd"
version = "1"
}

data "google_secret_manager_secret_version_access" "holq_client_secret" {
provider = google
project = "185351165646" # replace with your project ID
secret  = "holq_client_secret"
version = "1"
}

data "google_secret_manager_secret_version_access" "holq_client_id" {
provider = google
project = "185351165646" # replace with your project ID
secret  = "holq_client_id"
version = "1"
}

data "google_secret_manager_secret_version_access" "holq_image_pull_username" {
provider = google
project = "185351165646" # replace with your project ID
secret  = "holq_image_pull_username"
version = "1"
}
