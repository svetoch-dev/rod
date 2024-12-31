"""
Repository rule to read json to starlark vars
"""

def _impl(repository_ctx):
    json_data = json.decode(repository_ctx.read(repository_ctx.attr.src))

    repository_ctx.file("BUILD", "exports_files([ \"json.bzl\"])")
    repository_ctx.file("json.bzl", "{}={}".format(
        repository_ctx.attr.variable_name,
        repr(json_data),
    ))

load_json_file = repository_rule(
    implementation = _impl,
    attrs = {
        "src": attr.label(allow_single_file = True, mandatory = True),
        "variable_name": attr.string(mandatory = True),
    },
    local = True,
)
