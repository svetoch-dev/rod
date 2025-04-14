# Infrastructure Provisioning Scripts

This section contains a collection of scripts that automate the initial infrastructure provisioning process.

The provisioning is divided into several stages:

1. **Pre-Provisioning Scripts**  
   Executed before the main provisioning routine to prepare the environment.

2. **Cloud Infrastructure Creation**  
   Performed using Terraform. This step creates all necessary cloud resources, such as:
   - Storage buckets
   - network
   - Kubernetes clusters
   - IAM roles
   - Container registries

3. **Pushing Custom Images to Registry**  
   Custom container images tailored for this template are built and pushed to the container registry to be used in the application deployment.

4. **Kubernetes Application Deployment**  
   Managed by ArgoCD. This step involves deploying various components such as:
   - Monitoring and logging tools  
   - Databases  
   - Caches and queues  

## `prepare.py`

A preparation script that:

- Deletes the `.git` directory to allow initialization of a fresh repository after provisioning is complete.

