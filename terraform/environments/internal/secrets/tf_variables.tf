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
        prefix = "${var.envs["production"].name}/github"
      }
    }
  }

  remote_state = {
    github = {
      repos = data.terraform_remote_state.remote_state["github"].outputs.repos
    }
  }

  # Be carefull when changing this
  # This is rendered using bazel and
  # expand_template rule probably
  # everything will brake badly if
  # something goes wrong
  gcp_project = var.gcp_projects.ENV_NAME
  env         = var.envs.ENV_NAME
}

variable "company" {
  description = "Company related info"
  type = object(
    {
      name   = string
      domain = string
    }
  )
}

variable "envs" {
  description = "Environments description"
  type = map(
    object(
      {
        name       = string
        short_name = string
      }
    )
  )
}

variable "gcp_projects" {
  description = "Definitions of gcp projects"
  type = map(
    object(
      {
        name   = string
        region = string
        kubernetes = optional(
          object(
            {
              regional   = bool
              location   = string
              auth_group = string
            }
          )
        )
        default_zone = string
        multi_region = string
      }
    )
  )
}
