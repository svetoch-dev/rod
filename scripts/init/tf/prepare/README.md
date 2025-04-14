# Preparation

Before provisioning begins, cloud-specific initialization steps must be completed to ensure a smooth infrastructure setup.

## GCP Notes

To use Terraform with Google Cloud Platform (GCP), make sure the following is done:

1. **Enable the Compute Engine API** for all relevant GCP projects.

This is a required prerequisite for provisioning resources such as VM instances, networks, and Kubernetes clusters using Terraform on GCP.

