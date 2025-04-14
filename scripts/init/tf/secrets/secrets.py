import click
import os
import re
from libs.py.helpers import run_command, unmask_tf

WORKSPACE_FOLDER = os.getenv("BUILD_WORKSPACE_DIRECTORY")


@click.command()
@click.option("--secrets", "-s", required=True, type=(str, str, str), multiple=True)
def secrets(secrets):
    """
    1. Unmasks import secrets in secret state
    2. Import secrets from env var or from input
    3. apply

    Args:
        secrets(set(tuple(str, str, str))): list of secret tuples:
           1. first element is secret state
           2. second element is secret name
           3. third element is comma separated secret keys
    """
    secret_states = []
    for secret_state, secret_name, secret_keys in secrets:
        state_path = f"{WORKSPACE_FOLDER}{secret_state}"
        unmask_tf(state_path)
        os.chdir(state_path)
        if state_path not in secret_states:
            secret_states.append(state_path)

        state_list_command = ["bazel", "run", ":tf", "state", "list"]
        exit_code, tf_resources = run_command(state_list_command, print_stdout=False)

        for secret_key in secret_keys.split(","):
            tf_resource = f'module.secrets["{secret_name}"].module.import_secret["{secret_key}"].secret_resource.secret'
            import_command = ["bazel", "run", ":tf", "import", tf_resource]
            if tf_resource not in tf_resources:
                env_secret_name = secret_name.replace("-", "__")
                env_secret_key = secret_key.replace("-", "__")
                env_var_name = (
                    f"TF_IMPORT_SECRET_{env_secret_name}_{env_secret_key}".upper()
                )
                try:
                    secret_value = os.environ[env_var_name]
                    import_command.append(secret_value)
                    run_command(import_command)
                except KeyError as e:
                    print(f"{env_var_name} is not set using prompt")
                    secret_value = input(f"Enter secret for {tf_resource}: ")
                    import_command.append(secret_value)
                    run_command(import_command)

    for secret_state in secret_states:
        os.chdir(secret_state)
        command = ["bazel", "run", ":apply"]
        run_command(command)


if __name__ == "__main__":
    secrets()
