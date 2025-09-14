locals {
  gcs = {
    format("%s-thanos-%s", var.company.name, local.env.short_name) = {
      #force_destroy should be oposite to deletion_protection
      force_destroy      = local.env.cloud.buckets.deletion_protection ? false : true
      storage_class      = "MULTI_REGIONAL"
      bucket_policy_only = true
      location           = local.env.cloud.multi_region
      admins = [
        "serviceAccount:thanos@${local.env.cloud.id}.iam.gserviceaccount.com"
      ]
      lifecycle_rules = []
    }
    format("%s-loki-%s", var.company.name, local.env.short_name) = {
      #force_destroy should be oposite to deletion_protection
      force_destroy      = local.env.cloud.buckets.deletion_protection ? false : true
      storage_class      = "MULTI_REGIONAL"
      bucket_policy_only = true
      location           = local.env.cloud.multi_region
      admins = [
        "serviceAccount:grafana-loki@${local.env.cloud.id}.iam.gserviceaccount.com"
      ]
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
