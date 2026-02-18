terraform {
  backend "{tf_backend.type}" {
  }
}

data "terraform_remote_state" "remote_state" {
  for_each = local.remote_state_config
  backend  = local.env.tf_backend.type

  config = each.value.config
}

module "cloud_config" {
  source    = "git::https://github.com/svetoch-dev/tf-modules.git//modules/{env.cloud.name}/client_config?ref=44fcbbf7e8a869fcd7a7cd2a441e74772be5e22d"
  provider_config =  {
    id            = local.env.cloud.id
    region        = local.env.cloud.region
    default_zone  = local.env.cloud.default_zone
    folder_id     = local.env.cloud.folder_id
  }
}

module "k8s" {
  source    = "git::https://github.com/svetoch-dev/tf-modules.git//modules/rod/k8s?ref=44fcbbf7e8a869fcd7a7cd2a441e74772be5e22d"
  k8s_api   = local.k8s_api
  ci        = var.ci
  int_env   = var.envs.internal
  apps      = var.apps
  env       = local.env
  overrides = local.overrides
}
