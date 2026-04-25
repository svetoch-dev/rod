locals {
  bazelisk_img_version = var.ci.bazelisk_img_version == "" ? trimspace(file("../../../../deps/images/bazelisk/image_tag.txt")) : var.ci.bazelisk_img_version

  remote_state_config = {
  }

  remote_state = {
  }
}
