"""Tf macros"""

load("@aspect_bazel_lib//lib:expand_template.bzl", "expand_template")
load(
    "@rules_tf//tf:defs.bzl",
    "tf_apply",
    "tf_binary",
    "tf_fmt",
    "tf_fmt_test",
    "tf_init",
    "tf_plan",
    "tf_validate_test",
)
load("//tools/rules:json_gen.bzl", "json_gen")
load("//tools/utils:format.bzl", "formatted_tfvars")

def tf(
        name = None,
        plan_target = "plan",
        apply_target = "apply",
        env_name = None,
        state_name = None):
    """Creates common tf targets

    Args:
        name: unused arg to stick with conventions
        plan_target: plan target name
        apply_target: apply target name
        env_name: name of the environment that state relates too
            by default environment folder name for example if target is
            `//terraform/environments/internal/secrets` env name is `internal`
        state_name: name of state eg gcp,aws,cloud,secrets etc. Example:
            `//terraform/environments/internal/k8s` state name is `k8s`
    """
    if not env_name:
        env_name = native.package_name().split("/")[-2]

    if not state_name:
        state_name = native.package_name().split("/")[-1]

    tf_vars = formatted_tfvars(state_name)
    tf_env = tf_vars["envs"][env_name]
    tf_backend = tf_env["tf_backend"]

    expand_template(
        name = "main_tf",
        substitutions = {
            "{tf_backend.type}": tf_backend["type"],
        },
        template = ":main.tf.tpl",
        out = "main.tf",
    )

    json_gen(
        name = "terraform_tfvars_json",
        json_content = str(tf_vars),
        out = "terraform.tfvars.json",
    )

    expand_template(
        name = "tf_variables_tf",
        substitutions = {
            "{env.name}": tf_env["name"],
        },
        template = ":tf_variables.tf.tpl",
        out = "tf_variables.tf",
    )

    native.filegroup(
        name = "srcs",
        srcs = native.glob(
            [
                "*.tf",
            ],
        ) + [
            ":main_tf",
            ":tf_variables_tf",
            ":terraform_tfvars_json",
        ],
        visibility = ["//visibility:__pkg__"],
    )

    native.filegroup(
        name = "srcs_lint",
        srcs = native.glob(
            [
                "*.tf",
            ],
        ),
    )

    tf_validate_test(
        name = "validate",
        srcs = [":srcs"],
        init = ":init_for_tests",
    )

    tf_fmt_test(
        name = "fmt",
        srcs = [":srcs_lint"],
    )

    tf_init(
        name = "init",
        srcs = [
            ":main_tf",
            ":terraform_tfvars_json",
        ],
        tags = ["manual"],
        backend_configs = tf_backend["configs"],
    )

    tf_init(
        name = "init_for_tests",
        srcs = [
            ":main_tf",
            ":terraform_tfvars_json",
        ],
        backend = False,
    )

    tf_plan(
        name = plan_target,
        srcs = [":srcs"],
        init = ":init",
        parallelism = "100",
        tags = ["manual"],
    )

    tf_apply(
        name = apply_target,
        srcs = [":srcs"],
        init = ":init",
        plan = plan_target,
        tags = ["manual"],
        visibility = ["//visibility:public"],
    )

    tf_binary(
        name = "tf",
        srcs = [":srcs"],
        init = ":init",
        tags = ["manual"],
    )

    tf_fmt(
        name = "fmt_fix",
        srcs = [
            ":srcs_lint",
        ],
        fix = True,
        tags = ["manual"],
    )
