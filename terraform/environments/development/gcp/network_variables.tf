locals {
  networks = {
    main = {
      authorized_networks = {
        allow-all = {
          cidr_block   = "0.0.0.0/0"
          display_name = "Allow all"
        }
      }
      db_authorized_networks = {
      }
      vpc = {
        name = "main"
      }
      subnets = {
        "vms" = {
          ip_cidr_range = "10.0.0.0/20"
          region        = local.gcp_project.region
          description   = "VM subnet"
          secondary_ip_range = [
            {
              range_name    = format("%s-pods", local.env.short_name)
              ip_cidr_range = "10.4.0.0/14"
            },
            {
              range_name    = format("%s-services", local.env.short_name)
              ip_cidr_range = "10.1.0.0/20"
            }
          ]
        }
      }
      nat_gws = {
        "nat-gw" = {
          region      = local.gcp_project.region
          router_name = "router"
          ip_address_names = [
            "nat-gw-ip-1"
          ]
        }
      }
      routers = {
        "router" = {
          region = local.gcp_project.region
        }
      }
      ip_addresses = [
        {
          name        = "nat-gw-ip-1"
          description = "ip address for nat gw ${local.gcp_project.region}"
        }
      ]
      firewall_rules = {
        admission-webhooks = {
          direction = "INGRESS"
          source_ranges = [
            "172.16.0.0/28"
          ]
          target_tags = []
          description = null
          allow = {
            "tcp" = {
              ports = [
                "8080", #konghq
                "9443", #rabbitmq operator
              ]
            }
          }
          deny = {}
        }
      }
    }
  }
}
