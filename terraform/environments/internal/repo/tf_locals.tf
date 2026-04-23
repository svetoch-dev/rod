locals {
  bazelisk_img_version = var.ci.bazelisk_img_version == "" ? trimspace(file("./bazelisk_tag.txt")) : var.ci.bazelisk_img_version

  remote_state_config = {
  }

  remote_state = {
  }
}
