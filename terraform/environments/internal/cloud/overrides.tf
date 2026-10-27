locals {
  overrides = {
    yc_k8s_clusters = {
    }
    #gcp|yc|aws_buckets = {
    #  format("%s-postgres-%s", var.company.name, local.env.short_name)        = null
    #  format("%s-postgres-backup-%s", var.company.name, local.env.short_name) = null
    #}
  }
}
