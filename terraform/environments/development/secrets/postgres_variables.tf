locals {
  postgres = {
    pg-postgres = {
      name = "tf-gcp-postgres-service-account"
      secrets_data = {
        key = base64decode(local.remote_state.gcp.service_accounts["postgres"].key)
      }
      k8s = {
        enabled   = true
        namespace = "postgres"
      }
      annotations = {
      }
      labels = {
      }
    }
  }
}
