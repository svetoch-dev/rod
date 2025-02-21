"""Functions used for string formatting"""

load("@tfvars//:json.bzl", "tfvars")

def format_dict(
        replacement_dict = None,
        format_dict = None):
    """Formats dict based on key/value pairs in replacement_dict

    Recursion in starlark is not allowed so we need to think of some hacks

    Args:
       replacement_dict: dict with key/value pairs used to format
       format_dict: dict where fields are searched
    Returns:
       formatted dict
    """
    dict_str = str(format_dict)

    #we need to replace uppercase bools that returned
    #by str func because they are not valid in json
    #spec
    dict_str = dict_str.replace("True", "true")
    dict_str = dict_str.replace("False", "false")

    for key, value in replacement_dict.items():
        dict_str = dict_str.replace("{" + key + "}", str(value))

    return json.decode(dict_str)

def formatted_tfvars(state_name = None):
    """Renders tfvars based on values of tfvars dict itself and args

    Args:
       state_name: name of state eg gcp,aws,cloud,secrets etc
    Returns:
       formatted tfvars dict
    """

    #Common parameters passed to str.format()
    #used to render templated strings in tfvars var
    replacement_dict = {
        "company.name": tfvars["company"]["name"],
        "tf_backend.state_name": state_name,
    }

    tf_vars = format_dict(replacement_dict, tfvars)

    for env, env_obj in tfvars["envs"].items():
        replacement_dict["env.cloud.region"] = env_obj["cloud"]["region"]
        replacement_dict["env.cloud.id"] = env_obj["cloud"]["id"]
        replacement_dict["env.name"] = env_obj["name"]
        replacement_dict["tf_backend.type"] = env_obj["tf_backend"]["type"]
        tf_vars["envs"][env] = format_dict(replacement_dict, env_obj)

    return tf_vars
