"""
Deploy macros
"""

load("@rules_multirun//:defs.bzl", "command")
load("//tools/utils:common.bzl", "build_envs")

def deploy(service_name, app_name, envs):
    """Macro for deploying services to specific envs

    Args:
      service_name: name of the service that is part of the app
      app_name: app that needs to be updated
      envs: list of strings representing short environment names (pre,prd,int,dev etc)
    """
    for env, _ in build_envs().items():
        if env in envs:
            command(
                name = "deploy_" + env,
                command = "//scripts/deploy:change_yaml",
                data = [
                    "//tools/stamping:stamp_img",
                    #Adding this in order to include
                    #deploy_* jobs in dependency graph for service
                    #files
                    ":push_" + env,
                ],
                arguments = [
                    "argocd/environments/*-{}/{}/values.yaml".format(env, app_name),
                    service_name,
                    "$(rootpath //tools/stamping:stamp_img)",
                ],
            )
