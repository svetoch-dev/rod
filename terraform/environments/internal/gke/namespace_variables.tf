locals {
  namespaces = {
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
    konghq = {
      name = "konghq"
    }
    external-dns = {
      name = "external-dns"
    }
    redis = {
      name = "redis"
    }
  }
}
