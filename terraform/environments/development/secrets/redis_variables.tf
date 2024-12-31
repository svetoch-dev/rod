locals {
  redis = {
    redis-main = {
      name = "redis-main"
      secrets_to_import = [
        "password"
      ]
      k8s = {
        enabled   = true
        namespace = "redis"
      }
      annotations = {
      }
      labels = {
      }
    }
  }
}
