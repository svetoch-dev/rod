# 🔐 Import Secrets

This process imports sensitive data (e.g., credentials, tokens) required by infrastructure-level applications.

## 🧭 Steps

1. **Parse `terraform.tfvars.json`**  
   Extract the list of secrets from the `import_secrets` field.

2. **Unmask the `import_secrets_variables.tf` file**  

3. **Iterate over `import_secrets`**  
   Loop through each secret defined in step 1.

4. **Check if the secret exists in the Terraform state**  
   Skip import if already present.

5. **If not present, retrieve the value**  
   Attempt to load from an environment variable using the pattern:  
   ```
   TF_IMPORT_SECRET_<SECRET_NAME>_<SECRET_KEY>
   ```
- `<SECRET_NAME>`: The name of the secret.
- `<SECRET_KEY>`: The specific key within the Kubernetes secret.

6. **Prompt for input if the environment variable is missing**  
Ask the user to manually provide the secret value.

7. **Apply the secrets**  
Run `terraform apply` to store the imported secrets in the infrastructure state.

