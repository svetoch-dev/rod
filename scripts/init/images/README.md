# Building and Pushing Custom Images

Custom container images used in this template are built and pushed to a container registry. These images are later referenced during application deployment.

## Workflow Overview

### 🔧 Preparation

1. Parse `terraform.tfvars.json` to determine:
   - The cloud provider in use
   - The container registries required

2. Generate the appropriate entries in `.docker/config.json`  
   This file is used by container build tools to retrieve authentication credentials for pushing images.

### 🔨 Build & Push

1. Use `bazel query` to locate all `push_*` targets defined in the build system.
2. Iterate through the discovered targets and execute them.  
   This will trigger the build process and push the resulting images to the appropriate registries.

