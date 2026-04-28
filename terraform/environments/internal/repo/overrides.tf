locals {
  overrides = {
    repos = {
      infra = {
        name = var.repo.name
        org  = var.ci.group
        vars = {
          bazelisk_image = {
            name  = "BAZELISK_IMAGE"
            value = "${local.env.registry.url}/bazelisk:${local.bazelisk_img_version}"
          }
        }
      }
    }
  }
}
