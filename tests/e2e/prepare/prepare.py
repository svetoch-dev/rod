from pathlib import Path
from libs.py.tf.tfvars import tfvars
from libs.py.settings import bazel_settings


def prepare():
    tf_vars = tfvars()
    tf_vars.repo.name = "rod-e2e"
    envs = tf_vars.envs
    envs["production"] = envs.pop("template")

    for env_name, env_obj in tf_vars.envs.items():
        env_obj.cloud.buckets.deletion_protection = False
        env_obj.kubernetes.deletion_protection = False
        env_obj.initial_start = True
        # bazel does not support null in json
        if not env_obj.cloud.folder_id:
            env_obj.cloud.folder_id = ""

        if env_obj.short_name == "tpl":
            env_obj.short_name = "prd"
            env_obj.name = "production"


    Path(bazel_settings.tfvars_file).write_text(
        tf_vars.model_dump_json(indent=2),
        encoding="utf-8",
    )


if __name__ == "__main__":
    prepare()
