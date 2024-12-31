locals {
  dns_zones = {
    "${local.gcp_project.name}" = {
      zone = {
        name     = "${local.gcp_project.name}"
        dns_name = format("%s.%s.", local.env.short_name, var.company.domain)
      }
      #Records are created using external-dns
      #controller in k8s
      records = [
      ]
    }
  }
}
