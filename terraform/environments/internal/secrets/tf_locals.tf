locals {
  secrets = merge(
    local.prometheus,
    local.argocd-clusters,
    local.argocd-repos,
    local.import_secrets,
  )

  remote_state_config = merge(
    {
      github = {
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
          bucket = env_obj.tf_backend.configs.bucket
          prefix = "${env_name}/gcp"
        }
      }
    }
  )

  remote_state = {
    github = {
      repos = data.terraform_remote_state.remote_state["github"].outputs.repos
    }
    k8s_clusters = {
      for env_name, env_obj in var.envs :
      env_obj.short_name => data.terraform_remote_state.remote_state["cloud-${env_name}"].outputs.this.k8s_clusters[env_obj.short_name]
      if env_obj.kubernetes.enabled
    }
  }
}
