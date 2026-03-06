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

module "cloud_config" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/{env.cloud.name}/client_config?ref=v0.6.0"
  provider_config =  {
    id            = local.env.cloud.id
    region        = local.env.cloud.region
    default_zone  = local.env.cloud.default_zone
    folder_id     = local.env.cloud.folder_id
  }
}

module "repo" {
  source    = "git::https://github.com/svetoch-dev/tf-modules.git//modules/rod/repos/{repo.type}?ref=rod-repo"
  repo      = var.repo
  overrides = local.overrides
}
