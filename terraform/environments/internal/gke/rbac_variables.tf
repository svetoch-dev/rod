locals {
  rbac = {
    service_accounts = {
      external-dns = {
        namespace = "external-dns"
        name      = "external-dns"
        annotations = {
          "iam.gke.io/gcp-service-account" = "external-dns@${local.gcp_project.name}.iam.gserviceaccount.com"
        }
      }
      thanos = {
        namespace = "prometheus"
        name      = "thanos"
        annotations = {
          "iam.gke.io/gcp-service-account" = "thanos@${local.gcp_project.name}.iam.gserviceaccount.com"
        }
      }
      argocd = {
        namespace = "argocd"
        name      = "argocd"
        annotations = {
          "iam.gke.io/gcp-service-account" = "argocd@${local.gcp_project.name}.iam.gserviceaccount.com"
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
