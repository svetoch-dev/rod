locals {
  repos = {
    infrastructure = {
      name = "infrastructure"
      org  = var.ci.group
      deploy_keys = {
        argocd = {
          name      = "argocd"
          read_only = true
          create    = true
        }
      }
      secrets = {
      }
    }
  }
}
