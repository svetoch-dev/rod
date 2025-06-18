# Design Pillars

1. We **do not introduce technical debt**.
2. We use **multiple cloud providers** as Infrastructure-as-a-Service (IaaS).
3. We **minimize the use of cloud-specific services**—ideally using only networking and virtual machines.
4. Each environment (e.g., development, production, preprod) resides in a **separate, isolated project/account**.
5. We use a dedicated environment called `internal` for running **internal tools** such as monitoring, log aggregation, and CI/CD systems.
6. We **treat environments as objects** (in the OOP sense) that expose properties and methods, used by other environments and users.
7. We use **Kubernetes** to run our workloads.
8. We follow the [**Operator Pattern**](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/) wherever applicable.
9. Every aspect of infrastructure is **defined as code**.
10. Our primary tools are:
    1. `terraform` – for Infrastructure as Code.
    2. `argocd + helm` – for continuous delivery.
    3. `bazel` – for:
        - Reproducibly running scripts across all platforms/OSes  
        - Providing fast and simple CI for our tools and scripts  
        - Gluing everything together
11. We use the **App of Apps** pattern with ArgoCD.
12. We **do not hardcode** company-, environment-, or cloud-specific information in code.
13. The **only allowed places** to store such specific information are:
    - `argocd/envs.yaml`
    - `terraform/terraform.tfvars.json`
