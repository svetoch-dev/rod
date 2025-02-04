"""Functions used for string formatting"""


def _get_nested_attr_in_dict(
        attr_path,
        search_dict):
    """Gets field value based on search string

    Args:
       attr_path: dot separated string representing path to
           dict field eg "env.prd.state" == search_dict["env"]["prd"]["state"]
       search_dict: dict where to get the value of nested attr
    Rerurns:
       found value of the search_dict
    """

    path = attr_path.split(".")
    nested_value = None
    for e in path:
        if nested_value:
            nested_value = nested_value[e]
        else:
            nested_value = search_dict[e]

    return nested_value

def format_attr_in_dict(
        replacement_dict,
        format_dict,
        attr_path):
    """Formats specific fields in dict based on key/value pairs in replacement_dict

    Recursion in starlark is not allowed so we need manually specify fields to render

    Args:
       replacement_dict: dict with key/value pairs used to format tfvars
       attr_path: key of the field that needs formatting. Use dots if the
           field is in a nested dict eg "env.prd.state" == format_dict["env"]["prd"]["state"]
       format_dict: dict where fields are searched
    Rerurns:
       formatted value found in format_dict based on attr_path search str
    """

    return_value = None

    attr = _get_nested_attr_in_dict(attr_path, format_dict)

    if type(attr) == "string":
        return_value = attr.format(**replacement_dict)
    elif type(attr) == "dict":
        return_value = {}
        for k, v in attr.items():
            return_value[k] = v.format(**replacement_dict)

    return return_value
