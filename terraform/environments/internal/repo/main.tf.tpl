terraform {
  required_providers {
  }

  backend "{tf_backend.type}" {
  }
}

data "terraform_remote_state" "remote_state" {
  for_each = local.remote_state_config
  backend  = local.env.tf_backend.type

  config   = each.value.config
}

module "repos" {
  source    = "git::https://github.com/svetoch-dev/tf-modules.git//modules/rod/repos/{repo.type}?ref=33b39cac56d526de1e0f01af44fab98e07f62d91"
  repo      = var.repo
  overrides = local.overrides
}
