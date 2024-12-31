output "cloudsql_postgres" {
  value     = module.gcp.cloudsql_postgres
  sensitive = true
}

output "service_accounts" {
  value     = module.gcp.iam.service_accounts
  sensitive = true
}

output "nat_gws" {
  value = module.gcp.nats
}

#output "mv" {
#  value = <<EOF
#%{ for bucket_name, bucket_obj in local.gcs}
#terraform state mv 'module.gcp.module.gcs["${bucket_name}"].google_storage_bucket.buckets["${bucket_name}"]' 'module.gcp.module.gcs["${bucket_name}"].google_storage_bucket.bucket'
#terraform state mv 'module.gcp.module.gcs["${bucket_name}"].google_storage_bucket_iam_binding.admins["${bucket_name}"]' 'module.gcp.module.gcs["${bucket_name}"].google_storage_bucket_iam_binding.bindings["roles/storage.objectAdmin"]'
#terraform state mv 'module.gcp.module.gcs["${bucket_name}"].google_storage_bucket_iam_binding.creators["${bucket_name}"]' 'module.gcp.module.gcs["${bucket_name}"].google_storage_bucket_iam_binding.bindings["roles/storage.objectCreator"]'
#terraform state mv 'module.gcp.module.gcs["${bucket_name}"].google_storage_bucket_iam_binding.viewers["${bucket_name}"]' 'module.gcp.module.gcs["${bucket_name}"].google_storage_bucket_iam_binding.bindings["roles/storage.objectViewer"]'
#
#%{~ endfor}
#EOF
#}
