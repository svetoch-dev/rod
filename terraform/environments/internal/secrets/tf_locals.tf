locals {
  secrets = merge(
    local.prometheus,
    local.argocd-clusters,
    local.argocd-repos,
    local.import_secrets,
  )

  gke_clusters = {
    for name, obj in var.envs :
    "${name == "internal" ? "this" : obj.short_name}" => {
      location = obj.kubernetes.location
      project  = obj.cloud.id
      enabled  = true
      name     = obj.short_name
    }
    if obj.kubernetes != null
  }

  remote_state_config = {
    github = {
      config = {
        bucket = "${var.company.name}-tf-state"
        prefix = "${local.env.name}/github"
      }
    }
  }

  remote_state = {
    github = {
      repos = data.terraform_remote_state.remote_state["github"].outputs.repos
    }
  }
}
