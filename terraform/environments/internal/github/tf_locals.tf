locals {
  remote_state_config = merge(
    {
      secrets = {
        config = {
          bucket = "${var.company.name}-tf-state"
          prefix = "${local.env.name}/secrets"
        }
      }
    },
  )

  remote_state = merge(
    {
      secrets = data.terraform_remote_state.remote_state["secrets"].outputs.secrets,
    },
  )
}
