provider "google" {
  project = local.env.cloud.id
  region  = local.env.cloud.region
  zone    = local.env.cloud.default_zone
}

provider "google-beta" {
  project = local.env.cloud.id
  region  = local.env.cloud.region
  zone    = local.env.cloud.default_zone
}


terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
    }
    random = {
      source  = "hashicorp/random"
    }
    null = {
      source  = "hashicorp/null"
    }
  }

  backend "{tf_backend.type}" {
  }
}

data "terraform_remote_state" "remote_state" {
  for_each = local.remote_state_config
  backend  = "gcs"

  config = each.value.config
}

module "cloud" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/rod/cloud?ref=fb613ec03205c373c0c6fea81d480b107a744ae3"
  company = var.company
  ci = var.ci

  env = {
    name          = local.env.name
    short_name    = local.env.short_name
    cloud = {
      name       = local.env.cloud.name
      id         = local.env.cloud.id
      numeric_id = data.google_project.project.number
      location = {
          region          = local.env.cloud.region
          default_zone    = local.env.cloud.default_zone
          multi_region    = local.env.cloud.multi_region
          available_zones = data.google_compute_zones.available.names
      }
      network = {
          vm_cidr          = "10.16.0.0/20"
          k8s_pod_cidr     = "10.20.0.0/14"
          k8s_service_cidr = "10.17.0.0/20"
      }
      buckets = local.env.cloud.buckets
    }
    kubernetes = local.env.kubernetes
  }

  overrides = local.overrides
}
