import subprocess


def run_command(command):
    command_str = " ".join(command)
    print(f"Running: {command_str}")
    result = subprocess.Popen(command, stdout=subprocess.PIPE, text=True)
    for line in result.stdout:
        print(line, end="")

    result.wait()
    if result.returncode != 0:
        print("Command failed with return code:", result.returncode)
