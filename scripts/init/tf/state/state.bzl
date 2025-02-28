"""Create tf state"""

load("@aspect_rules_py//py:defs.bzl", "py_binary")
load("@py_deps//:requirements.bzl", "requirement")
load("//tools/utils:format.bzl", "formatted_tfvars")

def get_create_state_args():
    """Get create_tf_state arguments from tfvars

    Needed for running rules_multirun rules

    Returns:
      py_binary arguments based on what cloud is used
    """
    tf_vars = formatted_tfvars()

    int_env = None
    cloud_name = ""
    args = []

    for env_name, env_obj in tf_vars["envs"].items():
        if env_name == "int" or env_name == "internal":
            cloud_name = env_obj["cloud"]["name"]
            int_env = env_obj

    if cloud_name == "gcp":
        args = [
            int_env["cloud"]["id"],
            int_env["tf_backend"]["configs"]["bucket"],
            int_env["cloud"]["multi_region"],
        ]

    return cloud_name, args

def create_state():
    """initialize tf state
    """
    cloud_name, args = get_create_state_args()
    if cloud_name == "gcp":
        py_binary(
            name = "create",
            srcs = ["gcp.py"],
            visibility = ["//visibility:public"],
            args = args,
            deps = [
                requirement("click"),
                requirement("google-cloud-storage"),
            ],
        )
