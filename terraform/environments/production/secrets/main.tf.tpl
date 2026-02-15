terraform {
  required_providers {
    secret = {
      source  = "inspectorioinc/secret"
    }
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

module "secrets" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/secrets?ref=secrets-v0.3.0"

  for_each          = local.secrets
  name              = each.value.name
  secrets_to_import = try(each.value.secrets_to_import, [])
  secrets_data      = try(each.value.secrets_data, {})
  annotations       = each.value.annotations
  labels            = each.value.labels
  k8s               = each.value.k8s
  base64_secrets    = try(each.value.base64_secrets, false)
}
