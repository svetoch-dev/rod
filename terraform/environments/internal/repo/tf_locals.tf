locals {
  remote_state_config = {
    secrets = {
      config = {
        bucket = "${var.company.name}-tf-state"
        prefix = "${local.env.name}/secrets"
      }
    }
  }

  remote_state = {
    secrets = data.terraform_remote_state.remote_state["secrets"].outputs.secrets,
  }
}
