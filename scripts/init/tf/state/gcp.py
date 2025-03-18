import click
import os
from google.cloud import storage


@click.command()
@click.argument("project_id", required=True, type=click.STRING)
@click.argument("bucket_name", required=True, type=click.STRING)
@click.argument("location", required=True, type=click.STRING)
def create_gcs_tf_state(project_id, bucket_name, location):
    """
    Creates a Google Cloud Storage tf state bucket if it does not already exist.

    Args:
        bucket_name (str): The name of the bucket to create
        project_id(str): The name of the project where bucket should be created
        location(str): bucket location
    """
    client = storage.Client(project=project_id)

    try:
        bucket = client.get_bucket(bucket_name)
        print(f"gcs tf state bucket {bucket_name} already exists.")
    except Exception as e:
        bucket = client.bucket(bucket_name)
        bucket.location = location
        bucket.storage_class = "STANDARD"
        bucket.public_access_prevention = "enforced"
        bucket.iam_configuration.uniform_bucket_level_access_enabled = False
        bucket.versioning_enabled = True
        bucket.lifecycle_rules = [
            {
                "action": {"type": "Delete"},
                "condition": {
                    "isLive": False,  # Targets noncurrent versions
                    "numNewerVersions": 200,  # Deletes versions if there is 200 newer versions
                },
            }
        ]
        bucket = client.create_bucket(bucket)
        print(f"gcs tf state bucket {bucket_name} created successfully.")


if __name__ == "__main__":
    create_gcs_tf_state()
