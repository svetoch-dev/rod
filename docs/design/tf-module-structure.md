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

Where tf-modules is https://github.com/svetoch-dev/tf-modules


### Issues

There are several major issues with current state

1. Hard to support multiple projects. Projects at least have 2 envs (int + prd). So, for example, if we need to add a new bucket to our code the minimum amount of times we need to repeat ourselfs  is `2*n + 2(rod template)` where n - is number of projects. As you can see it will quickly become unsupportable with many projects
2. Cloud specific. Every root module in `environments/<some_env>` is cloud or service specific so it becomes very hard to operate projects in different clouds


## Desired state

One way to fix issues in current tf modules structure is to introduce a new intermediate module that will abstract away cloud specific implementation


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

In this setup 


1. We will have a main.tf with this code

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

2. Based on `var.cloud.name` a specific cloud module will be chosen

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

3. Cloud module will then create needed resources based on local variables in `<cloud>_<component>_variables.tf` files


4. There should also be an ability to override any setting in `modules/rod/cloud` module like so

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

