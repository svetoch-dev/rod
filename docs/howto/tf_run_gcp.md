# Tf gcp prerequisites

Before running tf with `env.cloud.type` configured to `gcp` in `terraform.tfvars.json`

1. Install `gcloud` cli
2. Set credentials by one of two ways:
    - Run `export GOOGLE_CREDENTIALS="<path>"`
    - Run `gcloud auth application-default login`
3. follow steps from [running tf](tf_run.md)

