import json
import os

from kafka import KafkaProducer

print("Loading function")

token = os.getenv("BROKER_TOKEN", default="g54cr3")
kafka_servers = [
    f"b-1.demomskcluster.{token}.c2.kafka.us-east-2.amazonaws.com",
    f"b-2.demomskcluster.{token}.c2.kafka.us-east-2.amazonaws.com",
    f"b-3.demomskcluster.{token}.c2.kafka.us-east-2.amazonaws.com",
]


def post_message_to_topic(topic, message):
    producer = KafkaProducer(bootstrap_servers=kafka_servers)
    message_to_send = json.dumps(message).encode("utf-8")
    metadata = producer.send(topic, value=message_to_send)
    producer.close()
    return metadata


def lambda_handler(event, context):
    print(f"Recieved Event Message : {json.dumps(event)}")
    body = json.loads(event.get("body"))
    metadata = post_message_to_topic(body.get("topic"), body.get("message"))
    response = {"headers": {"Content-Type": "application/json"}}
    if metadata.exception is not None:
        print(f"Failed to send message: {metadata.exception}")
        response["statusCode"] = 400
        response["body"] = json.dumps(
            {"message": f"Failed to send message: {metadata.exception}"}
        )
    else:
        print(f"Message sent successfully, {metadata.value}")
        response["statusCode"] = 200
        response["body"] = json.dumps(
            {"message": f"Message sent successfully, {metadata.value}"}
        )

    print(f"final respose : {response}")
    return response
