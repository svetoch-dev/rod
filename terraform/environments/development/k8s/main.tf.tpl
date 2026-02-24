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
  source    = "git::https://github.com/svetoch-dev/tf-modules.git//modules/{env.cloud.name}/client_config?ref=v0.1.0"
  provider_config =  {
    id            = local.env.cloud.id
    region        = local.env.cloud.region
    default_zone  = local.env.cloud.default_zone
    folder_id     = local.env.cloud.folder_id
  }
}

module "k8s" {
  source    = "git::https://github.com/svetoch-dev/tf-modules.git//modules/rod/k8s?ref=c0c77f349b8e90866d46ec68912b486b086ac93b"
  k8s_api   = local.k8s_api
  ci        = var.ci
  int_env   = var.envs.internal
  env       = local.env
  overrides = local.overrides
}
