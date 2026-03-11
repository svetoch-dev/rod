import os
from libs.py.helpers import run_command, switch_index
from libs.py.tf.tfvars import tfvars
from libs.py.settings import bazel_settings
from scripts.init.tf.apply.env import apply_env_targets

def destroy():
    os.chdir(bazel_settings.workspace)
    tf_vars = tfvars()
    envs = []
    int_env = None

    for env_name, env_obj in tf_vars.envs.items():
        if env_obj.short_name == "int":
            int_env = env_obj.model_copy(deep=True)

        envs.append(env_obj)

    #Destroy int env last
    switch_index(envs, int_env, len(envs) - 1 )

    for env_obj in envs:
        apply_targets = apply_env_targets(env_obj.name)
        # We must destroy states in reverse
        # to how they were applied
        for target in apply_targets[::-1]:
            target = target.replace(":apply", ":tf")
            target = target.replace(":rapply", ":tf")
            command = ["bazel", "run", target, "--", "destroy", "-auto-approve"]
            run_command(command)


if __name__ == "__main__":
    destroy()
