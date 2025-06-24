locals {
  import_secrets = {
    ##MASKED##for secret_name, secret_obj in local.env.import_secrets :
    ##MASKED##"${secret_name}" => {
    ##MASKED##  name              = secret_obj.name
    ##MASKED##  base64_secrets    = secret_obj.base64_secrets
    ##MASKED##  secrets_to_import = secret_obj.secrets_to_import
    ##MASKED##  k8s = {
    ##MASKED##    enabled   = secret_obj.k8s_enabled
    ##MASKED##    namespace = secret_obj.namespace
    ##MASKED##  }
    ##MASKED##  annotations = {
    ##MASKED##  }
    ##MASKED##  labels = {
    ##MASKED##  }
    ##MASKED##}
  }
}
