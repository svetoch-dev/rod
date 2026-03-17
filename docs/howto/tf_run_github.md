# Tf github prerequisites

Before running tf with `repo.type` configured to `github` in `terraform.tfvars.json`

1. Install `gh` (Github cli) cli (https://github.com/cli/cli/releases)
2. Issue `gh auth login` and go through the auth process
3. Run `export GITHUB_TOKEN=$(gh auth token)`
3. Run `bazel build :rplan`
4. Run `bazel run :rapply`
