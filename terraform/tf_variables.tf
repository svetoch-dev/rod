locals {
  # Be carefull when changing this
  # This is rendered using bazel and
  # expand_template rule probably
  # everything will brake badly if
  # something goes wrong
  env = var.envs.{env.name}
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

variable "ci" {
  description = "ci related info"
  type = object(
    {
      type  = string
      group = string
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
        import_secrets = map(
          object(
            {
              name              = string
              namespace         = string
              secrets_to_import = list(string)
            }
          )
        )
        tf_backend = object(
          {
            type    = string
            configs = map(string)
          }
        )
        cloud = object(
          {
            name         = string
            id           = string
            region       = string
            default_zone = string
            multi_region = string
            registry     = string
            buckets = object(
              {
                deletion_protection = bool
              }
            )
          }
        )
        kubernetes = optional(
          object(
            {
              regional            = bool
              deletion_protection = bool
              location            = string
              auth_group          = string
            }
          )
        )
      }
    )
  )
}
