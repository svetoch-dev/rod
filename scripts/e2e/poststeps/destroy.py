import click
import subprocess
import os
from libs.py.helpers import run_command

WORKSPACE_FOLDER = os.getenv("BUILD_WORKSPACE_DIRECTORY")


@click.command()
@click.argument("targets", required=True, type=click.STRING)
def destroy(targets):
    """Destroys targets passed in order

    Args:
        targets(str): comma separated list of tf_apply targets
    """
    os.chdir(WORKSPACE_FOLDER)
    targets = targets.split(",")
    targets = targets[::-1]
    for target in targets:
        target = target.replace(":apply", ":tf")
        target = target.replace(":gh_apply", ":tf")
        command = ["bazel", "run", target, "destroy"]
        run_command(command)


if __name__ == "__main__":
    destroy()
