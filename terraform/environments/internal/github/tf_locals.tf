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
    {
      for name, obj in var.envs :
      "gcp-${obj.short_name}" => {
        config = {
          bucket = "${var.company.name}-tf-state"
          prefix = "${obj.name}/gcp"
        }
      }
    }
  )

  remote_state = merge(
    {
      secrets = data.terraform_remote_state.remote_state["secrets"].outputs.secrets,
    },
    {
      for name, obj in var.envs :
      "gcp-${obj.short_name}" => {
        service_accounts = data.terraform_remote_state.remote_state["gcp-${obj.short_name}"].outputs.service_accounts
      }
    }
  )
}
