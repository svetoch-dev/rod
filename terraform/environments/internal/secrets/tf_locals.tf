locals {
  gke_clusters = {
    for name, obj in var.gcp_projects :
    "${name == "internal" ? "this" : var.envs[name].short_name}" => {
      location = obj.kubernetes.location
      project  = obj.name
      enabled  = true
      name     = var.envs[name].short_name
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
