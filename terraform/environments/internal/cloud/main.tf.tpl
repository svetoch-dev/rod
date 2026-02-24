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
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/rod/cloud/{env.cloud.name}?ref=c0c77f349b8e90866d46ec68912b486b086ac93b"
  company   = var.company
  ci        = var.ci
  int_env   = var.envs.internal
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
