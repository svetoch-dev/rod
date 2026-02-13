locals {
  argocd-clusters = {
    for cluster_name, cluster_obj in local.remote_state.k8s_clusters :
    "${cluster_name}-cluster" => {
      name = "${cluster_name}-cluster"
      secrets_data = {
        name   = cluster_name
        server = "https://${local.remote_state.k8s_clusters[cluster_name].endpoint}"
        config = <<EOF
{
  "execProviderConfig": {
    "command": "argocd-k8s-auth",
    "args": ["gcp"],
    "apiVersion": "client.authentication.k8s.io/v1beta1"
  },
  "tlsClientConfig": {
    "insecure": false,
    "caData": "${local.remote_state.k8s_clusters[cluster_name].ca_certificate}"
  }
}
EOF
      }
      k8s = {
        enabled   = true
        namespace = "argocd"
      }
      annotations = {
      }
      labels = {
        "argocd.argoproj.io/secret-type" = "cluster"
      }
    }
    if cluster_name != local.env.short_name
  }
}
