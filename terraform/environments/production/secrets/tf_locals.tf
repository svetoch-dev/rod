locals {
  secrets = local.import_secrets

  remote_state_config = {
    cloud = {
      config = {
        for key, value in local.env.tf_backend.configs :
        key => can(tostring(value)) ? replace(value, "/secrets", "/cloud") : value
      }
    }
  }

  remote_state = {
    k8s_clusters = data.terraform_remote_state.remote_state["cloud"].outputs.this.k8s_clusters,
  }
}
