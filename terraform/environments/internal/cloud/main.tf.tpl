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
    deepmerge = {
      source  = "isometry/deepmerge"
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
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/rod/cloud?ref=rod-v0.1.0"
  company   = var.company
  ci        = var.ci
  env       = provider::deepmerge::mergo(
    local.env,
    {
      cloud = {
        location = {
          region       = local.env.cloud.region
          default_zone = local.env.cloud.default_zone
          multi_region = local.env.cloud.multi_region
        }
      }
    }
  )
  overrides = local.overrides
}
