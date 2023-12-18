def rule(event):
    return (
        event.get("actionName") == "EXECUTE_DATA_LAKE_QUERY"
        and event.deep_get("actor", "attributes", "email") == 'reid@greynoise.io'
    )
