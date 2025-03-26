import click
import subprocess
import os
from libs.py.helpers import run_command

WORKSPACE_FOLDER = os.getenv("BUILD_WORKSPACE_DIRECTORY")


@click.command()
@click.option("--apply_targets", "-t", required=True, type=(str, bool), multiple=True)
def destroy(apply_targets):
    """Destroys targets passed in order

    Args:
        apply_targets(set(tuple(str, bool))): list of target touples that are applied:
            1. first element target
            2. second element descibes the need for umasking tf code
    """
    os.chdir(WORKSPACE_FOLDER)
    # We must destroy states in reverse
    # to how they were applied
    for target, is_masked in apply_targets[::-1]:
        target = target.replace(":apply", ":tf")
        target = target.replace(":gh_apply", ":tf")
        command = ["bazel", "run", target, "--", "destroy", "-auto-approve"]
        run_command(command)


if __name__ == "__main__":
    destroy()
