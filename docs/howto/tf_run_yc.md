# Tf yc prerequisites

Before running tf with `env.cloud.type` configured to `yc` in `terraform.tfvars.json`

1. Install `yc` cli
2. `yc init`
3. Copy yandex cloud `.bazelrc` file 
    - Run `cp .bazelrc.cloud.yc .bazelrc.cloud`
4. To access state file create static access and secret keys for `tf-state` service account
    - Run `yc iam access-key create --service-account-name tf-state`
5. Copy `key_id` and add it to all occurrences of `AWS_ACCESS_KEY_ID` eg `AWS_ACCESS_KEY_ID=YCABRCDEFGHIGKLMNOPQRS32O`
6. Copy `secret` and add it to all occurrences of `AWS_SECRET_ACCESS_KEY` eg `AWS_SECRET_ACCESS_KEY=<secret>`
7. Execute `export YC_TOKEN=$(yc iam create-token)`
8. follow steps from [running tf](tf_run.md)
