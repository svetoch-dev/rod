locals {
  grafana = {
    gf-google = {
      name = "grafana"
      secrets_to_import = [
        "google-client-id",
        "google-client-secret"
      ]
      k8s = {
        enabled   = true
        namespace = "grafana"
      }
      annotations = {
      }
      labels = {
      }
    }
  }
}
