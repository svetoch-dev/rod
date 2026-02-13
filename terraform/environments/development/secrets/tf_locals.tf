locals {
  secrets = merge(
    local.prometheus,
    local.import_secrets
  )

  remote_state_config = {
    cloud = {
      config = {
        bucket = "${var.company.name}-tf-state"
        prefix = "${local.env.name}/cloud"
      }
    }
  }

  remote_state = {
    k8s_clusters = data.terraform_remote_state.remote_state["cloud"].outputs.this.k8s_clusters,
  }
}
