locals {
  overrides = {
    gcp_iam = {
      service_accounts = {
        grafana    = null
        argocd     = null
        runner     = null
        runner-app = null
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
    gcp_k8s_cluster_nodes = {
      tostring(local.env.short_name) = {
        runner = null
      }
    }
  }
}
