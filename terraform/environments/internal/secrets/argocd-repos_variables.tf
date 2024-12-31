locals {
  argocd-repos = merge(
    {
      for repo_name, repo_obj in local.remote_state.github.repos :
      repo_name => {
        name = "argocd-${repo_obj.org}-${repo_name}"
        secrets_data = {
          type          = "git"
          url           = repo_obj.ssh_url
          sshPrivateKey = repo_obj.deploy_keys["argocd"].private_key_openssh
        }
        k8s = {
          enabled   = true
          namespace = "argocd"
        }
        annotations = {
        }
        labels = {
          "argocd.argoproj.io/secret-type" = "repository"
        }
      }
    }
  )
}
