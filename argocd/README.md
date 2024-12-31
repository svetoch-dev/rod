# argocd
Definitions of k8s resources. Currently all k8s resources configured in this folder are managed by gitops tool - [argocd](https://github.com/argoproj/argo-cd).
All commits to files in this folder in `master` branch change the sate of the infrastructure

## Contributing
Follow this steps for contributing as maintainer of this repo :
* Create a branch with a name that follows `<task id>-<what is the purpose of this branch>` pattern Example: `DO-95-add-thanos-to-internal`
* In one of  `argocd/environments/*/env.yaml` files change the corresponding app `revision:` attribute to the branch you have created
Example
```
diff --git a/argocd/environments/gcp-int/env.yaml b/argocd/environments/gcp-int/env.yaml
index 579fd29..d7088af 100644
--- a/argocd/environments/gcp-int/env.yaml
+++ b/argocd/environments/gcp-int/env.yaml
@@ -13,9 +13,10 @@ chart_apps:
 #  grafana:
 #    enabled: true
 #    namespace: grafana
-  thanos:
-    enabled: true
-    namespace: prometheus
+  thanos:
+    enabled: true
+    namespace: prometheus
+    revision: DO-95-add-thanos-to-internal
```
* Commit your changes and push it
* Make a PR/MR and head for master branch. Do not delete the newly created branch by ticking `delete source branch`
* After PR/MR is merged you can add code for your feature in the newly created branch. Changes will be reflected in your app through argocd
* When the feature is ready
  * remove revision attribute from the app in `env.yaml` and commit the change
  * make another PR/MR and head for master


## Initial setup
An initial setup should have been completed in order to achieve git operations. Below is a list of steps that were performed.
This intial setup has been done only **once**. After initial setup all k8s resources are managed by commiting their state to `argocd` folder in `master` branch

(assuming we are in argocd folder)
###  Installation of argocd CRDs

```
kubectl apply -f environments/gcp-int/manifests/crds/argocd/
```

### Create an argocd namespace
```
kubectl create namespace argocd
```

###  Installation of argocd helm release

```
helm repo add argo https://argoproj.github.io/argo-helm
cd charts/argocd
helm dependency update
helm upgrade --values=environments/gcp-int/argocd/values.yaml argocd-gcp-int charts/argocd/ --namespace argocd  --install
```

### Creating a root argocd application

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
    path: argocd/charts/environments
    repoURL: https://github.com/somecompany/infrastructure.git
    targetRevision: master
    helm:
      valueFiles: 
        - ../../envs.yaml
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```

```
kubectl apply -f root.yaml
```
