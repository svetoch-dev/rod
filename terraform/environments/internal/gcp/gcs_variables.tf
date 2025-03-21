locals {
  gcs = {
    format("%s-thanos-%s", var.company.name, local.env.short_name) = {
      #force_delete should be oposite to deletion_protection 
      force_delete  = local.env.cloud.buckets.deletion_protection ? false : true
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
