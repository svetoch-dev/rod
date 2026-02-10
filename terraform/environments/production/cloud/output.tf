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
