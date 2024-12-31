"""
File for defining constants
"""

ENVS = {
    "prd": {
        "project": "infrared-production",
        "registry": "{PRD_CONTAINER_REGISTRY}",
        "region": "europe-west2",
    },
    "dev": {
        "project": "infrared-development",
        "registry": "{DEV_CONTAINER_REGISTRY}",
        "region": "europe-west2",
    },
    "int": {
        "project": "infrared-internal",
        "registry": "{INT_CONTAINER_REGISTRY}",
        "region": "europe-west2",
    },
}
