# Cloud prerequisites

Cloud related steps that need to be done before spinning up `rod` template

## gcp

1. [Create a gcp billing account](https://docs.cloud.google.com/billing/docs/how-to/create-billing-account)
2. [Create an internal gcp project](https://docs.cloud.google.com/resource-manager/docs/creating-managing-projects) with id `<company|project>-internal` example `acme-internal`
3. [Create product gcp project(s)](https://docs.cloud.google.com/resource-manager/docs/creating-managing-projects)  with id `<company|project>-<product_env_name>` example `acme-production`, `acme-development`, `acme-preprod`
4. [Install gcloud cli](https://docs.cloud.google.com/sdk/docs/downloads-interactive)
5. Execute `gcloud auth login`
6. Execute `gcloud auth application-default login`


## yc (Yandex cloud)

1. [Create a yc billing account](https://yandex.cloud/ru/docs/billing/quickstart/)
2. [Create a cloud](https://yandex.cloud/ru/docs/resource-manager/operations/cloud/create) with name `<company|project>` example `acme`
3. [Create internal resource folder](https://yandex.cloud/ru/docs/resource-manager/operations/folder/create) with name `internal`
4. [Create product resource folder(s)](https://yandex.cloud/ru/docs/resource-manager/operations/folder/create). Example names - `development`, `preprod`, `production`, `sandbox` etc
5. [Install yc cli](https://yandex.cloud/ru/docs/cli/operations/install-cli)
6. Execute `export YC_TOKEN=$(yc iam create-token)`
