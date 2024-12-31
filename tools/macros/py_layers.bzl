"""
Build layers for py container images
"""

load("@aspect_bazel_lib//lib:tar.bzl", "mtree_mutate", "mtree_spec", "tar")

# match *only* external repositories that have the string "python"
# e.g. this will match
#   `/hello_world/hello_world_bin.runfiles/rules_python~0.21.0~python~python3_9_aarch64-unknown-linux-gnu/bin/python3`
# but not match
#   `/hello_world/hello_world_bin.runfiles/_main/python_app`
PY_INTERPRETER_REGEX = "\\.runfiles/.*python.*-.*"

# match *only* external pip like repositories that contain the string "site-packages"
SITE_PACKAGES_REGEX = "\\.runfiles/.*/site-packages"

# Default py layers. Produce layers in this order, as the app changes most often
PY_LAYERS = ["interpreter", "packages", "app"]

def py_layers(name, binary, layers = PY_LAYERS, mutate_mtree = None):
    """Create three layers for a py_binary target: interpreter, third-party dependencies, and application code.

    This allows a container image to have smaller uploads, since the application layer usually changes more
    than the other two.

    Args:
        name: prefix for generated targets, to ensure they are unique within the package
        binary: a py_binary target
        layers: what py layers should be created
        mutate_mtree: name of the mtree_mutate rule that needs to be applied to mtree_spec
    Returns:
        a list of labels for the layers, which are tar files
    """

    # Produce the manifest for a tar file of our py_binary, but don't tar it up yet, so we can split
    # into fine-grained layers for better docker performance.
    mtree_spec(
        name = name + ".mf",
        srcs = [binary],
    )

    if not mutate_mtree:
        mutate_mtree = name + "_change_owner.mf"
        mtree_mutate(
            name = mutate_mtree,
            mtree = name + ".mf",
            owner = "1000",
        )

    native.genrule(
        name = name + ".interpreter_tar_manifest",
        srcs = [mutate_mtree],
        outs = [name + ".interpreter_tar_manifest.spec"],
        cmd = "grep -v '{}' $< | grep '{}' >$@".format(SITE_PACKAGES_REGEX, PY_INTERPRETER_REGEX),
    )

    native.genrule(
        name = name + ".packages_tar_manifest",
        srcs = [mutate_mtree],
        outs = [name + ".packages_tar_manifest.spec"],
        cmd = "grep '{}' $< >$@".format(SITE_PACKAGES_REGEX),
    )

    # Any lines that didn't match one of the two grep above
    native.genrule(
        name = name + ".app_tar_manifest",
        srcs = [mutate_mtree],
        outs = [name + ".app_tar_manifest.spec"],
        cmd = "grep -v '{}' $< | grep -v '{}' >$@".format(SITE_PACKAGES_REGEX, PY_INTERPRETER_REGEX),
    )

    result = []
    for layer in layers:
        layer_target = "{}.{}_layer".format(name, layer)
        result.append(layer_target)
        tar(
            name = layer_target,
            srcs = [binary],
            mtree = "{}.{}_tar_manifest".format(name, layer),
            visibility = ["//visibility:public"],
        )

    return result
