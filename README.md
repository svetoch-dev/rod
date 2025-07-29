# Rod
An attempt to create a scalable, cheap, secure and easy to manage infrastructure for small/medium size companies.

## State of the project
its still in a WIP(work in progress) state

### Things TBD(to be done)
* Add documentation about
  * architectrure
  * approach used for various infrastructure components
    * secrets
    * applications
    * etc
  * how to install this system
* Add a demo app
* Make a deploy script


## Prerequisites
Before doing anything please follow this steps
1. Install pre-commit `pip install pre-commit`
2. Clone this project
3. Run `pre-commit install` from the project dir

## Bazel
Some parts of this repo are managed by [bazel](https://github.com/bazelbuild/bazel)

### Getting started with bazel

* Install [bazelisk](https://github.com/bazelbuild/bazelisk) by
  * Downloading the binary
  * renaming it to `bazel`
  * Adding it to your `PATH`
* Running `bazel test //...` or running some targets like `bazel run //path/to/package:target`
