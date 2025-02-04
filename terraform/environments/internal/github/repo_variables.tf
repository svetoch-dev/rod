locals {
  repos = {
    infrastructure = {
      name = "infrastructure"
      org  = var.github.org
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
