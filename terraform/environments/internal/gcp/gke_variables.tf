locals {
  gke_clusters = {
    "${local.env.short_name}" = {
      name                    = local.env.short_name
      enabled                 = local.env.kubernetes.enabled
      regional                = local.env.kubernetes.regional
      region                  = local.env.cloud.region
      zones                   = data.google_compute_zones.available.names
      deletion_protection     = local.env.kubernetes.deletion_protection
      kubernetes_version      = "latest"
      subnetwork              = module.gcp.subnets["main"]["vms"].name
      network                 = module.gcp.vpcs["main"].network_name
      network_policy          = true
      network_policy_provider = "CALICO"
      ip_range_pods           = module.gcp.subnets["main"]["vms"].secondary_ip_range[0].range_name
      ip_range_services       = module.gcp.subnets["main"]["vms"].secondary_ip_range[1].range_name

      http_load_balancing             = true
      horizontal_pod_autoscaling      = true
      create_service_account          = false
      enable_vertical_pod_autoscaling = true
      enable_shielded_nodes           = false
      remove_default_node_pool        = true
      authenticator_security_group    = local.env.kubernetes.auth_group != "" ? local.env.kubernetes.auth_group : null
      identity_namespace              = "enabled"
      node_metadata                   = "GKE_METADATA"

      enable_private_nodes    = true
      enable_private_endpoint = false
      master_ipv4_cidr_block  = "172.16.0.0/28"

      resource_usage_export_dataset_id   = ""
      enable_network_egress_export       = false
      enable_resource_consumption_export = false

      maintenance_start_time = "2020-02-07T06:00:00Z"
      maintenance_recurrence = "FREQ=WEEKLY;BYDAY=SA"
      maintenance_end_time   = "2020-02-07T18:00:00Z"

      cluster_resource_labels = {
        "env" = local.env.short_name
      }
      master_authorized_networks = [
        for authNetKey, authNetObj in local.networks["main"].authorized_networks :
        {
          cidr_block   = authNetObj.cidr_block
          display_name = authNetObj.display_name
        }
      ]

      master_global_access_enabled = false # We use public endpoint for master access so setting false to ignore
      node_pools = [
        {
          name         = "main"
          machine_type = "t2d-standard-4"
          node_locations = join(
            ",",
            data.google_compute_zones.available.names,
          )
          min_count          = 0
          max_count          = 10
          local_ssd_count    = 0
          disk_size_gb       = 30
          disk_type          = "pd-balanced"
          image_type         = "COS_CONTAINERD"
          auto_repair        = true
          auto_upgrade       = true
          service_account    = "k8s-nodes@${local.env.cloud.id}.iam.gserviceaccount.com"
          preemptible        = false
          spot               = true
          initial_node_count = 0
        },
        {
          name         = "runner"
          machine_type = "t2d-standard-4"
          node_locations = join(
            ",",
            data.google_compute_zones.available.names,
          )
          min_count          = 0
          max_count          = 20
          local_ssd_count    = 0
          disk_size_gb       = 120
          disk_type          = "pd-ssd"
          image_type         = "COS_CONTAINERD"
          auto_repair        = true
          auto_upgrade       = true
          service_account    = "k8s-nodes@${local.env.cloud.id}.iam.gserviceaccount.com"
          preemptible        = false
          spot               = true
          initial_node_count = 0
        },
      ]

      node_pools_oauth_scopes = {
        all = []
        #All k8s permissions for nodes
        #are set on serviceaccount level
        #not by using oauth scopes. This
        #scopes are default ones
        main = [
          "https://www.googleapis.com/auth/userinfo.email",
          "https://www.googleapis.com/auth/cloud-platform"
        ]
        runner = [
          "https://www.googleapis.com/auth/userinfo.email",
          "https://www.googleapis.com/auth/cloud-platform"
        ]
      }

      node_pools_labels = {
        all = {}

        #Ugly hack in order to remove the default values
        default_values = {
          cluster_name = false
          node_pool    = false
        }
        main = {
          main = "true"
        }
        runner = {
          runner = "true"
        }
      }

      node_pools_metadata = {
        all = {}

        #Ugly hack in order to remove the default values
        default_values = {
          cluster_name = false
          node_pool    = false
        }
      }

      node_pools_taints = {
        all = []
        runner = [
          {
            key    = "runner"
            value  = true
            effect = "NO_SCHEDULE"
          },
        ]
      }

      node_pools_tags = {
        all = []
        #Ugly hack in order to remove the default values
        default_values = [
          false,
          false,
          false
        ]
      }
    }
  }
}
