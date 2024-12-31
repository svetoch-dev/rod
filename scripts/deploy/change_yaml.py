import click
import os
import yaml
from glob import glob

WORKSPACE_FOLDER = os.getenv("BUILD_WORKSPACE_DIRECTORY")


class Dumper(yaml.Dumper):
    def increase_indent(self, flow=False, *args, **kwargs):
        return super().increase_indent(flow=flow, indentless=False)


def str_presenter(dumper, data):
    """configures yaml for dumping multiline strings
    Ref: https://stackoverflow.com/questions/8640959/how-can-i-control-what-scalar-form-pyyaml-uses-for-my-data
    """
    if data.count("\n") > 0:  # check for multiline string
        return dumper.represent_scalar("tag:yaml.org,2002:str", data, style="|")
    return dumper.represent_scalar("tag:yaml.org,2002:str", data)


yaml.add_representer(str, str_presenter)
yaml.representer.SafeRepresenter.add_representer(
    str, str_presenter
)  # to use with safe_dum


@click.command()
@click.argument("app_file", required=True, type=click.STRING)
@click.argument("service_name", required=True, type=click.STRING)
@click.argument("tag_file", required=True, type=click.STRING)
def change_yaml(app_file, service_name, tag_file):
    # Used in bazel CD targets
    # when file with stamped info is passed
    image_tag = ""
    if os.path.isfile(tag_file):
        with open(tag_file) as f:
            image_tag = f.read()

    file = None
    data = None
    for filename in glob(f"{WORKSPACE_FOLDER}/{app_file}", recursive=True):
        file = open(filename, "r")
        data = yaml.load(file, Loader=yaml.FullLoader)

    data[service_name]["image"]["tag"] = image_tag

    yaml_data = yaml.dump(data, Dumper=Dumper, sort_keys=False)
    file.close()
    file = open(file.name, "w")
    file.write(yaml_data)
    file.close()


if __name__ == "__main__":
    change_yaml()
