# Helm charts
This folder contains helm charts used in argocd to render k8s manifests

## app
Folder where app charts are stored

## infra
This is a `git submodule` that references a repository that contains common infrastructure components for security/monitoring/load balancing etc

### operations
Common operations for the infra submodule

#### Updating
Infra submodule references a versioned branch (eg `release-v4.3.0`) that contains helm chart source code. To update to a new version of charts

1. Open `.gitmodules` file and edit branch field

2. Execute

```
git submodule update --init --recursive --remote
```
