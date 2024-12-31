output "secrets" {
  value = {
    for secret_name, secret_obj in module.secrets :
    secret_name => secret_obj.k8s_secrets
  }
  sensitive = true
}
