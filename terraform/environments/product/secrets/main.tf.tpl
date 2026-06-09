terraform {
  required_providers {
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

module "cloud_config" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/{env.cloud.name}/client_config?ref=v0.21.1"
  provider_config =  {
    id            = local.env.cloud.id
    region        = local.env.cloud.location.region
    default_zone  = local.env.cloud.location.default_zone
    folder_id     = local.env.cloud.folder_id
  }
}

provider "kubernetes" {
  host                   = local.k8s_api.endpoint
  token                  = local.k8s_api.token
  cluster_ca_certificate = local.k8s_api.ca_cert
}

module "secrets" {
  source          = "git::https://github.com/svetoch-dev/tf-modules.git//modules/rod/secrets?ref=v0.21.1"
  env             = local.env
  argocd_clusters = {}
  argocd_repos    = {}
  overrides       = local.overrides
}
