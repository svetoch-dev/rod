"""
Deb packages for container images
"""

load("@rules_distroless//apt:defs.bzl", "dpkg_status")
load("@rules_distroless//distroless:defs.bzl", "flatten")

def deb_packages(packages, name = None):
    """Creates dpkg_status and returns a label that points to a single archive with all packages

    Args:
        name: unused arg to stick with conventions
        packages: list of package labels
    Returns:
        a label that points to single tar archive with all packages included
    """

    packages_formatted = []
    tar_archive_name = "packages"

    for package in packages:
        packages_formatted.append(
            "{}/amd64".format(package),
        )

    dpkg_status(
        name = "dpkg_status",
        controls = [
            "%s:control" % package
            for package in packages_formatted
        ],
    )

    flatten(
        name = "{}_uncompressed".format(tar_archive_name),
        tars = packages_formatted + ["dpkg_status"],
        deduplicate = True,
    )

    native.genrule(
        name = tar_archive_name,
        srcs = [
            "{}_uncompressed".format(tar_archive_name),
        ],
        outs = ["{}.tar.gz".format(tar_archive_name)],
        cmd = """
          cat $< | $(ZSTD_BIN) --compress --stdout --format=gzip >$@
        """,
        toolchains = ["@zstd_toolchains//:resolved_toolchain"],
    )

    return tar_archive_name
