locals {
  overrides = {
    yc_k8s_clusters = {
      tostring(local.env.short_name) = {
        node_groups = {
          main-ru-central1-d = {
            instance_template = {
              resources = {
                core_fraction = 100
                cores         = 2
                memory        = 4
              }
              boot_disk = {
                size = 30
                type = "network-ssd"
              }
            }
          }
        }
      }
    }
    #gcp|yc|aws_buckets = {
    #  format("%s-postgres-%s", var.company.name, local.env.short_name)        = null
    #  format("%s-postgres-backup-%s", var.company.name, local.env.short_name) = null
    #}
  }
}
