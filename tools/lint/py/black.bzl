"""
Black linter macros
"""

load("@aspect_rules_py//py:defs.bzl", "py_test")
load("@py_deps//:requirements.bzl", "requirement")

def py_lint():
    """
    Macro to test formatting for all *.py files of a package
    """
    py_test(
        name = "lint",
        srcs = ["//tools/lint/py:black_src"],
        data = native.glob(["**/*.py"]),
        args = [
            #All *.py files in WORKSPACE
            ".",
            #Only check
            "--check",
            #Exclude external dict
            #for python dependencies
            "--exclude",
            "external",
        ],
        deps = [
            requirement("black"),
        ],
    )
