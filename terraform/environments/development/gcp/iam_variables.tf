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
      bucketList = {
        title       = "List/get buckets for services"
        description = "Custom role for listing buckets and there metadata"
        permissions = [
          "resourcemanager.projects.get",
          "storage.buckets.list",
          "storage.buckets.get",
        ]
      }
    }
    service_accounts = {
      k8s-nodes = {
        description = "default service account for k8s nodes"
        roles = [
          "projects/${local.env.cloud.id}/roles/k8sNodeServiceAccount"
        ]
        sa_iam_bindings = {
        }
        generate_key = false
      }
      external-dns = {
        description = "k8s sigs external dns service account"
        roles = [
          "roles/dns.admin"
        ]
        sa_iam_bindings = {
          "roles/iam.workloadIdentityUser" = [
            ##MASKED##  "serviceAccount:${local.env.cloud.id}.svc.id.goog[external-dns/external-dns]",
          ]
        }
        generate_key = false
      },
      container-images = {
        description = "Account for pulling/pushing images from/to gar"
        roles = [
        ]
        sa_iam_bindings = {
        }
        generate_key = true
      }
      thanos = {
        description = "service account for thanos"
        roles       = []
        sa_iam_bindings = {
          "roles/iam.workloadIdentityUser" = [
            ##MASKED##  "serviceAccount:${local.env.cloud.id}.svc.id.goog[prometheus/thanos]",
          ]
        }
        generate_key = false
      }
      grafana-loki = {
        description  = "service account for loki"
        roles        = []
        custom_roles = []
        sa_iam_bindings = {
          "roles/iam.workloadIdentityUser" = [
            "serviceAccount:${local.env.cloud.id}.svc.id.goog[loki/grafana-loki]",
          ]
        }
        generate_key = false
      }
      postgres = {
        description = "service account for postgres-operator to store wal-e archiving"
        roles = [
          "projects/${local.env.cloud.id}/roles/bucketList"
        ]
        sa_iam_bindings = {
          "roles/iam.workloadIdentityUser" = [
            ##MASKED##  "serviceAccount:${local.env.cloud.id}.svc.id.goog[postgres/postgres]",
          ]
        }
        generate_key = false
      }
    }

    roles = {
      owners = {
        role = "roles/owner"
        members = [
          "serviceAccount:runner@${var.envs.internal.cloud.id}.iam.gserviceaccount.com"
        ]
      }
    }
  }
}
