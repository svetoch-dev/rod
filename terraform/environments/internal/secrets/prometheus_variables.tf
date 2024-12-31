locals {
  prometheus = {
    alertmanager = {
      name = "alertmanager"
      secrets_to_import = [
        "SLACK_WEBHOOK"
      ]
      k8s = {
        enabled   = true
        namespace = "prometheus"
      }
      annotations = {
      }
      labels = {
      }
    }
    thanos = {
      name = "thanos"
      secrets_data = {
        #used in prometheus thanos
        #sidecar
        #used for thanos components
        "objstore.yml" = <<EOF
type: GCS
config:
  bucket: "${format("%s-thanos-%s", var.company.name, local.env.short_name)}"
prefix: ""
EOF
      }
      k8s = {
        enabled   = true
        namespace = "prometheus"
      }
      annotations = {
      }
      labels = {
      }
    }
  }
}
