import click
import subprocess
import os
import re
import glob
from dataclasses import dataclass
from libs.py.helpers import run_command

WORKSPACE_FOLDER = os.getenv("BUILD_WORKSPACE_DIRECTORY")
MASK_STR = "##MASKED##"
UNMASK_STR = ""

for char in MASK_STR:
    UNMASK_STR += " "

@dataclass
class Target:
    name: str
    is_masked: bool

    @property
    def path(self):
        path = self.package.lstrip("//")
        return path

    @property
    def package(self):
        package = re.sub(":.*$", "", self.name)
        return package


def unmask_tf(folder, mask_str, unmask_str):
    """
    Remove mask string from tf files of a bazel target

    Args:
        folder(str): folder with .tf files
        mask_str(str): string that should be unmasked
        unmask_str(str): unmasked str
    """
    tf_files = glob.glob(f"{folder}/*.tf")
    for file in tf_files:
        with open(file, "r") as f:
            content = f.read()

        content = content.replace(mask_str, unmask_str)

        with open(file, "w") as f:
            f.write(content)


@click.command()
@click.option("--targets", "-t", required=True, type=(str, bool), multiple=True)
def apply(targets):
    """
    1. Applies all apply targets passed in order

    2. Unmasks all masked tf code and applies related targets

    Args:
        targets(set(tuple(str, bool))): list of target touples:
            1. first element target
            2. second element descibes the need for umasking tf code
    """
    os.chdir(WORKSPACE_FOLDER)
    target_objs = []
    for target, is_masked in targets:
        target_objs.append(Target(target, is_masked))

    for target in target_objs:
        command = ["bazel", "run", target.name]
        run_command(command)

    for target in target_objs:
        if target.is_masked:
            unmask_tf(target.path, MASK_STR, UNMASK_STR)
            command = ["bazel", "run", target.name]
            run_command(command)


if __name__ == "__main__":
    apply()
