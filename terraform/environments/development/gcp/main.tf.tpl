provider "google" {
  project = local.gcp_project.name
  region  = local.gcp_project.region
  zone    = local.gcp_project.default_zone
}

provider "google-beta" {
  project = local.gcp_project.name
  region  = local.gcp_project.region
  zone    = local.gcp_project.default_zone
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.45.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "5.45.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.3"
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


module "gcp" {
  source = "git::https://github.com/ggramal/tf-modules.git//modules/gcp?ref=gcp-v1.6.1"
  project = {
    id     = local.gcp_project.name
    region = local.gcp_project.region
  }

  activate_apis = local.activate_apis
  networks      = local.networks
  gke_clusters  = local.gke_clusters
  gars          = local.gars
  iam           = local.iam
  dns_zones     = local.dns_zones
  gcs           = local.gcs
}
