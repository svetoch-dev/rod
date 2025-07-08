#!/bin/bash
set -o pipefail -o errexit -o nounset
DOCKER_CRED_VERSION=2.1.25
DOCKER_CRED_OS=linux
DOCKER_CRED_ARCH=amd64
DOCKER_CRED_URL="https://github.com/GoogleCloudPlatform/docker-credential-gcr/releases/download/v${DOCKER_CRED_VERSION}/docker-credential-gcr_${DOCKER_CRED_OS}_${DOCKER_CRED_ARCH}-${DOCKER_CRED_VERSION}.tar.gz"
#Used for docker-credential-gcr
export PATH=$PATH:$HOME/tools/


prepare_step() {
    echo perparing env

    #Enable bazel disk cache for ci
    echo 'build --disk_cache=.cache' > .bazelrc-ci

    git config --global --add safe.directory $CI_BUILDS_DIR/$CI_PROJECT_PATH
    echo git config --global --add safe.directory $CI_BUILDS_DIR/$CI_PROJECT_PATH
    git config --global user.name 'github_actions'
    git config --global user.email 'github_actions@users.noreply.github.com'
    git fetch
    echo git checkout $GIT_HEAD_REF
    git checkout $GIT_HEAD_REF

    #Download gcp docker cred helper
    #and configure creds for container
    curl -fsSL $DOCKER_CRED_URL | tar xz docker-credential-gcr && chmod +x docker-credential-gcr 
    mkdir ~/tools/ && mv ./docker-credential-gcr ~/tools/ 

    bazel run @svetoch_bazel_lib//scripts/init/images/prepare
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
