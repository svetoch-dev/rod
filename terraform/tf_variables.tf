locals {
  # Be carefull when changing this
  # This is rendered using bazel and
  # expand_template rule probably
  # everything will brake badly if
  # something goes wrong
  env         = var.envs.{env.name}
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

variable "envs" {
  description = "Environments description"
  type = map(
    object(
      {
        name       = string
        short_name = string
        tf_backend =  object(
          {
            type    = string
            configs = map(string)
          }
        )
        cloud      = object(
          {
            name   = string
            id     = string
            region = string
            default_zone = string
            multi_region = string
            registry     = string
          }
        )
        kubernetes = optional(
          object(
            {
              regional   = bool
              location   = string
              auth_group = string
            }
          )
        )
      }
    )
  )
}
