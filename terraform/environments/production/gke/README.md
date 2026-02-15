# Terraform k8s
Definition of k8s resources

## Initial configuration steps

1. `../cloud/` `state` must be fully applied


## Running locally

### GCP

You need to
1. Install `gcloud` cli
2. Set credentials by one of two ways:
    - Run `export GOOGLE_CREDENTIALS="<path>"`
    - Run `gcloud auth application-default login`
3. Run `bazel build :plan`
4. Run `bazel run :apply`
