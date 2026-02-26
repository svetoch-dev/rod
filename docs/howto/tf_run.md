# Running with bazel
To run terraform commands you **need** to use `bazel`

## run tests
To run all terraform tests (`fmt`,`validate`) you can execute

```
bazel test //...
```

## plan/apply

To run `plan/apply` in certain `root_module` you need to `cd terraform/environments/<env>/<root_module>/` and then execute `bazel build :plan` or `bazel run :apply`. Example:

```
$ cd terraform/environments/gcp
$ bazel build plan
$ bazel run apply
```

*NOTE*: Be carefull when running `bazel run apply` it runs with `-auto-approve`

To run all plan/apply you can execute

```
$ bazel build $(bazel query 'attr(name, "^plan$", "//...")')
$ bazel query 'attr(name, "^apply$", "//...")' | xargs -I{} bazel run {}
```

## run various terraform commands
There is a possibility to run various tf commands via `bazel run :tf -- <command> <command args>`.

Examples:
* `bazel run :tf -- import 'module.secrets["some-service"].module.import_secret["some-secret"].secret_resource.secret' 'SuperSecret'`
* `bazel run :tf -- force-unlock -force 1730215139325387`
* `bazel run :tf -- plan -parallelism=100`
