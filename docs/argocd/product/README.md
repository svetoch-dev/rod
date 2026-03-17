# Product Helm charts

charts in `argocd/charts/app` are charts that are responsible for creating Kubernetes resources for product applications.

## Common chart

The `common` chart is the base product Helm chart where the Kubernetes object templates are defined.

You can control how resources are rendered through Helm values. For example:

```yaml
service:
  enabled: false
```

This tells Helm not to create a Kubernetes `Service` resource.

## Example app chart (NOT IMPLEMENTED)

The chart in `argocd/charts/app/example` represents an example microservice-based application.

## Product app chart structure

Each microservice is implemented as an instance of the `common` chart with its own settings. For example:

```yaml
api:
  enabled: true
  replicaCount: 2

state:
  enabled: true
```

This configuration sets the `api` microservice replica count to `2` and leaves `state` with the default `replicaCount` from the `common` chart, which is `1`.

### Dependencies

App charts can also have additional chart dependencies. For example:

- `redis-operated` - creates `RedisFailover` resources managed by the [Spotahome Redis Operator](https://github.com/spotahome/redis-operator)

### Adding a new microservice

To add a new microservice to an app chart:

1. Add a new `common` dependency to `<product-app>/Chart.yaml`
2. Set the `alias:` field to the name of the new microservice
3. Add default values for that microservice to `<product-app>/values.yaml`

Example:

```yaml
apiVersion: v2
name: my-awesome-app
version: 1.0.0

dependencies:
  - name: common
    version: 0.1.0
    repository: file://../../infra/chart_deps/app/common/
    alias: state
    condition: state.enabled

  - name: common
    version: 0.1.0
    repository: file://../../infra/chart_deps/app/common/
    alias: newmicroservice
    condition: newmicroservice.enabled
```

Then add the default values in `<product-app>/values.yaml`:

```yaml
state:
  enabled: true
  replicaCount: 2

newmicroservice:
  enabled: true
  ports:
    - name: http
      containerPort: 3008
      protocol: TCP
```

After that, rebuild the chart lock file and dependencies:

```bash
cd ./charts/<product-app>
helm dep update
helm dependency build .
```

## Default values

App charts can have different configuration depending on the environment or deployment scenario.

For example, in different environments, a Postgres URL environment variable might have different values. However, some settings for a given microservice are usually shared across all environments.

Those common defaults should be defined in `<product-app>/values.yaml`.

Typical examples include:

- `ports`
- `livenessProbe`
- `readinessProbe`

## Per-environment values

Environment-specific values such as `dev`, `int`, or `prod` are stored under:

```text
argocd/environments/<env>/<product-app>/values.yaml
```

## Global values

To define Helm values that should be applied to all microservices, use the `global` section.

Example:

```yaml
global:
  environment:
    - name: POSTGRES_PORT
      value: "5432"
```

This sets the environment variable `POSTGRES_PORT=5432` for all microservices.

Currently supported global values are:

- `environment`
- `environmentFromSecrets`
- `image.tag`
- `image.repository`
- `nodeSelector`
- `tolerations`
