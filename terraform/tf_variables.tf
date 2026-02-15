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

variable "apps" {
  description = "Application related info"
  type = map(
    object(
      {
        name = string
      }
    )
  )
  default = {}
}

variable "ci" {
  description = "ci related info"
  type = object(
    {
      type  = string
      group = string
    }
  )
  default = null
}

variable "repo" {
  description = "git repository related info"
  type = object(
    {
      type  = string
      group = string
    }
  )
  default = null
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
              k8s_enabled       = optional(bool, true)
              namespace         = optional(string)
              base64_secrets    = optional(bool, false)
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
            network = object(
              {
                vm_cidr          = string
                k8s_pod_cidr     = string
                k8s_service_cidr = string
              }
            )
            registry     = string
            buckets = optional(
              object(
                {
                  deletion_protection = optional(bool, true)
                  multi_regional      = optional(bool, false)
                }
              ),
              {
                deletion_protection = true
                multi_regional      = false
              }
            )
          }
        )
        kubernetes = optional(
          object(
            {
              enabled             = bool
              regional            = bool
              deletion_protection = bool
              node_locations      = list(string)
              auth_group          = string
            }
          ),
          {
            enabled             = false
            regional            = false
            node_locations      = []
            auth_group          = ""
            deletion_protection = false
          }
        )
      }
    )
  )
}
