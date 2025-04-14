# 🚀 Apply Infrastructure

This process applies all Terraform states across the environments defined in `terraform.tfvars.json`.

## 🔄 Apply Order

To ensure proper dependency handling, Terraform states must be applied in the following order:

1. **CI**
2. **Internal environments** (excluding secrets)
3. **Other environments** (e.g., `dev`, `prd`, `pre`, etc.)
4. **Internal secrets**

## 🔒 Masked Code Handling

After the initial apply, a secondary **unmasking phase** is performed. During this phase:

- All `##MASKED##` placeholders in Terraform files are replaced with their actual values.
- A second `apply` is executed with the updated configurations.

