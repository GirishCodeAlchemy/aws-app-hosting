import json

print("Loading function")


def lambda_handler(event, context):
    print(f"Recieved Event Message : {json.dumps(event, indent=2)}")
    return {
        "status": "success",
        "msg": f"Received  message: {json.dumps(event)}",
        "status_code": "200",
    }
