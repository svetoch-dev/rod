# 🗂️ Terraform State Setup

Create a cloud-specific Terraform backend to manage remote state effectively. This enables collaborative infrastructure management and state consistency.

## GCP Notes

For Google Cloud Platform, the Terraform state is stored in a **Google Cloud Storage (GCS)** bucket. The bucket is created with the following configuration:

- **Storage Class:** `STANDARD`  
- **Public Access Prevention:** Enabled  
- **Versioning:** Enabled  
- **Version Retention:** Keep the last 200 versions  

These settings help ensure durability, traceability, and security of the Terraform state files.

