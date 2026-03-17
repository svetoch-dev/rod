# Infrastructure initialization 

To spinup your infrastructure from `rod` template several steps should be performed

* Fulfill Cloud specific prerequisites
* Fulfill git repo prerequisites
* Clone https://github.com/svetoch-dev/rod
* Configure `terraform.tfvars.json`
* Run init script


## Cloud specific prerequisites

You can find detailed instructions [here](prerequisites/cloud/README.md)

## Git repo prerequisites

You can find detailed instructions [here](prerequisites/repo/README.md)

## Configure terraform.tfvars.json

Based on what you have configured in cloud and repo prerequisites you need to adjust `terraform.tfvars.json`

detailed instruction can be [here](terraform.tfvars.json/README.md)

## Init script

Init script creates and initializes all infrastructure components.


```
bazel run @svetoch_bazel_lib//scripts/init
```

This script

* Removes `.git` folder from cloned rod repo
* Initializes terraform (more info can be found [here](../tf/init/README.md))
* Initializes new git repo based on `repo` configs in `terraform.tfvars.json` (NOT IMPLEMENTED)
* Makes an initial commit and pushes it (NOT IMPLEMENTED)
* Initializes argocd (more info can be found [here](../argocd/init/README.md)) (NOT IMPLEMENTED)
* Pushes all custom images (mainly needed for ci/monitoring) in `deps/images` folder
