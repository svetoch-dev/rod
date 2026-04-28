terraform {
  required_providers {
    deepmerge = {
      source  = "isometry/deepmerge"
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

module "cloud" {
  source    = "git::https://github.com/svetoch-dev/tf-modules.git//modules/rod/cloud/{env.cloud.name}?ref=33b39cac56d526de1e0f01af44fab98e07f62d91"
  company   = var.company
  ci        = var.ci
  int_env   = var.envs.internal
  env       = local.env
  overrides = local.overrides
}
