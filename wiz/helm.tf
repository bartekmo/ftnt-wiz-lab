variable "helm_version" {
  default = "v2.9.1"
}

provider "helm" {

  kubernetes {
    host                   = "${google_container_cluster.default.endpoint}"
    token                  = "${data.google_client_config.current.access_token}"
    client_certificate     = "${base64decode(google_container_cluster.default.master_auth.0.client_certificate)}"
    client_key             = "${base64decode(google_container_cluster.default.master_auth.0.client_key)}"
    cluster_ca_certificate = "${base64decode(google_container_cluster.default.master_auth.0.cluster_ca_certificate)}"
  }
}

resource "helm_release" "wiz_sensor" {
  count = var.deploy_sensor ? 1 : 0 

  name       = "wiz-sensor"
  namespace  = "wiz"
  create_namespace = true

  repository = "https://charts.wiz.io/"
  chart      = "wiz-sensor"

  set {
    name  = "imagePullSecret.username"
    value = data.google_secret_manager_secret_version_access.holq_image_pull_username.secret_data
  }

  set {
    name  = "imagePullSecret.password"
    value = data.google_secret_manager_secret_version_access.holq_image_pull_pwd.secret_data
  }

  set {
    name  = "wizApiToken.clientId"
    value = data.google_secret_manager_secret_version_access.holq_client_id.secret_data
  }

  set {
    name  = "wizApiToken.clientToken"
    value = data.google_secret_manager_secret_version_access.holq_client_secret.secret_data
  }
}