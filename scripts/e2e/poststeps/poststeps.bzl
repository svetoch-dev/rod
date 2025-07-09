"""e2e tests posteps"""

load("@aspect_rules_py//py:defs.bzl", "py_binary")
load("@svetoch_bazel_lib_py_deps//:requirements.bzl", "requirement")
load("@svetoch_bazel_lib//scripts/init/tf/apply:apply.bzl", "get_apply_args")

def destroy():
    """Macro for destroying infra
    """
    args = get_apply_args()

    py_binary(
        name = "destroy",
        srcs = ["destroy.py"],
        visibility = ["//visibility:public"],
        args = args,
        deps = [
            "@svetoch_bazel_lib//libs/py/helpers",
            requirement("click"),
        ],
    )
