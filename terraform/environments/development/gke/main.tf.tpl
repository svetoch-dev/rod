terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.12.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.34.0"
    }
  }

  required_version = "~> 1.7"

  backend "{tf_backend.type}" {
  }
}

data "terraform_remote_state" "remote_state" {
  for_each = local.remote_state_config
  backend  = "gcs"

  config = each.value.config
}

data "google_client_config" "provider" {}

data "google_container_cluster" "gke_clusters" {
  for_each = {
    for gke_cluster_name, gke_cluster_obj in local.gke_clusters :
    gke_cluster_name => gke_cluster_obj
    if gke_cluster_obj.enabled
  }
  name     = each.value.name
  location = each.value.location
  project  = each.value.project
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.gke_clusters["this"].endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.gke_clusters["this"].master_auth[0].cluster_ca_certificate
  )
}

module "gke" {
  source     = "git::https://github.com/ggramal/tf-modules.git//modules/k8s?ref=k8s-v0.1.0"
  rbac       = local.rbac
  namespaces = local.namespaces
}
