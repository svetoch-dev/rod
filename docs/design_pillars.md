# Design Pillars

1. We **do not introduce technical debt**.
2. We keep it simple
3. We use python for all our scripts
4. We use **multiple cloud providers** as Infrastructure-as-a-Service (IaaS).
5. We **minimize the use of cloud-specific services**—ideally using only networking, buckets and virtual machines.
6. Each environment (e.g., development, production, preprod) resides in a **separate, isolated project/account**.
7. We use a dedicated environment called `internal` for running **internal tools** such as monitoring, log aggregation, and CI/CD systems.
8. We use **Kubernetes** to run our workloads.
9. We follow the [**Operator Pattern**](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/) wherever applicable.
10. Every aspect of infrastructure is **defined as code**.
11. Our primary tools are:
    1. `terraform` – for Infrastructure as Code.
    2. `argocd + helm` – for continuous delivery.
    3. `bazel` – for:
        - Reproducibly running scripts across all platforms/OSes  
        - Providing fast and simple CI for our tools and scripts  
        - Gluing everything together
12. We use the **App of Apps** pattern with ArgoCD.
13. We **do not hardcode** company-, environment-, or cloud-specific information in code.
14. The **only allowed places** to store such specific information are:
    - `argocd/envs.yaml`
    - `terraform/terraform.tfvars.json`
