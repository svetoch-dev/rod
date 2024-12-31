import os
import git

WORKSPACE_FOLDER = os.getenv("BUILD_WORKSPACE_DIRECTORY")


def push_commit():
    repo = git.Repo(WORKSPACE_FOLDER)
    repo.git.add("argocd/environments")
    repo.git.commit(m="CI/CD: add new image tag")
    repo.git.push()


if __name__ == "__main__":
    push_commit()
