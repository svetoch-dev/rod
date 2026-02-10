locals {
  overrides = {
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
