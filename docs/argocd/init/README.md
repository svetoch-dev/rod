# Initiazlizing argocd

This script is responsible for initiazlizing argocd (NOT YET IMPLEMENTED). After initial setup all k8s resources are managed by commiting their state to `argocd` folder in `master` branch


```
bazel run @svetoch_bazel_lib//scripts/init/argocd 

```

What it does is

1. Installation of argocd CRDs

```
kubectl apply -f argocd/charts/infra/crds/argocd/
```

2. Installation of argocd helm release

```
helm repo add argo https://argoproj.github.io/argo-helm
cd arogcd/charts/infra/charts/argocd
helm dependency update
cd -
kubectl delete secret argocd-redis -n argocd
helm upgrade --install  argocd-gcp-int argocd/charts/infra/charts/argocd/ --set  "redis.enabled=false" --values=argocd/environments/gcp-int/argocd/values.yaml --values argocd/charts/infra/charts/globals.yaml --namespace argocd  --set "global.environment.name=gcp-int" --set "argocd.redis.enabled=true" --set "probes.enabled=false"
```

3. Creating a root argocd application

```
#./root.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: root
  namespace: argocd
spec:
  destination:
    server: https://kubernetes.default.svc
    namespace: argocd
  project: default
  source:
    repoURL: <repo_url>
    path: infra/argocd/charts/infra/charts/environments
    targetRevision: master
    helm:
      valueFiles:
        - ../globals.yaml
        - ../../../../envs.yaml
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

```
kubectl apply -f root.yaml
```
