# Terraform github
Definition of github objects

## Running locally

You need to
1. Install `gh` (Github cli) cli (https://github.com/cli/cli/releases)
2. Issue `gh auth login` and go through the auth process
3. Run `export GITHUB_TOKEN=$(gh auth token)`
3. Run `bazel build :gh_plan`
4. Run `bazel run :gh_apply`
