locals {
  gke_clusters = {
    this = {
      location = local.env.kubernetes.location
      project  = local.env.cloud.id
      name     = local.env.short_name
      enabled  = true
    }
  }
  remote_state_config = {
  }

  remote_state = {
  }
}
