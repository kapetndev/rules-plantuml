"""A set of rules to build PlantUML graphs."""

load("//plantuml/private:actions.bzl", "plantuml_generate")

_PLANTUML_TOOL = Label("@rules_plantuml//:plantuml")

def _plantuml_graph_impl(ctx):
    """Implementation of the plantuml_graph rule.

    Args:
        ctx: The context of the rule.
    """
    output = ctx.actions.declare_file("{name}.{format}".format(
        name = ctx.label.name,
        format = ctx.attr.format,
    ))

    plantuml_generate(
        ctx,
        src = ctx.file.src,
        format = ctx.attr.format,
        config = ctx.file.config,
        out = output,
    )

    return [
        DefaultInfo(files = depset([output])),
    ]

plantuml_graph = rule(
    implementation = _plantuml_graph_impl,
    attrs = {
        "config": attr.label(
            doc = "Configuration file to pass to PlantUML. Useful to tweak the skin.",
            allow_single_file = True,
        ),
        "format": attr.string(
            doc = "Output image format.",
            default = "png",
            values = ["png", "svg"],
        ),
        "src": attr.label(
            allow_single_file = [".puml"],
            doc = "Source file to generate the graph from.",
            mandatory = True,
        ),
        "_plantuml_tool": attr.label(
            doc = "The plantuml tool.",
            default = _PLANTUML_TOOL,
            executable = True,
            cfg = "exec",
            mandatory = False,
        ),
    },
    outputs = {
        "graph": "%{name}.%{format}",
    },
    doc = "Generates a PlantUML graph from a puml file.",
)
