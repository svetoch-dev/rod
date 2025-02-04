# Terraform
Definitions of various systems used to setup infrastructure

## Running with bazel
To run terraform commands you **need** to use `bazel`

### run tests
To run all terraform tests (`fmt`,`validate`) you can execute

```
bazel test //...
```

### plan/apply

To run all plan/apply you can execute

```
$ bazel build $(bazel query 'attr(name, "^plan$", "//...")')
$ bazel query 'attr(name, "^apply$", "//...")' | xargs -I{} bazel run {}
```

To run `plan/apply` in certain `state` you need to `cd terraform/environments/<env>/<state>/` and then execute `bazel run :plan` or `bazel run :apply`. Example `cd terraform/environments/gcp; bazel run plan`

### run various terraform commands
There is a possibility to run various tf commands via `bazel run :tf -- <command> <command args>`.

Examples:
* `bazel run :tf -- import 'module.secrets["some-service"].module.import_secret["some-secret"].secret_resource.secret' 'SuperSecret'`
* `bazel run :tf -- force-unlock -force 1730215139325387`
* `bazel run :tf -- plan -parallelism=100`

### fix lint

To fix linting issues run this command

```
$ bazel query 'filter("fmt_fix", "//...")' | xargs -I{} bazel run {}
```

## Definitions
`state` - logically grouped infrastructure definition that has its own folder and statefile

## Concepts
* We are using a single per provider module and turn off/on its components based on passed variables
  * MOTIVATION: this DRYs the code and decreases configuration drift between envs
* We give each env its own folder and define `states` related to this env
* We give each `api dependant provider` a separate `state` thus a separate folder
  * MOTIVATION: for example you have a postgres provider that points to a cloudsql and a gcp provider that creates this cloudsql instance and other gcp objects. If for some reason the postgres provider will not be able to connect to cloudsql instance you will not be able to do `terraform plan/apply` for any of the resource described in this state
* We try not to store multiple `api dependant providers` of the same type but with different configs in one `state` (postgres is an exception)
* If using a provider name is not suitable for our use case and/or goes against the above `concepts` (for example we setup k8s clusters using different cloud providers) we use logical names (gke,aks,eks) for `states`
* Its ok to mix `api dependant providers` (gcp/aws/k8s/cloudflare) and `api independant providers` (null,random etc) in one `state`
* Data is shared between `states` using output variables and `terraform_remote_state` data resource

## Structure

### environments

* each environment has its root folder (environments/internal, environments/production etc).
* each environment has per `state` definition (postgres,gcp etc) in different folders
* each component of a `state` has its on variable file with `_variables.tf` suffix added. For example - `vpc_variables.tf`,`gke_variables.tf` `rbac_variables.tf`. In this files we use `locals` to define components variables
* there is a special `tf_variables.tf` file where we store global per `state` variables like
  * project ids
  * domain names
  * env names
  * `remote_states`
* each `state` has a `main.tf` file that has
  * `terraform` definition
  * providers definitions
  * `terraform_remote_state` definitions
  * single provider module


### modules
`modules` folder is where all modules are stored.
* modules are grouped per provider
* each provider folder is itself a module that includes child modules (gcp/network, gcp/iam). That are turned on and off based on vars passed to provdider module



## Initial configuration steps

### GCS state

1. Create GCS bucket using gcp console
  1.1 Give a globally unique name (`example-tf-state`)
  1.2 Specify region (multi-region)
  1.3 Choose Fine grained ACL
  1.4 Set object versioning
    1.4.1 Set max number of versions per object to a high value (like 100)
    1.4.2 Set expire noncurrent versions to 30d
3. For each provider(folders in environments) add a configuration block
```
terraform {
  required_providers {
    ...
  }
  required_version = "~> 1.7"
  backend "gcs" {
    bucket = "<bucket_name>"
    prefix = "<env>/<provider|logical purpose>"
  }
}
```
where
`<bucket_name>` - name of the bucket that was created
`<env>` - is the environment name (like development/production/internal or short version dev/int/prd)
`<provider|logical purpose>` - name of the provider used (gcp/aws/k8s/postgres) or logical purpose of this state (secrets/gke/eks/aks)

### Apply order
1. cloud provider (gcp/aws etc)
2. k8s related (states eg eks/gke etc)
3. dbs (postgres/mysql etc)
4. git repo providers (github/gitlab etc)
5. secrets


## Running

### Locally
Check out the READMEs in env/provider folders
