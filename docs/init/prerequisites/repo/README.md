# Repo prerequisites

Git repo related steps that need to be done before spinning up `rod` template


## Github

1. Create an `infrastructure` (can be called what ever you like) repo inside your github group or your personal profile
2. [Download gh cli](https://cli.github.com/)
3. execute `gh auth login`
4. execute `export GITHUB_TOKEN=$(gh auth token)`


## Gitlab

1. Create an `infrastructure` (can be called what ever you like) repo inside your github group or your personal profile
2. `export GITLAB_BASE_URL=<gitlab_server>/api/v4`. Set `gitlab_server` to  https://gitlab.com/api/v4/ for SaaS gitlab
3. [Create personal token](https://docs.gitlab.com/user/profile/personal_access_tokens/)
4. `export GITLAB_TOKEN=<token>`

