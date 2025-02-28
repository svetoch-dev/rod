"""Prepare steps for tf init"""

load("@aspect_rules_py//py:defs.bzl", "py_binary")
load("@py_deps//:requirements.bzl", "requirement")
load("@tfvars//:json.bzl", "tfvars")

def get_prepare_args():
    """Get prepare arguments from tfvars

    Needed for running rules_multirun rules

    Returns:
      py_binary arguments based on what cloud is used
    """
    cloud_name = ""
    cloud_ids = ""
    args = []

    for env_name, env_obj in tfvars["envs"].items():
        cloud_ids += "," + env_obj["cloud"]["id"]
        if env_name == "int" or env_name == "internal":
            cloud_name = env_obj["cloud"]["name"]

    if cloud_name == "gcp":
        args = [
            cloud_ids.strip(","),
            "compute.googleapis.com",
        ]

    return cloud_name, args

def prepare():
    """Preparation steps before running tf apply
    """

    cloud_name, args = get_prepare_args()

    if cloud_name == "gcp":
        py_binary(
            name = "prepare",
            srcs = ["gcp.py"],
            visibility = ["//visibility:public"],
            args = args,
            deps = [
                requirement("click"),
                requirement("google-cloud-service-usage"),
            ],
        )
