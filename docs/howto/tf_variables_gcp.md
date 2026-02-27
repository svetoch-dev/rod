# terraform.tfvars.json for gcp

To configure your infrastructure to run in gcp adjust this fields in `terraform.tfvars.json`

1. `env.cloud.name` should be `gcp`
2. `env.cloud.id` should be set to the id of the project. example: `rod-production`
3. `env.cloud.region` should be set to one of gcp regions. example: `europe-west2`
4. `env.cloud.default_zone` should be set to one of regions default zone. example: `europe-west2-a`
5. `env.cloud.multi_region` should be set to one of `EU,US,ASIA`. example: `EU`
6. `env.tf_backend.type` should be set to `gcs`
7. `env.tf_backend.configs.bucket` should be set to bucket name where state is (supports templated vars using {var} syntax). example: `{company.name}-terraform-state`
8. `env.tf_backend.configs.prefix` should be set to `{env.name}/{tf_backend.state_name}` where `tf_backend.state_name` is root_modules folder name


```
    "production": {
    ...
      "tf_backend": {
        "type": "gcs",
        "configs": {
          "bucket": "{company.name}-tf-state",
          "prefix": "{env.name}/{tf_backend.state_name}"
        }
      },
      "cloud": {
        "name": "gcp",
        "id": "rod-production",
        "default_zone": "europe-west2",
        "multi_region": "EU",
        ...
      }
      ...
    }
```
