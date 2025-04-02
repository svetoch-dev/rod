import click
import subprocess
import os
import time
import shutil
from libs.py.helpers import unmask_tf

EPOCH_HOURS = int(time.time() / 3600)

WORKSPACE_FOLDER = os.getenv("BUILD_WORKSPACE_DIRECTORY")


@click.command()
@click.argument("apply_states", required=True, type=click.STRING)
def prepare(apply_states):
    """Prepare code for e2e test

    Args:
        apply_states(str): comma separated list of tf states
    """
    os.chdir(WORKSPACE_FOLDER)

    for state in apply_states.split(","):
        cloud = state.split("/")[-1]
        state = state.lstrip("//")
        shutil.copy(
            f"scripts/e2e/prepare/terraform.tfvars.json.{cloud}",
            "terraform/terraform.tfvars.json",
        )
        # In e2e tests we need to add some string to all
        # custom roles because custom roles in gcp are not
        # delete during 30 days
        if cloud == "gcp":
            unmask_tf(
                state,
                "k8sNodeServiceAccount[0-9]*",
                f"k8sNodeServiceAccount{EPOCH_HOURS}",
            )
            unmask_tf(state, "bucketList[0-9]*", f"bucketList{EPOCH_HOURS}")


if __name__ == "__main__":
    prepare()
