locals {
  gars = {
    containers = {
      location = local.gcp_project.region
      readers = [
        "serviceAccount:k8s-nodes@${local.gcp_project.name}.iam.gserviceaccount.com"
      ]
      writers = [
        "serviceAccount:container-images@${local.gcp_project.name}.iam.gserviceaccount.com"
      ]
      description = "images for all microservices"
    }
  }
}
