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
        ci_name    = "${app_data.name == "" ? app_name : app_data.name}_${env_obj.short_name}"
        repo_name  = app_data.ci.repo_name
        repo_group = app_data.ci.repo_group
        cd_branch  = app_data.ci.cd_branch
        cd_file    = app_data.ci.cd_file
        cd_path    = app_data.ci.cd_path
        vars       = app_data.ci.vars
        secrets    = app_data.ci.secrets
      }
      if app_data.ci != null && length(app_data.ci) > 0
    ]
    if env_obj.apps != null && length(env_obj.apps) > 0
  ])
}
