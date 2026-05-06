locals {
  bazelisk_img_version = var.ci.bazelisk_img_version == "" ? trimspace(file("../../../../deps/images/bazelisk/image_tag.txt")) : var.ci.bazelisk_img_version

  remote_state_config = {
    secrets = {
      config = {
        for key, value in local.env.tf_backend.configs :
        key => can(tostring(value)) ? replace(value, "/ci", "/secrets") : value
      }
    }
  }

  remote_state = {
    secrets = data.terraform_remote_state.remote_state["secrets"].outputs.secrets,
  }

  ci_vars = flatten([
    for env_name, env_obj in var.envs :
    [
      for app_name, app_data in env_obj.apps :
      {
        ci_name        = "${app_data.name == "" ? app_name : app_data.name}_${env_obj.short_name}"
        env_short_name = env_obj.short_name
        ci_data        = app_data.ci
      }
      if app_data.ci != null && length(app_data.ci) > 0
    ]
    if env_obj.apps != null && length(env_obj.apps) > 0
  ])
}
