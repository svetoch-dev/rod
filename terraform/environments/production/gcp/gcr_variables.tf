locals {
  gcrs = {
    main = {
      pullers = [
        "serviceAccount:k8s-nodes@${local.gcp_project.name}.iam.gserviceaccount.com"
      ]
      pushers = [
        "serviceAccount:container-images@${local.gcp_project.name}.iam.gserviceaccount.com"
      ]
      registry = {
        create   = true
        location = "EU"
      }
    }
  }
}
