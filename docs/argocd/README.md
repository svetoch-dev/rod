# argocd

All k8s resources are managed by gitops tool - [argocd](https://github.com/argoproj/argo-cd). All commits to files in `argocd/` folder in `master` branch change the sate of k8s resources

## Structure

TBD

## Making changes

If you need to make changes to the application or an infrastructure component you need to

1. Create a new branch
2. Make changes to your app under `argocd/environments/<your env>/<your app>/values.yaml` and commit them
3. Make a PR/MR and head for `master` branch
4. After PR/MR is reviewed and merged head to `argocd` and login - `https://ag.int.<you company domain name>` example `https://ag.int.acme.com`
5. Find your app an [review the diff](img/argocd_diff.png) by pressing the `diff` button 
6. [Press sync button](img/argocd_sync.png) to synchronize your changes

If you make sophisticated changes

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
kubectl apply -f argocd/charts/infra/crds/argocd/
```

###  Installation of argocd helm release

```
helm repo add argo https://argoproj.github.io/argo-helm
cd arogcd/charts/infra/charts/argocd
helm dependency update
cd -
kubectl delete secret argocd-redis -n argocd
helm upgrade --install  argocd-gcp-int argocd/charts/infra/charts/argocd/ --set  "redis.enabled=false" --values=argocd/environments/gcp-int/argocd/values.yaml --values argocd/charts/infra/charts/globals.yaml --namespace argocd  --set "global.environment.name=gcp-int" --set "argocd.redis.enabled=true" --set "probes.enabled=false"
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
