locals {
  namespaces = {
    pomerium = {
      name = "pomerium"
    }
    argocd = {
      name = "argocd"
    }
    grafana = {
      name = "grafana"
    }
    prometheus = {
      name = "prometheus"
    }
    cert-manager = {
      name = "cert-manager"
    }
    external-dns = {
      name = "external-dns"
    }
    redis = {
      name = "redis"
    }
    gha-runner = {
      name = "gha-runner"
    }
    gha-runner-app = {
      name = "gha-runner-app"
    }
    gha-operator = {
      name = "gha-operator"
    }
  }
}
