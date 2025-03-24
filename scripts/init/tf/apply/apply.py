import click
import subprocess
import os
from libs.py.helpers import run_command

WORKSPACE_FOLDER = os.getenv("BUILD_WORKSPACE_DIRECTORY")


@click.command()
@click.argument("targets", required=True, type=click.STRING)
def apply(targets):
    """Applyies all apply targets passed in order

    Args:
        targets(str): comma separated list of tf_apply targets
    """
    os.chdir(WORKSPACE_FOLDER)
    targets = targets.split(",")
    for target in targets:
        command = ["bazel", "run", target]
        run_command(command)


if __name__ == "__main__":
    apply()
