locals {
  bazelisk_img_version = var.ci.bazelisk_img_version == "" ? trimspace(file("../../../../deps/images/bazelisk/image_tag.txt")) : var.ci.bazelisk_img_version

  remote_state_config = {
  }

  remote_state = {
  }

  app_env_ci_configs = flatten([
    for env_name, env_obj in var.envs :
    [
      for app_name, app_obj in env_obj.apps :
      {
        app_name = coalesce(app_obj.name, app_name)
        cd       = app_obj.cd
        repo     = app_obj.repo
        env = {
          short_name   = env_obj.short_name
          registry_url = app_obj.cd == null ? null : env_obj.registry.url
        }
      }
      if app_obj.repo != null && length(app_obj.repo) > 0
    ]
    if env_obj.apps != null
  ])
}
