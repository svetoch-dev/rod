locals {
  remote_state_config = {
    secrets = {
      config = {
        for key, value in local.env.tf_backend.configs :
        key => can(tostring(value)) ? replace(value, "/repo", "/secrets") : value
      }
    }
  }

  remote_state = {
    secrets = data.terraform_remote_state.remote_state["secrets"].outputs.secrets,
  }
}
