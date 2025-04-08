locals {
  gke_clusters = {
    this = {
      location = local.env.kubernetes.location
      project  = local.env.cloud.id
      name     = local.env.short_name
      enabled  = local.env.kubernetes.enabled
    }
  }
  remote_state_config = {
  }

  remote_state = {
  }
}
