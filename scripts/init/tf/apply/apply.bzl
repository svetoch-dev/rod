"""Apply tf"""

load("@aspect_rules_py//py:defs.bzl", "py_binary")
load("@py_deps//:requirements.bzl", "requirement")
load("//tools/utils:format.bzl", "formatted_tfvars")
load("//:constants.bzl", "TF_ENVS_PATH")

def _env_apply_targets(env_obj):
    """Get targets of env based on cloud type

    Args:
      env_obj: environment obj (based on tfvars)

    Returns:
      list of touples. Touple (String, Boolean)
      1. first element is apply target
      2. second element determines if the tf code is masked
    """
    targets = []
    env_name = env_obj["name"]
    env_cloud_type = env_obj["cloud"]["name"]
    state_prefix = "{tf_envs_path}/{env_name}/".format(
        tf_envs_path = TF_ENVS_PATH,
        env_name = env_name,
    )

    if env_cloud_type == "gcp":
        targets.append(
            (state_prefix + "gcp:apply", True)
        )
        targets.append(
            (state_prefix + "gke:apply", False)
        )

    if env_name != "int" and env_name != "internal":
        targets.append(
            (state_prefix + "secrets:apply", False)
        )

    return targets

def get_apply_args():
    """figure out what states should be applied

    Returns:
      list of string arguments passed to apply.py
    """
    tf_vars = formatted_tfvars()
    env_int = None
    targets = []
    args = []

    #The apply priority is
    #1. Ci
    #2. int env (except secrets)
    #3. other envs
    #4. int secrets
    for env_name, env_obj in tf_vars["envs"].items():
        if env_name == "internal" or env_name == "int":
            env_int = env_obj
            break

    targets.append(
        (
            "{tf_envs_path}/{env_name}/{ci_name}:gh_apply".format(
                tf_envs_path = TF_ENVS_PATH,
                env_name = env_int["name"],
                ci_name = tf_vars["ci"]["type"],
            ),
            False
        )
    )

    targets += _env_apply_targets(env_int)

    for env_name, env_obj in tf_vars["envs"].items():
        if not (env_name == "internal" or env_name == "int"):
            targets += _env_apply_targets(env_obj)

    targets.append(
        (
            "{tf_envs_path}/{env_name}/secrets:apply".format(
                tf_envs_path = TF_ENVS_PATH,
                env_name = env_int["name"],
            ),
            False
        )
    )

    for target, is_masked in targets:
        args.append("-t")
        args.append(target)
        args.append(str(is_masked))

    return args

def apply():
    """Macro for applying tf state
    """
    args = get_apply_args()

    py_binary(
        name = "init",
        srcs = ["apply.py"],
        visibility = ["//visibility:public"],
        args = args,
        deps = [
            "//libs/py/helpers",
            requirement("click"),
        ],
    )
