locals {
  rbac = {
    service_accounts = {
      external-dns = {
        namespace = "external-dns"
        name      = "external-dns"
        annotations = {
          "iam.gke.io/gcp-service-account" = "external-dns@${local.env.cloud.id}.iam.gserviceaccount.com"
        }
      }
      thanos = {
        namespace = "prometheus"
        name      = "thanos"
        annotations = {
          "iam.gke.io/gcp-service-account" = "thanos@${local.env.cloud.id}.iam.gserviceaccount.com"
        }
      }
      argocd = {
        namespace = "argocd"
        name      = "argocd"
        annotations = {
          "iam.gke.io/gcp-service-account" = "argocd@${local.env.cloud.id}.iam.gserviceaccount.com"
        }
      }
      grafana-loki = {
        namespace = "loki"
        name      = "grafana-loki"
        annotations = {
          "iam.gke.io/gcp-service-account" = "grafana-loki@${local.env.cloud.id}.iam.gserviceaccount.com"
        }
      }
      fluent = {
        namespace = "fluent"
        name      = "fluent"
        annotations = {
          "iam.gke.io/gcp-service-account" = "fluent@${local.env.cloud.id}.iam.gserviceaccount.com"
        }
      }
    }
    cluster_roles = {
    }
    cluster_role_binding = {
    }
    roles        = {}
    role_binding = {}
  }
}
