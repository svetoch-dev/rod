locals {
  overrides = {
    env = provider::deepmerge::mergo(
      local.env,
      {
        cloud = {
          numeric_id = merge(
            local.env.cloud.name == "gcp" ? {"id": data.google_project.project.number } : {},
          )["id"]
          location = {
            available_zones = merge(
              local.env.cloud.name == "gcp" ? {"zones": data.google_compute_zones.available.names } : {},
            )["zones"]
          }
        }
      }
    )
    gcp_iam = {
      service_accounts = {
        posgres = null
      }
    }
    gcp_buckets = {
      format("%s-postgres-%s", var.company.name, local.env.short_name)        = null
      format("%s-postgres-backup-%s", var.company.name, local.env.short_name) = null
    }
  }
}
