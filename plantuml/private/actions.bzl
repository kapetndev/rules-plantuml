"""PlantUML actions."""

load("@bazel_skylib//lib:shell.bzl", "shell")

def plantuml_generate(ctx, src, format, config, out):
    """Generates a single PlantUML graph from a puml file.

    Args:
        ctx: analysis context.
        src: source file to be read.
        format: the output image format.
        config: the configuration file. Optional.
        out: output image file.
    """
    command = plantuml_command_line(
        executable = ctx.executable._plantuml_tool.path,
        config = config.path if config else None,
        src = src.path,
        output = out.path,
        output_format = format,
    )

    inputs = [src]

    if config:
        inputs.append(config)

    ctx.actions.run_shell(
        tools = [ctx.executable._plantuml_tool],
        inputs = inputs,
        outputs = [out],
        command = command,
        mnemonic = "PlantUML",
        progress_message = "Generating %s" % out.basename,
    )

def plantuml_command_line(executable, config, src, output, output_format):
    """Formats the command line to call PlantUML with the given arguments.

    Args:
        executable: path to the PlantUML binary.
        config: path to the configuration file. Optional.
        src: path to the source file.
        output: path to the output file.
        output_format: image format of the output file.

    Returns:
        A command to invoke PlantUML.
    """
    cmd_config = ""
    if config:
        cmd_config = "-config {config}".format(config = shell.quote(config))

    return "{plantuml} -nometadata -p -t{format} {config} < {src} > {output}".format(
        plantuml = shell.quote(executable),
        format = output_format,
        config = cmd_config,
        src = shell.quote(src),
        output = shell.quote(output),
    )
