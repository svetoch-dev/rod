#!/bin/bash
set -o pipefail -o errexit -o nounset

prepare_step() {
    echo perparing env

    #Enable bazel disk cache for ci
    echo 'build --disk_cache=.cache' > .bazelrc.ci

    git config --global --add safe.directory $CI_BUILDS_DIR/$CI_PROJECT_PATH
    echo git config --global --add safe.directory $CI_BUILDS_DIR/$CI_PROJECT_PATH
    git config --global user.name 'ci'
    git config --global user.email 'ci@svetoch.dev'
    git fetch
    echo git checkout $GIT_HEAD_REF
    git checkout $GIT_HEAD_REF

    bazel run @svetoch_bazel_lib//rod/scripts/init/images/prepare
}

run_step() {
    echo running ./scripts/ci/build_targets.sh
    ./scripts/ci/build_targets.sh
    echo running ./scripts/ci/run_targets.sh
    ./scripts/ci/run_targets.sh
}

case $1 in
    prepare)
        prepare_step
        ;;
    run)
        run_step
        ;;
    *)
        echo "Unknown command" && exit 1
        ;;
esac
