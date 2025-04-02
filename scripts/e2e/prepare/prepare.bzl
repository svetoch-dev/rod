"""e2e tests prepare steps"""

load("@aspect_rules_py//py:defs.bzl", "py_binary")
load("@py_deps//:requirements.bzl", "requirement")
load("//tools/utils:format.bzl", "formatted_tfvars")
load("//:constants.bzl", "TF_ENVS_PATH")

def get_e2e_prepare_args():
    """Get e2e prepare arguments from tfvars

    Returns:
      list(str): list with single element - comma separated list of cloud state paths
    """
    tf_vars = formatted_tfvars()

    args = []

    for env_name, env_obj in tf_vars["envs"].items():
        state_prefix = "{tf_envs_path}/{env_name}/{cloud_type}".format(
            tf_envs_path = TF_ENVS_PATH,
            env_name = env_name,
            cloud_type = env_obj["cloud"]["name"]
        )

        args.append(state_prefix)

    return [",".join(args)]


def prepare():
    """Macro for preparing infra
    """

    args = get_e2e_prepare_args()
    py_binary(
        name = "prepare",
        srcs = ["prepare.py"],
        visibility = ["//visibility:public"],
        args = args,
        deps = [
            "//libs/py/helpers",
            requirement("click"),
        ],
    )
