locals {
  gars = {
    containers = {
      location = local.gcp_project.region
      readers = [
        "serviceAccount:k8s-nodes@${local.gcp_project.name}.iam.gserviceaccount.com"
      ]
      writers = [
      ]
      description = "images for all containers"
    }
  }
}
