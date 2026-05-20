import sys
import click
from pathlib import Path
from rod.libs.py.tf.tfvars import (
    tfvars,
    TfVars,
    TfBackend,
    Dns,
    Registry,
    Location,
)
from rod.libs.py.settings import bazel_settings


def prepare_gcp(tfvars: TfVars):
    envs = tfvars.envs
    tf_backend = {
        "type": "gcs",
        "configs": {
            "bucket": "{company.name}-tf-state",
            "prefix": "{env.name}/{tf_backend.state_name}",
        },
    }
    registry = {
        "type": "gar",
        "url": "{env.cloud.location.region}-docker.pkg.dev/{env.cloud.id}/containers",
    }
    dns = {"domain": "{env.short_name}.{company.domain}.", "type": "gcp"}
    location = {
        "region": "europe-west2",
        "default_zone": "europe-west2-c",
        "multi_region": "EU",
    }
    for env_name, env_obj in tfvars.envs.items():
        pod_cidr = env_obj.cloud.network.k8s_pod_cidr
        env_obj.cloud.network.k8s_pod_cidr = pod_cidr.replace("/16", "/14")
        env_obj.cloud.name = "gcp"
        env_obj.tf_backend = TfBackend(**tf_backend)
        env_obj.registry = Registry(**registry)
        env_obj.dns = Dns(**dns)
        env_obj.cloud.location = Location(**location)
        env_obj.cloud.folder_id = ""
        env_obj.kubernetes.node_locations = ["europe-west2-a"]
        if env_obj.type == "product":
            env_obj.cloud.id = "rod-production"
        if env_obj.type == "internal":
            env_obj.cloud.id = "rod-internal"


def prepare_yc(tfvars: TfVars):
    envs = tfvars.envs
    tf_backend = {
        "type": "s3",
        "configs": {
            "bucket": "{company.name}-tf-state",
            "use_lockfile": "true",
            "region": "{env.cloud.location.region}",
            "key": "{env.name}/{tf_backend.state_name}/default.tfstate",
            "skip_region_validation": "true",
            "skip_credentials_validation": "true",
            "skip_requesting_account_id": "true",
            "skip_s3_checksum": "true",
        },
    }
    registry = {"type": "ycr", "url": ""}
    dns = {"domain": "{env.short_name}.{company.domain}.", "type": "yc"}
    location = {
        "region": "ru-central1",
        "default_zone": "ru-central1-a",
        "multi_region": "",
    }
    for env_name, env_obj in tfvars.envs.items():
        pod_cidr = env_obj.cloud.network.k8s_pod_cidr
        env_obj.cloud.network.k8s_pod_cidr = pod_cidr.replace("/14", "/16")
        env_obj.cloud.name = "yc"
        env_obj.tf_backend = TfBackend(**tf_backend)
        env_obj.registry = Registry(**registry)
        env_obj.dns = Dns(**dns)
        env_obj.cloud.location = Location(**location)
        env_obj.kubernetes.node_locations = ["ru-central1-d"]
        if env_obj.type == "product":
            env_obj.cloud.id = "b1grv6akrivi20i4ahdj"
            env_obj.kubernetes.regional = False
            env_obj.cloud.folder_id = "b1gj0no4panln7k2nk0a"
        if env_obj.type == "internal":
            env_obj.cloud.id = "b1grv6akrivi20i4ahdj"
            env_obj.cloud.folder_id = "b1gfu8oas3od212hedtu"


@click.command()
@click.argument(
    "cloud", required=False, default="gcp", type=click.Choice(["gcp", "yc"])
)
def prepare(cloud: str):
    tf_vars = tfvars()
    tf_vars.repo.name = "rod-e2e"
    envs = tf_vars.envs

    if "product" in envs.keys():
        envs["production"] = envs.pop("product")
        envs["production"].short_name = "prd"
        envs["production"].name = "production"

    for env_name, env_obj in tf_vars.envs.items():
        for app_name, app_obj in env_obj.apps.items():
            app_obj.repo = None
            app_obj.cd = None
        env_obj.cloud.buckets.deletion_protection = False
        env_obj.kubernetes.deletion_protection = False
        env_obj.initial_start = True

    if cloud == "gcp":
        prepare_gcp(tf_vars)
    elif cloud == "yc":
        prepare_yc(tf_vars)

    Path(bazel_settings.tfvars_file).write_text(
        tf_vars.model_dump_json(indent=2),
        encoding="utf-8",
    )


if __name__ == "__main__":
    prepare()
