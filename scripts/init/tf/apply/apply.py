import click
import os
import sys
import re
from dataclasses import dataclass
from libs.py.helpers import run_command, unmask_tf

WORKSPACE_FOLDER = os.getenv("BUILD_WORKSPACE_DIRECTORY")


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


@click.command()
@click.option("--targets", "-t", required=True, type=(str, bool), multiple=True)
def apply(targets):
    """
    1. Applies all apply targets passed in order

    2. Unmasks all masked tf code and applies related targets

    Args:
        targets(set(tuple(str, bool))): list of target tuples:
            1. first element target
            2. second element descibes the need for umasking tf code
    """
    os.chdir(WORKSPACE_FOLDER)
    target_objs = []
    query = ["bazel", "query", 'attr(name, "^apply$|^gh_apply$", "//terraform/...")']
    return_code, apply_targets = run_command(query, print_stdout=False)
    for target, is_masked in targets:
        if target in apply_targets:
            target_objs.append(Target(target, is_masked))

    for target in target_objs:
        command = ["bazel", "run", target.name]
        run_command(command)

    for target in target_objs:
        if target.is_masked:
            unmask_tf(target.path)
            command = ["bazel", "run", target.name]
            run_command(command)


if __name__ == "__main__":
    apply()
