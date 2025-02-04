locals {
  gke_clusters = {
    this = {
      location = local.gcp_project.region
      project  = local.gcp_project.name
      name     = local.env.short_name
      enabled  = true
    }
  }
  remote_state_config = {
  }

  remote_state = {
  }
}
