"""init tf posteps"""

load("@aspect_rules_py//py:defs.bzl", "py_binary")
load("@py_deps//:requirements.bzl", "requirement")
load("//:constants.bzl", "TF_ENVS_PATH")
load("//scripts/init/tf/apply:apply.bzl", "get_apply_args")

def get_clean_args():
    """Gets arguments of clean.py

    Returns:
      list of arguments that can be passed to clean.py
    """

    args = get_apply_args()
    args.append("-e")
    args.append(TF_ENVS_PATH.replace("//", "", 1))
    return args

def clean():
    """Macro for cleaning up not used states
    """
    args = get_clean_args()

    py_binary(
        name = "clean",
        srcs = ["clean.py"],
        visibility = ["//visibility:public"],
        args = args,
        deps = [
            "//libs/py/helpers",
            requirement("click"),
        ],
    )
