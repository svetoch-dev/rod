#!/bin/bash
set -o pipefail -o nounset

BAZEL_MANUAL_BUILD_TARGETS="${BAZEL_MANUAL_BUILD_TARGETS:-}"
CURRENT_COMMIT_SHA="${CURRENT_COMMIT_SHA:-HEAD}"
BEFORE_COMMIT_SHA="${BEFORE_COMMIT_SHA:-HEAD^}"
[[ -z $CURRENT_COMMIT_SHA ]] && echo '$CURRENT_COMMIT_SHA env var not set.exiting' && exit 1
[[ -z $BEFORE_COMMIT_SHA ]] && echo '$BEFORE_COMMIT_SHA env var not set.exiting' && exit 1

files=$(git diff --name-only ${BEFORE_COMMIT_SHA}...${CURRENT_COMMIT_SHA})
EXIT_STATUS=0
for target_name in $BAZEL_MANUAL_BUILD_TARGETS
do
  for target_path in $(bazel query --keep_going "attr(name, '^$target_name$',rdeps(//...,set($files)))" 2> /dev/null)
  do
    bazel build $target_path
    if [[ $? -ne 0 ]]
    then
      EXIT_STATUS=1
    fi
  done
done

exit $EXIT_STATUS
