locals {
  argocd-redis = {
    redis = {
      name = "argocd-redis"
      secrets_to_import = [
        "redis-password", "password"
      ]
      k8s = {
        enabled   = true
        namespace = "argocd"
      }
      annotations = {
      }
      labels = {
      }
    }
  }
}
