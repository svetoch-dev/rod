locals {
  sso = {
    grafana = {
      name = "grafana"
      secrets_to_import = [
        "client-id",
        "client-secret"
      ]
      secrets_data = {
      }
      k8s = {
        enabled   = true
        namespace = "prometheus"
      }
      annotations = {
      }
      labels = {
      }
    }
  }
}
