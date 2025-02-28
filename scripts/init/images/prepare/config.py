import os
import sys

HOME_DIR = os.getenv("HOME")
DOCKER_CONFIG_DIR = f"{HOME_DIR}/.docker"
DOCKER_CONFIG_FILE = f"{DOCKER_CONFIG_DIR}/config.json"


def create_dir(dir_name):
    try:
        os.mkdir(dir_name)
        print(f"Directory '{dir_name}' created successfully.")
    except FileExistsError:
        print(f"Directory '{dir_name}' already exists.")
    except PermissionError:
        print("Permission denied: Unable to create the directory.")
        sys.exit(1)


def create_file(file_name):
    if not os.path.exists(file_name):
        with open(file_name, "w") as file:
            print(f"File '{file_name}' created successfully.")
    else:
        print(f"File '{file_name}' already exists.")


create_dir(DOCKER_CONFIG_DIR)
create_file(DOCKER_CONFIG_FILE)
