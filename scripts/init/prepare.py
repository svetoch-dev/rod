from pathlib import Path
import shutil
import os

WORKSPACE_FOLDER = os.getenv("BUILD_WORKSPACE_DIRECTORY")


def prepare_repo():
    os.chdir(WORKSPACE_FOLDER)
    gitpath = Path(".git")
    if gitpath.exists() and gitpath.is_dir():
        shutil.rmtree(gitpath)


if __name__ == "__main__":
    prepare_repo()
