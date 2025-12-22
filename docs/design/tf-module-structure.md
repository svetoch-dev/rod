# Tf module structure

## Current state

Currently our tf module structure looks like this

```
                                                           -> tf-modules/modules/gcp/networking
environtments/<some_env>/gcp -> tf-modules/modules/gcp     -> tf-modules/modules/gcp/gke
                                                           -> tf-modules/modules/gcp/gcs
                                                           -> ....

                                                           -> tf-modules/modules/k8s/rbac
environments/<some_env>/gke -> tf-modules/module/k8s       -> tf-modules/modules/k8s/namespaces
                                                           -> ....

                                                           -> tf-modules/modules/github/repository
environments/<some_env>/github -> tf-modules/module/github -> ....
                                                           -> ....
```

tf-modules repository can be found here https://github.com/svetoch-dev/tf-modules


### Issues

The current structure has several significant limitations:


1. **Hard to support multiple projects**
   Projects typically have at least two environments (e.g., `int` and `prd`). Adding a new resource, like a bucket, requires repeating code at least `2*n + 2` times (where `n` is the number of projects). This approach quickly becomes unsustainable as the number of projects grows.

2. **Cloud-specific root modules**
   Every root module in `environments/<some_env>` is tied to a specific cloud or service. This makes managing projects across multiple clouds difficult and error-prone.


## Desired State

To address these issues, we propose introducing an **intermediate module** that abstracts away cloud-specific implementations.


```
                                                               |                           -> tf-modules/aws/s3
                                                               |-> tf-modules/modules/aws  -> tf-modules/aws/networking
                                                               |                           -> ...
                                                               |
                                                               |
                                                               |                           -> tf-modules/modules/gcp/networking
environtments/<some_env>/cloud -> tf-modules/modules/rod/cloud |-> tf-modules/modules/gcp  -> tf-modules/modules/gcp/gcs
                                                               |                           -> ...
                                                               |
                                                               |
                                                               |                           -> tf-modules/modules/yc/ycs
                                                               |-> tf-modules/modules/yc   -> tf-modules/modules/yc/networking
                                                               |                           -> ...

```


### Benefits

- Single entry point for cloud-specific resources (`modules/rod/cloud`)
- Reduced code duplication across projects and environments
- Easier multi-cloud support



### Setup

1. Main Terraform Module in envrionment

```
...

module "cloud" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/rod/cloud?ref=rod-v0.1.0"
  cloud = {
    name     = "aws",
    id       = "123456789012",
    region   = "us-east1",
    registry = "123456789012.dkr.ecr.us-east-1.amazonaws.com/",
    buckets  = {
      "deletion_protection =  "true"
    },
    default_zone    =  "us-east1-b",
    multi_region    =  "US"
  }

}
```

2. Based on `var.cloud.name` a specific cloud module is chosen

```
...

module "aws" {
  source     = "../../aws"
  count      = var.cloud.name == "aws" ? 1 : 0
  id         = "123456789012",
  region     = "us-east1",
  s3         = local.aws_s3
  networking = local.aws_networking
  ...
}

module "gcp" {
  source     = "../../gcp"
  count      = var.cloud.name == "gcp" ? 1 : 0
  project = {
    id     = var.cloud.id
    region = var.cloud.region
  }

  activate_apis = local.gcp_activate_apis
  networks      = local.gcp_networks
  gke_clusters  = local.gcp_gke_clusters
  ....
}

```

3. Resources are created based on local variables in `<cloud>_<component>_variables.tf` files


4. Overriding defaults. Any setting in `modules/rod/cloud` can be overridden:

```
...

module "cloud" {
  source = "git::https://github.com/svetoch-dev/tf-modules.git//modules/rod/cloud?ref=rod-v0.1.0"
  cloud = {
    name     = "aws",
    id       = "123456789012",
    region   = "us-east1",
    registry = "123456789012.dkr.ecr.us-east-1.amazonaws.com/",
    buckets  = {
      "deletion_protection =  "true"
    },
    default_zone    =  "us-east1-b",
    multi_region    =  "US"
  }

  aws_s3 = {
    "company-loki-prd" = {
      name  = "company-loki-prd-v2"
    }
  }

}
```

This could be achieved via this providers
https://github.com/isometry/terraform-provider-deepmerge

