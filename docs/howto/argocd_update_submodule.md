# svetoch-dev/helm-charts update

`rod` templates use https://github.com/svetoch-dev/helm-charts for centralized Helm chart management. `svetoch-dev/helm-charts` is included and updated via Git submodules. To update to a new version of `svetoch-dev/helm-charts`

1. Open `.gitmodules` file and edit branch field

2. Execute

```
git submodule update --init --recursive --remote
```
