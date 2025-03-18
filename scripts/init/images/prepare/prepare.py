import click
import os
import json
from scripts.init.images.prepare.config import DOCKER_CONFIG_FILE


@click.command()
@click.argument("registries", required=True, type=click.STRING)
@click.argument("creds_helper_name", required=True, type=click.STRING)
def image_prepare(registries, creds_helper_name):
    """
    1. creates a credHelpers section in ~/.docker/config.json based on registries

    Args:
        registries(str): comma separated list of container registries
        creds_helper_name(str): credential helper name (eg gar, gcloud etc)
    """
    configs = {"auths": {}, "credHelpers": {}}
    try:
        with open(DOCKER_CONFIG_FILE, "r") as f:
            configs = json.load(f)
    except json.JSONDecodeError:
        print(
            f"Error: The file '{DOCKER_CONFIG_FILE}' contains invalid JSON. Or is empty"
        )
        print("Using default configs")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")

    registries = registries.split(",")
    for registry in registries:
        registry = registry.split("/")[0]
        configs["credHelpers"][registry] = creds_helper_name

    with open(DOCKER_CONFIG_FILE, "w") as f:
        json.dump(configs, f, indent=4)


if __name__ == "__main__":
    image_prepare()
