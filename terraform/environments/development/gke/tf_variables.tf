locals {
  gke_clusters = {
    this = {
      location = "${local.gcp_project.region}-a"
      project  = local.gcp_project.name
      name     = local.env.short_name
      enabled  = true
    }
  }
  remote_state_config = {
  }

  remote_state = {
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
