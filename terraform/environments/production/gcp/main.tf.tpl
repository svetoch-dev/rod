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


module "gcp" {
  source = "git::https://github.com/ggramal/tf-modules.git//modules/gcp?ref=gcp-v2.0.0"
  project = {
    id     = local.env.cloud.id
    region = local.env.cloud.region
  }

  activate_apis = local.activate_apis
  networks      = local.networks
  gke_clusters  = local.gke_clusters
  gars          = local.gars
  iam           = local.iam
  dns_zones     = local.dns_zones
  gcs           = local.gcs
}
