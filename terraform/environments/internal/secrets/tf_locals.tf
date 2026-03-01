locals {
  k8s_api = {
    endpoint = "https://${local.remote_state.k8s_clusters[local.env.short_name].endpoint}"
    ca_cert = base64decode(
      local.remote_state.k8s_clusters[local.env.short_name].ca_certificate
    )
    token = module.cloud_config.this.token
  }

  remote_state_config = merge(
    {
      repo = {
        config = {
          bucket = local.env.tf_backend.configs.bucket
          prefix = "${local.env.name}/github"
        }
      }
    },
    {
      for env_name, env_obj in var.envs :
      "cloud-${env_name}" => {
        config = {
          for key, value in env_obj.tf_backend.configs :
          key => can(tostring(value)) ? replace(value, "/secrets", "/cloud") : value
        }
      }
    }
  )

  remote_state = {
    repos = data.terraform_remote_state.remote_state["repo"].outputs.repos
    k8s_clusters = {
      for env_name, env_obj in var.envs :
      env_obj.short_name => {
        for key, value in data.terraform_remote_state.remote_state["cloud-${env_name}"].outputs.this.k8s_clusters[env_obj.short_name] : key => value
        if contains(["ca_certificate", "endpoint"], key)
      }
      if env_obj.kubernetes.enabled
    }
  }
}
