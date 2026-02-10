locals {
  overrides = {
    env = provider::deepmerge::mergo(
      local.env,
      {
        cloud = {
          numeric_id = merge(
            local.env.cloud.name == "gcp" ? {"id": data.google_project.project.number } : {},
          )["id"]
          location = {
            available_zones = merge(
              local.env.cloud.name == "gcp" ? {"zones": data.google_compute_zones.available.names } : {},
            )["zones"]
          }
        }
      }
    )
    gcp_iam = {
      service_accounts = {
        grafana = null
        argocd  = null
        runner  = null
        runner-app  = null
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
    gcp_networks = {
      main = {
        firewall_rules = {
          admission-webhooks = {
            allow = {
              tcp = {
                ports = [
                  "8080", #konghq
                  "9443", #rabbitmq operator
                ]
              }
            }
          }
        }
      }
    }
  }
}
