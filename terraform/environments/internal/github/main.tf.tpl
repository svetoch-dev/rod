terraform {
  required_providers {
    github = {
      source  = "integrations/github"
    }
    tls = {
      source  = "hashicorp/tls"
    }
  }

  backend "{tf_backend.type}" {
  }
}

provider "github" {
  owner = var.ci.group
}

data "terraform_remote_state" "remote_state" {
  for_each = local.remote_state_config
  backend  = "gcs"

  config = each.value.config
}

module "github" {
  source       = "git::https://github.com/ggramal/tf-modules.git//modules/github?ref=github-v0.1.1"
  repositories = local.repos
}
