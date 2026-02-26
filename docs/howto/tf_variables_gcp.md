# terraform.tfvars.json for gcp

To configure your infrastructure to run in gcp adjust this fields in `terraform.tfvars.json`

1. `env.cloud.name` should be `gcp`
2. `env.cloud.id` should be set to the id of the project example: `rod-production`
3. `env.cloud.region` should be set to one of gcp regions example: `europe-west2`
4. `env.cloud.default_zone` should be set to one of regions default zone example: `europe-west2-a`
5. `env.cloud.multi_region` should be set to one of `EU,US,ASIA` example: `EU`


```
    "production": {
    ...
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
