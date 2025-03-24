"""e2e tests posteps"""

load("@aspect_rules_py//py:defs.bzl", "py_binary")
load("@py_deps//:requirements.bzl", "requirement")
load("//scripts/init/tf/apply:apply.bzl", "get_apply_args")

def destroy():
    """Macro for destroying infra
    """
    args = get_apply_args()

    py_binary(
        name = "destroy",
        srcs = ["destroy.py"],
        args = args,
        deps = [
            "//libs/py/helpers",
            requirement("click"),
        ],
    )
