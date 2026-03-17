# Tf

## Definitions

* `root module` — a logically grouped set of infrastructure definitions with its own folder and state file, for example:
  * `terraform/environments/internal/cloud`
  * `terraform/environments/internal/secrets`

* `submodule` — a Terraform module that creates resources and is used inside a `root module`, for example:

```hcl
module "repos" {
  source    = "git::https://github.com/svetoch-dev/tf-modules.git//modules/rod/repos/{repo.type}?ref=v0.7.2"
  repo      = var.repo
  overrides = local.overrides
}
```
## Directory structure

```
terraform/
├── environments
│   ├── <env 1>
│   │   ├── <root module 1>
│   │   │   ...
│   │   └── <root module n>
│   │       ...
│   ├── <env n>
│   │   ├── <root module 1>
│   │   │   ...
│   │   └── <root module n>
│   │       ...
└── modules(optional)
    ├── <submodule 1>
    │   ....
    │
    │
    └── <submodule n>
        ....
```

Example

```
terraform/
└── environments
    ├── internal
    │   ├── cloud
    │   │   ...
    │   ├── k8s
    │   │   ...
    │   ├── k8s
    │   │   ...
    │   ├── repo
    │   │   ...
    │   └── secrets
    │       ...
    └── production
        ├── cloud
        │   ...
        ├── k8s
        │   ...
        ├── k8s
        │   ...
        ├── repo
        │   ...
        └── secrets
            ...
```

## Concepts

* We use a single module per provider and enable or disable its components through input variables.
  * MOTIVATION: this keeps the code DRY and reduces configuration drift between environments.
* Each environment has its own folder under `terraform/environments`.
* Each environment contains a set of `root modules` that describe that environment.
* Each `API-dependent provider` should have its own `root module`, and therefore its own folder.
  * MOTIVATION: for example, imagine a PostgreSQL provider that connects to a Cloud SQL instance, while a GCP provider creates that Cloud SQL instance and other GCP resources. If the PostgreSQL provider cannot connect to Cloud SQL for some reason, then `terraform plan/apply` would fail for all resources defined in the same `root module`.
* We do not keep multiple `API-dependent providers` of the same type but with different configurations in a single `root module`.
  * `postgres` is an exception to this rule.
* It is fine to mix `API-dependent providers` (`gcp`, `aws`, `k8s`, `cloudflare`) with `API-independent providers` (`null`, `random`, etc.) in the same `root module`.
* Data is shared between `root modules` through output values and the `terraform_remote_state` data source.

## Rod submodules

Rod submodules are a special type of module related to the [rod](https://github.com/svetoch-dev/rod) template.

Each rod submodule:

* has a predefined set of resources used by the template
* allows overriding default resource attributes through the `overrides` input variable

See [this](./proposals/tf-module-structure.md) document for more details.

## Bazel

* We run Terraform through Bazel using [rules_tf](https://github.com/ggramal/rules_tf).
* We also use Bazel macros for `plan`, `apply`, `lint`, and related targets.
* Terraform macros can be found [here](https://github.com/svetoch-dev/bazel-lib/blob/master/tools/macros/tf.bzl).
* Each `root module` must initialize the Terraform macro in its `BUILD.bazel` file like this:

```python
load("@svetoch_bazel_lib//tools/macros:tf.bzl", "tf")

tf()
```

* The `tf` macro:
  * renders [tf_variables.tf.tpl](https://github.com/svetoch-dev/bazel-lib/blob/master/terraform/tf_variables.tf.tpl) into `tf_variables.tf` inside the `root module`
  * renders `terraform.tfvars.json` and adds it to the `root module`
  * renders `main.tf.tpl` in the `root module`
  * creates the following Bazel targets:
    * `tf_fmt`
    * `tf_fmt_test`
    * `tf_validate_test`
    * `tf_plan`
    * `tf_apply`
    * `tf_bin`

## root module structure

### tf_variables.tf

* `tf_variables.tf` is a special file present in each `root module`.
* It stores global variables such as:
  * environment definitions
  * company information
  * CI information
  * other shared values
* `tf_variables.tf` is rendered by Bazel from [tf_variables.tf.tpl](https://github.com/svetoch-dev/bazel-lib/blob/master/terraform/tf_variables.tf.tpl).

### terraform.tfvars.json

* `terraform.tfvars.json` stores values for variables defined in `tf_variables.tf`.
* `terraform.tfvars.json` can also contain templates and is rendered by Bazel.
* `terraform.tfvars.json` is a single file that is always stored at the repository root.

### main.tf.tpl

* `main.tf.tpl` is a required file for each `root module`.
* It should define all submodules used by the `root module`, as well as the `terraform` block.

### *_variables.tf

* `*_variables.tf` is the conventional name for files that store submodule attributes, for example:
  * `dns_variables.tf`
  * `k8s_variables.tf`
* These attributes are typically stored as local variables inside a `locals {}` block.

### overrides.tf

* Stores overridden values for `rod` modules.

### tf_locals.tf

* Stores configuration for `data "terraform_remote_state"` used by the `root module`.

### output.tf

* Defines `root module` outputs.

## Running

### Locally

Check the `README.md` files inside individual `root module` folders.
