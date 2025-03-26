import subprocess
import os
from libs.py.helpers import run_command

WORKSPACE_FOLDER = os.getenv("BUILD_WORKSPACE_DIRECTORY")


def process_results(result):
    if result.returncode == 0:
        return result.stdout
    else:
        error = f"Bazel query failed with return code: {result.returncode}\n"
        error += "Error:\n"
        error += result.stderr

        raise BaseException(error)


def build_images():
    """
    Build and push custom images to container registries

    This is done
    1. by executing bazel command and query all targets starting with `push_` in all subpackages of deps/images
    2. executing all those target via `bazel run`
    """
    os.chdir(WORKSPACE_FOLDER)
    query = ["bazel", "query", 'attr(name, "^push_.*$", "//deps/images/...")']
    result = subprocess.run(query, capture_output=True, text=True)
    output = process_results(result)
    output = output.strip("\n")
    for target in output.split("\n"):
        command = ["bazel", "run", target]
        run_command(command)


if __name__ == "__main__":
    build_images()
