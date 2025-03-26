import click
from google.cloud import service_usage_v1
from google.api_core.exceptions import AlreadyExists, PermissionDenied


def api_enabled(client, project_id, api):
    """
    Checks if api is enabled or not

    Args:
        client(object): client used to communicate with google api
        project_id(str): The name of the project that where apis need to be enabled
        api(str): The name of the api that should be enabled
    Returns:
        bool: True if api is enabled. False if not
    """
    request = service_usage_v1.GetServiceRequest(
        name=f"projects/{project_id}/services/{api}"
    )

    response = client.get_service(request=request)

    return response.state == service_usage_v1.types.State.ENABLED


def enable_apis(project_id, apis):
    """
    Enables specific Google APIs for the project.

    Args:
        project_id(str): The name of the project that where apis need to be enabled
        apis(list(str)): list of strings representing google apis
    """
    client = service_usage_v1.ServiceUsageClient()
    for api in apis:
        if not api_enabled(client, project_id, api):
            try:
                request = service_usage_v1.EnableServiceRequest(
                    name=f"projects/{project_id}/services/{api}"
                )
                operation = client.enable_service(request=request)
                result = operation.result()
                print(
                    f"Compute Engine API has been successfully enabled for project {project_id}."
                )
            except AlreadyExists:
                print(
                    f"The Compute Engine API is already in the process of being enabled for project {project_id}."
                )
            except PermissionDenied:
                print(
                    "Permission denied. Ensure the service account has the 'Service Usage Admin' role."
                )
            except Exception as e:
                print(f"An error occurred while enabling the Compute Engine API: {e}")
        else:
            print(f"api {api} is already enabled on project {project_id}")


@click.command()
@click.argument("project_ids", required=True, type=click.STRING)
@click.argument("apis", required=True, type=click.STRING)
def tf_prepare(project_ids, apis):
    """
    Prepares google projects

    Args:
        project_ids(str): comma separated list of projects
        apis(str): comma separated list of apis to enable
    """

    apis = apis.split(",")
    project_ids = project_ids.split(",")
    for project_id in project_ids:
        enable_apis(project_id, apis)


if __name__ == "__main__":
    tf_prepare()
