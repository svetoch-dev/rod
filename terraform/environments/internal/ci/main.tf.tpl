terraform {
  backend "{tf_backend.type}" {
  }
}

data "terraform_remote_state" "remote_state" {
  for_each = local.remote_state_config
  backend  = local.env.tf_backend.type

  config = each.value.config
}

module "ci" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/rod/ci/{ci.type}?ref=v0.21.1"
  bazelisk_image     = "${local.env.registry.url}/bazelisk:${local.bazelisk_img_version}"
  repo               = var.repo
  ci                 = var.ci
  app_env_ci_configs = local.app_env_ci_configs
  overrides          = local.overrides
}
