terraform {
  required_providers {
    secret = {
      source  = "inspectorioinc/secret"
      version = "1.1.5"
    }
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
  backend "{backend_type}" {
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


module "secrets" {
  source = "git::https://github.com/ggramal/tf-modules.git//modules/secrets?ref=secrets-v0.2.0"
  for_each = merge(
    local.prometheus,
  )
  name              = each.value.name
  secrets_to_import = try(each.value.secrets_to_import, [])
  secrets_data      = try(each.value.secrets_data, {})
  labels            = each.value.labels
  annotations       = each.value.annotations
  k8s               = each.value.k8s
  base64_secrets    = try(each.value.base64_secrets, false)
}
