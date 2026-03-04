output "secrets" {
  value     = module.secrets.rod_secrets
  sensitive = true
}
