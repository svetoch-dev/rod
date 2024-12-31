locals {
  gcs = {
    format("%s-thanos-%s", var.company.name, local.env.short_name) = {
      storage_class = "MULTI_REGIONAL"
      location      = local.gcp_project.multi_region
      admins = [
        "serviceAccount:thanos@${local.gcp_project.name}.iam.gserviceaccount.com"
      ]
      viewers = [
      ]
      creators = []
    }
    format("%s-postgres-%s", var.company.name, local.env.short_name) = {
      storage_class = "MULTI_REGIONAL"
      location      = local.gcp_project.multi_region
      admins = [
        "serviceAccount:postgres@${local.gcp_project.name}.iam.gserviceaccount.com"
      ]
      viewers  = []
      creators = []
    }
    format("%s-postgres-backup-%s", var.company.name, local.env.short_name) = {
      storage_class = "MULTI_REGIONAL"
      location      = local.gcp_project.multi_region
      admins = [
        "serviceAccount:postgres@${local.gcp_project.name}.iam.gserviceaccount.com"
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
