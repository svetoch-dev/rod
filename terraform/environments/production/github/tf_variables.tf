locals {
  remote_state_config = merge(
    {
      secrets = {
        config = {
          bucket = "${var.company.name}-tf-state"
          prefix = "${local.env.name}/secrets"
        }
      }
    },
    {
      for name, obj in var.gcp_projects :
      "gcp-${var.envs[name].short_name}" => {
        config = {
          bucket = "${var.company.name}-tf-state"
          prefix = "${var.envs[name].name}/gcp"
        }
      }
    }
  )

  remote_state = merge(
    {
      secrets = data.terraform_remote_state.remote_state["secrets"].outputs.secrets,
    },
    {
      for name, obj in var.gcp_projects :
      "gcp-${var.envs[name].short_name}" => {
        service_accounts = data.terraform_remote_state.remote_state["gcp-${var.envs[name].short_name}"].outputs.service_accounts
      }
    }
  )

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

variable "github" {
  description = "github related info"
  type = object(
    {
      org = string
    }
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
