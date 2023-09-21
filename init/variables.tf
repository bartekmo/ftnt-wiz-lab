variable "gcp_project_id" {
  type        = string
  description = "The GCP Project ID to apply this config to."
  default = "ftnt-wiz-lab"
}
variable "gcp_region" {
  type        = string
  description = "The GCP region to apply this config to."
  default = "us-central1"
}
variable "gcp_zone" {
  type        = string
  description = "The GCP zone to apply this config to."
  default = "us-central1-a"
}