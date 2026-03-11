# Pre-Provisioning Steps

This section outlines the steps performed before provisioning the infrastructure.

## Configuration Preparation

These steps help ensure the infrastructure is configured correctly prior to deployment:

1. Select the appropriate `terraform.tfvars.json` file based on the cloud provider being used.
2. Apply any cloud-specific configuration adjustments as needed.

### GCP Notes

Google Cloud enforces a **30-day restoration period** for deleted custom roles. During this period, roles with the same name **cannot** be recreated.

To work around this, the `prepare.py` script appends a timestamp (in hours since epoch) to each custom role name, ensuring uniqueness and avoiding naming conflicts.

