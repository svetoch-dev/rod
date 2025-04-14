import click
import glob
import os
import shutil

WORKSPACE_FOLDER = os.getenv("BUILD_WORKSPACE_DIRECTORY")


@click.command()
@click.option("--apply_targets", "-t", required=True, type=(str, bool), multiple=True)
@click.option("--tf_env_folder", "-e", required=True, type=str)
def clean(apply_targets, tf_env_folder):
    """Clean up all none apply tf state folders

    Args:
        apply_targets(set(tuple(str, bool))): list of target tuples that are applied:
            1. first element target
            2. second element descibes the need for umasking tf code
    """
    os.chdir(WORKSPACE_FOLDER)
    applied_states = []
    # Get only folders of states
    for target, is_masked in apply_targets:
        # replace bazel target stuff and add / at
        # the end in order to match folders
        # from glob output
        state = target.replace(":apply", "/")
        state = state.replace(":gh_apply", "/")
        state = state.lstrip("//")
        applied_states.append(state)

    # Use glob to get only folders by appending `*/`
    # to the end of glob string. The returned folders
    # look like `terraform/environments/internal/secrets/`
    # note the forward slash at the end
    tf_states = glob.glob(f"{tf_env_folder}/*/*/")
    for state in tf_states:
        if state not in applied_states:
            print(f"Removing unused state: {state}")
            shutil.rmtree(state)


if __name__ == "__main__":
    clean()
