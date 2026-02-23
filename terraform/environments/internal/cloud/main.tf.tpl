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
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/rod/cloud?ref=6cba23052dca8e1199180dd09ca06297fa5377db"
  company   = var.company
  ci        = var.ci
  apps      = {}
  int_env   = var.envs.internal
  provider_config =  {
    id            = local.env.cloud.id
    region        = local.env.cloud.region
    default_zone  = local.env.cloud.default_zone
    folder_id     = local.env.cloud.folder_id
  }
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
