import click
from rod.libs.py.tf.tfvars import (
    tfvars,
    TfVars,
    Location,
    update_tfvars,
)
from rod.libs.py.settings import bazel_settings
from rod.scripts.init.prepare import prepare_tfvars


def prepare_gcp(tfvars: TfVars):
    location = {
        "region": "europe-west2",
        "default_zone": "europe-west2-c",
        "multi_region": "EU",
    }
    for env_name, env_obj in tfvars.envs.items():
        env_obj.cloud.location = Location(**location)
        env_obj.test = True
        env_obj.cloud.folder_id = ""
        env_obj.kubernetes.node_locations = ["europe-west2-a"]
        if env_obj.type == "product":
            env_obj.cloud.id = "rod-production"
        if env_obj.type == "internal":
            env_obj.cloud.id = "rod-internal"


def prepare_yc(tfvars: TfVars):
    for env_name, env_obj in tfvars.envs.items():
        if env_obj.type == "product":
            env_obj.cloud.id = "b1grv6akrivi20i4ahdj"
            env_obj.cloud.folder_id = "b1gj0no4panln7k2nk0a"
        if env_obj.type == "internal":
            env_obj.cloud.id = "b1grv6akrivi20i4ahdj"
            env_obj.cloud.folder_id = "b1gfu8oas3od212hedtu"


@click.command()
@click.argument(
    "cloud", required=False, default="gcp", type=click.Choice(["gcp", "yc"])
)
def prepare(cloud: str):
    prepare_tfvars(cloud, {"prd": "production"})
    tf_vars = tfvars()
    tf_vars.repo.name = "rod-e2e"
    tf_vars.repo.group = "svetoch-dev"
    tf_vars.company.name = "rod"
    tf_vars.company.domain = "rod.svetoch.dev"

    envs = tf_vars.envs

    for env_name, env_obj in tf_vars.envs.items():
        env_obj.cloud.buckets.deletion_protection = False
        env_obj.kubernetes.deletion_protection = False

    if cloud == "gcp":
        prepare_gcp(tf_vars)
    elif cloud == "yc":
        prepare_yc(tf_vars)

    update_tfvars(tf_vars)


if __name__ == "__main__":
    prepare()
