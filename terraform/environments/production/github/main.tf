terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "6.4.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.6"
    }
  }
  required_version = "~> 1.7"
  backend "gcs" {
    bucket = "{COMPANY_NAME}-tf-state"
    prefix = "{ENV_NAME}/github"
  }
}

provider "github" {
  owner = var.github.org
}

data "terraform_remote_state" "remote_state" {
  for_each = local.remote_state_config
  backend  = "gcs"

  config = each.value.config
}

module "github" {
  source       = "git::https://github.com/ggramal/tf-modules.git//modules/github?ref=github-v0.1.0"
  repositories = local.repos
}
