import os
import sys
from rod.libs.py.helpers import run_command, switch_index
from rod.libs.py.tf.tfvars import tfvars, env_key
from rod.libs.py.settings import bazel_settings
from rod.libs.py.tf.apply import apply_env_targets
from rod.libs.py.yc.registry import YcRegistry


def destroy():
    os.chdir(bazel_settings.workspace)
    tf_vars = tfvars()
    envs = []
    int_env = None

    for env_name, env_obj in tf_vars.envs.items():
        #Yandex cloud registry does not support (at all)
        #deleting registry if it is not empty so
        #before destroying we need to remove all images first
        if env_obj.cloud.name == "yc":
            registry_id = env_obj.registry.url.strip("/").split("/")[-1]
            registry = YcRegistry(env_obj.cloud.folder_id, registry_id=registry_id)
            registry.purge_images()

        if env_obj.type == "internal":
            int_env = env_obj.model_copy(deep=True)

        envs.append(env_obj)

    # Destroy int secrets first
    command = [
        "bazel",
        "run",
        f"//{bazel_settings.tf_env_dir}/{int_env.name}/secrets:tf",
        "--",
        "destroy",
        "-auto-approve",
    ]
    run_command(command)
    # Destroy int env last
    switch_index(envs, int_env, len(envs) - 1)

    for env_obj in envs:
        env_name = env_key(env_obj, tf_vars)
        if env_obj.type == "internal":
            apply_targets = apply_env_targets(
                env_name,
                exclude_targets=[
                    f"//{bazel_settings.tf_env_dir}/{env_name}/secrets:apply"
                ],
            )
        else:
            apply_targets = apply_env_targets(env_name)
        # We must destroy states in reverse
        # to how they were applied
        for target in apply_targets[::-1]:
            target = target.replace(":apply", ":tf")
            target = target.replace(":mapply", ":tf")
            command = ["bazel", "run", target, "--", "destroy", "-auto-approve"]
            run_command(command)


if __name__ == "__main__":
    destroy()
