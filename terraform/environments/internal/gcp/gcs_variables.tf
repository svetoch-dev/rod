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
      creators        = []
      lifecycle_rules = []
    }
  }
}
