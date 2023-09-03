import json

print("Loading function")


def lambda_handler(event, context):
    print(f"Recieved Event Message : {json.dumps(event)}")

    response = {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(
            {
                "message": f"Received  message: {event.get('body')}",
            }
        ),
    }
    print(f"final respose : {response}")
    return response
