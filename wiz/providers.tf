terraform {
  required_providers {
    google = {
      version = " ~> 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }
}

#provider "google" {
#    project = var.gcp_project_id
#    region  = var.gcp_region
#    zone    = var.gcp_zone
#}
