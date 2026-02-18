locals {
  k8s_api = {
    endpoint = "https://${local.remote_state.k8s_clusters[local.env.short_name].endpoint}"
    ca_cert = base64decode(
      local.remote_state.k8s_clusters[local.env.short_name].ca_certificate
    )
    token = module.cloud_config.this.token
  }
  remote_state_config = {
    cloud = {
      config = {
        bucket = "${var.company.name}-tf-state"
        prefix = "${local.env.name}/gcp"
      }
    }
  }

  remote_state = {
    k8s_clusters = data.terraform_remote_state.remote_state["cloud"].outputs.this.k8s_clusters,
  }
}
