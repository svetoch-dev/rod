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
  source         = "git::https://github.com/svetoch-dev/tf-modules.git//modules/rod/ci/{ci.type}?ref=877b557d9d6692f896452309e8a75a56213ad181"
  bazelisk_image = "${local.env.registry.url}/bazelisk:${local.bazelisk_img_version}"
  repo           = var.repo
  ci             = var.ci
  ci_vars        = local.ci_vars
  overrides      = local.overrides
}
