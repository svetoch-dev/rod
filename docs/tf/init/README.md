# Initiazlizing tf

This script is responsible for initiazlizing tf

```
bazel run @svetoch_bazel_lib//scripts/init/tf
```

What it does is

1. Makes cloud specific preparations (for example enables specific api for gcp)
2. Creates tf state based on configuration in `terraform.tfvars.json`
3. applies all `root modules`
4. Creates secrets specified in `terraform.tfvars.json`
5. Removes unneeded folders
