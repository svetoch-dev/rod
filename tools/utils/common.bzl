"""Common functions"""

load("//tools/utils:format.bzl", "formatted_tfvars")

def build_envs():
    """Form a dict of environment attributes needed for build/deploy scripts

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

def app_envs():
    """Form a dict representing environments where application is deployed

    Returns:
      dict of env attributes
    """

    envs = {}

    for env_name, env_obj in build_envs().items():
        if env_name != "int":
            envs[env_name] = env_obj
    return envs
