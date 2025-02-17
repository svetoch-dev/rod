locals {
  gars = {
    containers = {
      location = local.env.cloud.region
      readers = [
        "serviceAccount:k8s-nodes@${local.env.cloud.id}.iam.gserviceaccount.com"
      ]
      writers = [
      ]
      description = "images for all containers"
    }
  }
}
