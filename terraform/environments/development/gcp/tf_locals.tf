locals {
  remote_state_config = {
  }
  remote_state = {
  }
}


data "google_project" "project" {}

data "google_client_config" "current" {}

data "google_compute_zones" "available" {}
