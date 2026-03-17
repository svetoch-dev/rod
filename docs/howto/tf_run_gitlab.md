# Tf gitlab prerequisites

Before running tf with `repo.type` configured to `gitlab` in `terraform.tfvars.json`

1. `export GITLAB_BASE_URL=<gitlab_server>/api/v4`. Set `gitlab_server` to  https://gitlab.com/api/v4/ for saas gitlab
2. `export GITLAB_TOKEN=<token>`
3. Run `bazel build :rplan`
4. Run `bazel run :rapply`
