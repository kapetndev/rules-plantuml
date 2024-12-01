"""A package for generating UML diagrams."""

load("@rules_plantuml//internal:plantuml.bzl", _plantuml_graph = "plantuml_graph")

plantuml_graph = _plantuml_graph
