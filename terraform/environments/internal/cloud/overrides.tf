locals {
  overrides = {
    gcp_iam = {
      service_accounts = {
        postgres = null
      }
      roles = {
        owners = {
          role = "roles/owner"
          members = [
            "serviceAccount:runner@${local.env.cloud.id}.iam.gserviceaccount.com"
          ]
        }
      }
    }
    gcp_buckets = {
      format("%s-postgres-%s", var.company.name, local.env.short_name)        = null
      format("%s-postgres-backup-%s", var.company.name, local.env.short_name) = null
    }
  }
}
