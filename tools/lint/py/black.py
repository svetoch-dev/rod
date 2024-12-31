import os
import sys

import black

if __name__ == "__main__":
    bazel_top_root = os.environ.get("BUILD_WORKSPACE_DIRECTORY")

    if bazel_top_root:
        os.chdir(bazel_top_root)

    black.patched_main()
