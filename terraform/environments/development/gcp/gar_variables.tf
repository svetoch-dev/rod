locals {
  gars = {
    containers = {
      location = local.env.cloud.region
      readers = [
        "serviceAccount:k8s-nodes@${local.env.cloud.id}.iam.gserviceaccount.com"
      ]
      writers = [
        "serviceAccount:container-images@${local.env.cloud.id}.iam.gserviceaccount.com"
      ]
      description = "images for all microservices"
    }
  }
}
