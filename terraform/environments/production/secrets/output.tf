output "rod_secrets" {
  value     = module.rod_secrets.secrets
  sensitive = true
}
