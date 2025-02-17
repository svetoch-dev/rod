locals {
  dns_zones = {
    "${local.env.cloud.id}" = {
      zone = {
        name     = "${local.env.cloud.id}"
        dns_name = format("%s.%s.", local.env.short_name, var.company.domain)
      }
      #Records are created using external-dns
      #controller in k8s
      records = [
      ]
    }
  }
}
