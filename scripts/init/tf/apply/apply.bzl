"""Apply tf"""
load("//tools/utils:format.bzl", "formatted_tfvars")
load("@rules_multirun//:defs.bzl", "command", "multirun")

def _env_apply_targets(env_obj):
    """Get targets of env based on cloud type

    Args:
      env_obj: environment obj (based on tfvars)

    Returns:
      list of apply targets
    """
    targets = []
    env_name = env_obj["name"]
    env_cloud_type = env_obj["cloud"]["name"]
    state_prefix = "//terraform/environments/{env_name}/".format(
        env_name = env_name,
    )

    if env_cloud_type == "gcp":
        targets.append(state_prefix + "gcp:apply")
        targets.append(state_prefix + "gke:apply")

    return targets


def _apply_targets():
    """figure out what states should be applied

    Returns:
      list of apply targets
    """
    tf_vars = formatted_tfvars()
    env_int = None
    targets = []

    #The apply priority is
    #1. Ci
    #2. int env
    #3. other envs
    for env_name, env_obj in tf_vars["envs"].items():
        if env_name == "internal" or env_name == "int":
            env_int = env_obj
            break

    targets.append("//terraform/environments/{env_name}/{ci_name}:gh_apply".format(
        env_name = env_int["name"],
        ci_name  = tf_vars["ci"]["type"]
    ))

    targets += _env_apply_targets(env_int)

    for env_name, env_obj in tf_vars["envs"].items():
        if not (env_name == "internal" or env_name == "int"):
            targets += _env_apply_targets(env_obj)

    return targets

def apply_tf():
    """Macro for applying tf state
    """
    commands = []

    for target in _apply_targets():
        #<state>:apply
        state    = target.split("/")[-1]
        #<state>
        state    = state.split(":")[0]

        env_name = target.split("/")[-2]

        command_name = env_name + "_" + state

        command(
            name = command_name ,
            command = target,
        )

        commands.append(command_name)
    multirun(
        name = "apply",
        commands = commands
    )

