"""e2e tests prepare steps"""

load("@aspect_rules_py//py:defs.bzl", "py_binary")
load("@py_deps//:requirements.bzl", "requirement")
load("//:constants.bzl", "TF_ENVS_PATH")
load("//tools/utils:format.bzl", "formatted_tfvars")

def _env_secrets(env_obj):
    """Get secrets for an env

    Args:
      env_obj: environment obj (based on tfvars)

    Returns:
      list of tuples. Tuple (str, str, str)
      1. first element is secret state
      2. second element is secret name
      3. third element is comma separated secret keys
    """
    secrets = []
    env_name = env_obj["name"]
    secret_state = "{tf_envs_path}/{env_name}/secrets".format(
        tf_envs_path = TF_ENVS_PATH,
        env_name = env_name,
    )

    for secret_name, secret_obj in env_obj["import_secrets"].items():
        secrets.append(
            (secret_state, secret_name, ",".join(secret_obj["secrets_to_import"])),
        )

    return secrets

def get_secrets_args():
    """Get secrets import arguments from tfvars

    Returns:
      list of string arguments passed to secrets.py
    """
    tf_vars = formatted_tfvars()

    secrets = []
    args = []

    for _, env_obj in tf_vars["envs"].items():
        secrets += _env_secrets(env_obj)

    for secret_state, secret_name, secret_keys in secrets:
        args.append("-s")
        args.append(secret_state)
        args.append(secret_name)
        args.append(secret_keys)

    return args

def secrets():
    """Macro for setting secrets
    """

    args = get_secrets_args()
    py_binary(
        name = "secrets",
        srcs = ["secrets.py"],
        visibility = ["//visibility:public"],
        args = args,
        deps = [
            "//libs/py/helpers",
            requirement("click"),
        ],
    )
