locals {
  # Be carefull when changing this
  # This is rendered using bazel and
  # expand_template rule probably
  # everything will brake badly if
  # something goes wrong
  gcp_project = var.gcp_projects.{env_name}
  env         = var.envs.{env_name}
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

variable "github" {
  description = "github related info"
  type = object(
    {
      org = string
    }
  )
}

variable "tf_backend" {
  description = "tf backend description"
  type = object(
    {
      type    = string
      configs = map(string)
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
