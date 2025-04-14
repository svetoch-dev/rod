import click
import os
import shutil

WORKSPACE_FOLDER = os.getenv("BUILD_WORKSPACE_DIRECTORY")


@click.command()
@click.argument("cloud", required=True, type=click.STRING)
def tfvars(cloud):
    """Prepare tfvars for e2e test

    Args:
        cloud(str): what cloud will be used for e2e tests
    """
    os.chdir(WORKSPACE_FOLDER)

    shutil.copy(
        f"scripts/e2e/prepare/terraform.tfvars.json.{cloud}",
        "terraform/terraform.tfvars.json",
    )


if __name__ == "__main__":
    tfvars()
