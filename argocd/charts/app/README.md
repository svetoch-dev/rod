# Helm charts
App charts use [helm](https://github.com/helm/helm) to render k8s objects they need


## common
Is the base helm chart where all k8s object templates are defined. Using its helm values you can alter the way k8s objects are rendered. For example setting
```
service :
  enabled: false
```
will tell helm not to create service k8s object

## Example chart
Represents an example microservice application. Each microservice is an instance of `common` chart with individual settings. For example
```
api:
  enabled: true
  replicaCount: 2
state:
  enabled: true
```
This will set `api` microservice replicas to 2 and leave `state` with default value for `replicaCount` in common chart which is 1

### Dependecies
App charts can have additional chart dependecies for example
* redis-operated - chart creates `RedisFailover` resources managed by [spotahome redis operator](https://github.com/spotahome/redis-operator)

### Adding new microservices
To add a new microservice to an app chart - create a new `common` dependency in `example/Chart.yaml` and define `alias:` attribute and give it a name of the new microservice. For example

```
apiVersion: v2
name: example
version: 1.0.0
dependencies:
  - name: common
    version: 0.1.0
    repository: file://../../infra/chart_deps/app/common/
    alias: state
    condition: state.enabled
...
  - name: common
    version: 0.1.0
    repository: file://../../infra/chart_deps/app/common/
    alias: newmicroservice
    condition: newmicroservice.enabled
```
Then enable this service and add default values for this micorservice in `example/values.yaml` . For example
```
...
state:
  enabled: true
  replicaCount: 2
...
newmicroservice:
  enabled: true
  ports:
  - name: http
    containerPort: 3008
    protocol: TCP
....
```

After that you have to run lock file build by:
```
cd ./charts/example
helm dep update
helm dependency build .
```

### Default values
App charts can be can have different configuration depending on the situation. For example in different environments postgres url env var can have different values. But some settings, for a specific microservice, will probably be the same in all cases. Those settings are configured in `example/values.yaml`. An example of such settings could be
* ports
* livenessProbe
* readinessProbe

### Per environment values
Per environment (prod,dev etc) values can be found in [argocd](../../) folder at `argocd/environments/<env>/example/values.yaml`

### Global values
To set helm variables that will be applied to all microservices use `global` section. For example
```
global:
  environment:
  - name: POSTGRES_PORT
    value: "5432"
...
```
This will set  an environment value POSTGRES_PORT=5432 for all microservices.
Currently supported values are
* environment
* environmentFromSecrets
* image.tag
* image.repository
* nodeSelector
* tolerations
