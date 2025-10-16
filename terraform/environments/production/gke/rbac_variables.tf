locals {
  rbac = {
    service_accounts = {
      external-dns = {
        name      = "external-dns"
        namespace = "external-dns"
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
      grafana-loki = {
        namespace = "loki"
        name      = "grafana-loki"
        annotations = {
          "iam.gke.io/gcp-service-account" = "grafana-loki@${local.env.cloud.id}.iam.gserviceaccount.com"
        }
      }
      "postgres.postgres" = {
        name      = "postgres"
        namespace = "postgres"
        annotations = {
          "iam.gke.io/gcp-service-account" = "postgres@${local.env.cloud.id}.iam.gserviceaccount.com"
        }
      }
      fluent = {
        namespace = "fluent"
        name      = "fluent"
        annotations = {
          "iam.gke.io/gcp-service-account" = "fluent@${local.env.cloud.id}.iam.gserviceaccount.com"
        }
      }
      "example.postgres" = {
        name      = "postgres"
        namespace = "example"
        annotations = {
          "iam.gke.io/gcp-service-account" = "postgres@${local.env.cloud.id}.iam.gserviceaccount.com"
        }
      }
    }
    cluster_roles = {
    }
    cluster_role_binding = {
      argocd = {
        labels      = {},
        annotations = {},
        role_ref = {
          kind = "ClusterRole"
          name = "cluster-admin"
        }
        subject = {
          argocd = {
            api_group = "rbac.authorization.k8s.io"
            kind      = "User"
            name      = "argocd@${var.envs.internal.cloud.id}.iam.gserviceaccount.com"
            namespace = ""
          }
        }
      }
    }
    roles        = {}
    role_binding = {}
  }
}
