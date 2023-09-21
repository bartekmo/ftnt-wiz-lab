variable "region" {
  default = "us-central1"
}

variable "location" {
  default = "us-central1-b"
}

variable "network_name" {
  default = "ftnt-wiz-private-vpc-blz"
}

variable "sub_network_name" {
  default = "ftnt-wiz-private-subnet-blz"
}

variable "cluster_name" {
  default = "tf-gke-k8s"
}

variable "deploy_sensor" {
  default = "1"
}

#variable "gcp_project_id" {
#  type        = string
#  description = "The GCP Project ID to apply this config to."
#}
#variable "gcp_region" {
#  type        = string
#  description = "The GCP region to apply this config to."
#}
#variable "gcp_zone" {
#  type        = string
#  description = "The GCP zone to apply this config to."
#}