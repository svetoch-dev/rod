locals {
  import_secrets = {
    for secret_name, secret_obj in local.env.import_secrets :
    "${secret_name}" => {
      name              = secret_obj.name
      secrets_to_import = secret_obj.secrets_to_import
      k8s = {
        enabled   = true
        namespace = secret_obj.namespace
      }
      annotations = {
      }
      labels = {
      }
    }
  }
}
