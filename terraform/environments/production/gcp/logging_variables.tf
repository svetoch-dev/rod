locals {
  logging = {
    log_bucket = {
    }
    log_router = {
      _Default = {
        log_bucket_name = "_Default"
        filter          = <<EOF
NOT LOG_ID("cloudaudit.googleapis.com/activity") AND
NOT LOG_ID("externalaudit.googleapis.com/activity") AND
NOT LOG_ID("cloudaudit.googleapis.com/system_event") AND
NOT LOG_ID("externalaudit.googleapis.com/system_event") AND
NOT LOG_ID("cloudaudit.googleapis.com/access_transparency") AND
NOT LOG_ID("externalaudit.googleapis.com/access_transparency") AND
NOT LOG_ID("cloudaudit.googleapis.com/data_access") AND
NOT LOG_ID("container.googleapis.com/apiserver") AND
NOT LOG_ID("container.googleapis.com/scheduler") AND
NOT LOG_ID("container.googleapis.com/controller-manager")
        EOF
      }
      k8s = {
        gcs_bucket_name = format("%s-logs-%s", var.company.name, local.env.short_name)
        filter          = <<EOF
LOG_ID("cloudaudit.googleapis.com/data_access") OR
LOG_ID("cloudaudit.googleapis.com/activity") OR
LOG_ID("container.googleapis.com/apiserver") OR
LOG_ID("container.googleapis.com/scheduler") OR
LOG_ID("container.googleapis.com/controller-manager")
        EOF
      }
    }
    log_audit = {
    }
  }
}
