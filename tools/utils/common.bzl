"""Common functions"""

load("//tools/utils:format.bzl", "formatted_tfvars")

def build_envs():
    """Form a dict of env vars needed for build/deploy scripts

    Returns:
      a dict of env attributes that are picked from tfvars
    """
    envs = {}
    tf_vars = formatted_tfvars()
    for _, env_obj in tf_vars["envs"].items():
        envs[env_obj["short_name"]] = {
            "registry": env_obj["cloud"]["registry"],
            "id": env_obj["cloud"]["id"],
            "region": env_obj["cloud"]["region"],
        }

    return envs
