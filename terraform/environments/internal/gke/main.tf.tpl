terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
    }
  }

  backend "{tf_backend.type}" {
  }
}

data "terraform_remote_state" "remote_state" {
  for_each = local.remote_state_config
  backend  = local.env.tf_backend.type

  config = each.value.config
}

data "google_client_config" "provider" {}

provider "kubernetes" {
  host  = "https://${local.remote_state.k8s_clusters[local.env.short_name].endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    local.remote_state.k8s_clusters[local.env.short_name].ca_certificate
  )
}

module "gke" {
  source     = "git::https://github.com/svetoch-dev/tf-modules.git//modules/k8s?ref=k8s-v0.2.0"
  rbac       = local.rbac
  namespaces = local.namespaces
}
