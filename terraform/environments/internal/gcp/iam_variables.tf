locals {
  iam = {
    custom_roles = {
      k8sNodeServiceAccount = {
        title       = "k8s node service account"
        description = "Cusom role for k8s node service accounts without the bucket read permission"
        permissions = [
          "autoscaling.sites.writeMetrics",
          "logging.logEntries.create",
          "monitoring.metricDescriptors.create",
          "monitoring.metricDescriptors.list",
          "monitoring.timeSeries.create",
          "monitoring.timeSeries.list",
          "resourcemanager.projects.get",
          "serviceusage.services.use",
        ]
      }
    }

    service_accounts = {
      external-dns = {
        description = "k8s sigs external dns service account"
        roles = [
          "roles/dns.admin"
        ]
        custom_roles = []
        sa_iam_bindings = {
          "roles/iam.workloadIdentityUser" = [
            ##MASKED##  "serviceAccount:${local.env.cloud.id}.svc.id.goog[external-dns/external-dns]",
          ]
        }
        generate_key = false
      },
      argocd = {
        description = "argocd service account"
        roles = [
        ]
        custom_roles = []
        sa_iam_bindings = {
          "roles/iam.workloadIdentityUser" = [
            ##MASKED##  "serviceAccount:${local.env.cloud.id}.svc.id.goog[argocd/argocd]",
          ]
        }
        generate_key = false
      },
      k8s-nodes = {
        description = "default service account for k8s nodes"
        roles = [
          "projects/${local.env.cloud.id}/roles/k8sNodeServiceAccount"
        ]
        sa_iam_bindings = {
        }
        generate_key = false
      }
      thanos = {
        description  = "service account for thanos"
        roles        = []
        custom_roles = []
        sa_iam_bindings = {
          "roles/iam.workloadIdentityUser" = [
            ##MASKED##  "serviceAccount:${local.env.cloud.id}.svc.id.goog[prometheus/thanos]",
          ]
        }
        generate_key = false
      }
      runner = {
        description = "service account for ci runners"
        roles = [
          "roles/owner"
        ]
        custom_roles = []
        sa_iam_bindings = {
        }
        generate_key = true
      }
      grafana-loki = {
        description  = "service account for loki"
        roles        = []
        custom_roles = []
        sa_iam_bindings = {
          "roles/iam.workloadIdentityUser" = [
            ##MASKED##  "serviceAccount:${local.env.cloud.id}.svc.id.goog[loki/grafana-loki]",
          ]
        }
        generate_key = false
      }
    }

    roles = {
    }
  }
}
