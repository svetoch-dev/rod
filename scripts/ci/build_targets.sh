#!/bin/bash
set -o pipefail -o errexit -o nounset

BAZEL_MANUAL_BUILD_TARGETS="${BAZEL_MANUAL_BUILD_TARGETS:-}"
CURRENT_COMMIT_SHA="${CURRENT_COMMIT_SHA:-HEAD}"
BEFORE_COMMIT_SHA="${BEFORE_COMMIT_SHA:-HEAD^}"
[[ -z $CURRENT_COMMIT_SHA ]] && echo '$CURRENT_COMMIT_SHA env var not set.exiting' && exit 1
[[ -z $BEFORE_COMMIT_SHA ]] && echo '$BEFORE_COMMIT_SHA env var not set.exiting' && exit 1

files=$(git diff --name-only ${BEFORE_COMMIT_SHA}...${CURRENT_COMMIT_SHA})

for target_name in $BAZEL_MANUAL_BUILD_TARGETS
do
  for target_path in $(bazel query --keep_going "attr(name, '^$target_name$',rdeps(//...,set($files)))" 2> /dev/null)
  do
    bazel build $target_path
  done
done
