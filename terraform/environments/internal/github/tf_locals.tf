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
      for name, obj in var.gcp_projects :
      "gcp-${var.envs[name].short_name}" => {
        config = {
          bucket = "${var.company.name}-tf-state"
          prefix = "${var.envs[name].name}/gcp"
        }
      }
    }
  )

  remote_state = merge(
    {
      secrets = data.terraform_remote_state.remote_state["secrets"].outputs.secrets,
    },
    {
      for name, obj in var.gcp_projects :
      "gcp-${var.envs[name].short_name}" => {
        service_accounts = data.terraform_remote_state.remote_state["gcp-${var.envs[name].short_name}"].outputs.service_accounts
      }
    }
  )
}
