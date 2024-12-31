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
      creators        = []
      lifecycle_rules = []
    }
  }
}
