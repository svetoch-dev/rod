# terraform.tfvars.json for yc

To configure your infrastructure to run in yandex adjust this fields in `terraform.tfvars.json`

1. `env.cloud.name` should be `yc`
2. `env.cloud.id` should be set to the id of the yandex cloud example: `b1grv6akrivi20i4ahdj`
3. `env.cloud.region` should be set to one of yandex cloyd regions example: `ru-central1`
4. `env.cloud.default_zone` should be set to one of regions default zone example: `ru-central1-a`
5. `env.cloud.multi_region` should be set left empty ""
5. `env.cloud.folder_id` should be set to environment folder id example: `b1gfu8oas3od212hedtu`
6. `env.tf_backend.type` should be set to `s3`
7. `env.tf_backend.configs.bucket` should be set to bucket name where state is (supports templated vars using {var} syntax) example: `{company.name}-terraform-state`
8. `env.tf_backend.configs.use_lockfile` should be set to `true`. Indicates that a lockfile should be used to lock state
9. `env.tf_backend.configs.region` region where the state bucket is created (supports templated vars using {var} syntax) example: `{env.cloud.region}`
10. `env.tf_backend.configs.key` should be set to `{env.name}/{tf_backend.state_name}/default.tfstate` where `tf_backend.state_name` is root_modules folder name
11. `env.tf_backend.configs.skip_region_validation` should be set to `true`
12. `env.tf_backend.configs.skip_credentials_validation` should be set to `true`
13. `env.tf_backend.configs.skip_requesting_account_id` should be set to `true`
14. `env.tf_backend.configs.skip_s3_checksum` should be set to `true`

```
    "internal": {
    ...
      "tf_backend": {
        "type": "s3",
        "configs": {
          "bucket": "{company.name}-tf-state",
          "use_lockfile": "true",
          "region": "{env.cloud.region}",
          "key": "{env.name}/{tf_backend.state_name}/default.tfstate",
          "skip_region_validation": "true",
          "skip_credentials_validation": "true",
          "skip_requesting_account_id": "true",
          "skip_s3_checksum": "true"
        }
      },
      "cloud": {
        "name": "yc",
        "id": "b1grv6akrivi20i4ahdj",
        "region": "ru-central1",
        "default_zone": "ru-central1-a",
        "multi_region": "",
        "folder_id": "b1gfu8oas3od212hedtu",
        ...
      }
      ...
    }
```
