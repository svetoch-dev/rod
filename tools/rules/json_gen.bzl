"""Generate json file based on given json string"""

def _json_gen_impl(ctx):
    json_content = ctx.attr.json_content
    output = ctx.actions.declare_file(ctx.attr.out)
    ctx.actions.write(output = output, content = json_content)
    return DefaultInfo(files = depset([output]))

json_gen = rule(
    implementation = _json_gen_impl,
    attrs = {
        "json_content": attr.string(
            mandatory = True,
        ),
        "out": attr.string(
            mandatory = True,
        ),
    },
)
