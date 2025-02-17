locals {
  gcs = {
    format("%s-thanos-%s", var.company.name, local.env.short_name) = {
      storage_class = "MULTI_REGIONAL"
      location      = local.env.cloud.multi_region
      admins = [
        "serviceAccount:thanos@${local.env.cloud.id}.iam.gserviceaccount.com"
      ]
      viewers = [
      ]
      creators = []
    }
    format("%s-postgres-%s", var.company.name, local.env.short_name) = {
      storage_class = "MULTI_REGIONAL"
      location      = local.env.cloud.multi_region
      admins = [
        "serviceAccount:postgres@${local.env.cloud.id}.iam.gserviceaccount.com"
      ]
      viewers              = []
      creators             = []
      soft_delete_duration = 0
    }
    format("%s-postgres-backup-%s", var.company.name, local.env.short_name) = {
      storage_class = "MULTI_REGIONAL"
      location      = local.env.cloud.multi_region
      admins = [
        "serviceAccount:postgres@${local.env.cloud.id}.iam.gserviceaccount.com"
      ]
      viewers  = []
      creators = []
      lifecycle_rules = [{
        action = {
          type = "Delete"
        },
        condition = {
          age = "60"
        }
      }]
    }
  }
}
