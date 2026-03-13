# Tf (terraform)

## Definitions
`root module` - logically grouped infrastructure definitions that have thier own folder and statefile (example `terraform/environments/internal/cloud`, `terraform/environments/internal/secrets` etc)
`submodule` - a tf module that creates resources and is used in `root module` example

```
module "repos" {
  source    = "git::https://github.com/svetoch-dev/tf-modules.git//modules/rod/repos/{repo.type}?ref=v0.7.2"
  repo      = var.repo
  overrides = local.overrides
}
```


## Concepts
* We are using a single per provider module and turn off/on its components based on passed variables
  * MOTIVATION: this DRYs the code and decreases configuration drift between envs
* We give each env its own folder under `terraform/environments` dir 
* Each environment has a set of `root modules` describing this env
* We give each `api dependant provider` a separate `root module` thus a separate folder
  * MOTIVATION: for example you have a postgres provider that points to a cloudsql and a gcp provider that creates this cloudsql instance and other gcp objects. If for some reason the postgres provider will not be able to connect to cloudsql instance you will not be able to do `terraform plan/apply` for any of the resource described in this root module
* We do not store multiple `api dependant providers` of the same type but with different configs in one `root module` (postgres is an exception to this)
* Its ok to mix `api dependant providers` (gcp/aws/k8s/cloudflare) and `api independant providers` (null,random etc) in one `state`
* Data is shared between `root modules` using output variables and `terraform_remote_state` data resource

## Rod submodules

Rod submodules are a special kind of modules that are related to [rod](https://github.com/svetoch-dev/rod) template. Each rod submodules

* Has predefined set of resources used in template
* Has the ability to override default resource attributes via the `overrides` input var

Check out [this](./proposals/tf-module-structure.md) doc for more info


## Bazel

* We run tf via bazel and [rules_tf](https://github.com/ggramal/rules_tf).
* We also use bazel macros for plan/apply/lint/etc targets. Tf macros can be found [here](https://github.com/svetoch-dev/bazel-lib/blob/master/tools/macros/tf.bzl).
* Each `root module` must have a tf macro initialized like this in its BUILD.bazel

```
load("@svetoch_bazel_lib//tools/macros:tf.bzl", "tf")

tf()
```

* tf macro
  * renders `@svetoch_bazel_lib//terraform/tf_variables.tf.tpl` to a `tf_variables.tf`file in `root module`
  * renders `terraform.tfvars.json` and adds it to `root module`
  * renders `main.tf.tpl` in `root module`
  * creates `tf_fmt, tf_fmt_test, tf_validate_test, tf_plan, tf_apply, tf_bin` rule targets


## root module structure

### tf_variables.tf

* `tf_variables.tf` if a special file that each `root module` has. Global variables are stored in it. Variables like
  * Env definitions
  * company info
  * ci info
  * etc
* `tf_variables.tf` is rendered by bazel from [tf_variables.tf.tpl](https://github.com/svetoch-dev/bazel-lib/blob/master/terraform/tf_variables.tf.tpl) file.

### terraform.tfvars.json

* `terraform.tfvars.json` stores  values for vars defined in `tf_variables.tf`
  * `terraform.tfvars.json` also can contain templates and is rendered by bazel
  * `terraform.tfvars.json` is a single file that is always stored at repo root

### main.tf.tpl

* `main.tf.tpl`  file that each `root module` must have. `main.tf.tpl` should describe all submodules used and a `terraform` block

### *_variables.tf

* `*_variables.tf` is a conventional name for files storing submodule attributes (example: `dns_variables.tf`, `k8s_variables.tf` etc). Those attributes are stored in as `local` vars in  `locals {}` block

### overrides.tf

* File that stores overrided values of `rod` modules


### tf_locals.tf

* File that stores configuration for  `data terraform_remote_state` used by `root module`

### output.tf
* `root module` output


## Running

### Locally

Check out the READMEs in `root module` folders
