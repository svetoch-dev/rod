# Tf module structure

## Current state

Currently our tf module structure looks like this

```
                                                           -> tf-modules/modules/gcp/networking
environtments/<some_env>/gcp -> tf-modules/modules/gcp     -> tf-modules/modules/gcp/gke
                                                           -> tf-modules/modules/gcp/gcs
                                                           -> ....

                                                           -> tf-modules/modules/k8s/rbac
environments/<some_env>/gke -> tf-modules/module/k8s       -> tf-modules/modules/k8s/namespaces
                                                           -> ....

                                                           -> tf-modules/modules/github/repository
environments/<some_env>/github -> tf-modules/module/github -> ....
                                                           -> ....
```

Where tf-modules is https://github.com/svetoch-dev/tf-modules


### Issues

There are several major issues with current state

1. Hard to support multiple projects. Projects at least have 2 envs (int + prd). So, for example, if we need to add a new bucket to our code the minimum amount of times we need to repeat ourselfs  is `2*n + 2(rod template)` where n - is number of projects. As you can see it will quickly become unsupportable with many projects
2. Cloud specific. Every root module in `environments/<some_env>` is cloud or service specific so it becomes very hard to operate projects in different clouds


## Desired state

One way to fix current state issues is to introduce a new intermediate module that will abstract away cloud specific implementation

```
                                                               |                           -> tf-modules/aws/s3
                                                               |-> tf-modules/modules/aws  -> tf-modules/aws/networking
                                                               |                           -> ...
                                                               |
                                                               |
                                                               |                           -> tf-modules/modules/gcp/networking
environtments/<some_env>/cloud -> tf-modules/modules/rod/cloud |-> tf-modules/modules/gcp  -> tf-modules/modules/gcp/gcs
                                                               |                           -> ....
                                                               |
                                                               |
                                                               |                           -> tf-modules/modules/yc/ycs
                                                               |-> tf-modules/modules/yc   -> tf-modules/modules/yc/networking
                                                               

```

