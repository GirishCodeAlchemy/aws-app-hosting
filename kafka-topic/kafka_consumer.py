import argparse

from kafka import KafkaConsumer

kafka_servers = [
    "b-1.demomskcluster.x5mzw0.c2.kafka.us-east-2.amazonaws.com:9092",
    "b-2.demomskcluster.x5mzw0.c2.kafka.us-east-2.amazonaws.com:9092",
    "b-3.demomskcluster.x5mzw0.c2.kafka.us-east-2.amazonaws.com:9092",
]


def main():
    parser = argparse.ArgumentParser(description="Kafka Consumer")
    parser.add_argument(
        "topic_name", help="Name of the Kafka topic to consume from"
    )
    args = parser.parse_args()
    topic_name = args.topic_name

    consumer = KafkaConsumer(
        topic_name,
        group_id="my-group",  # Specify a unique group id
        bootstrap_servers=kafka_servers,
        auto_offset_reset="earliest",  # Start reading from the beginning of the topic
        enable_auto_commit=True,  # Automatically commit offsets
        value_deserializer=lambda x: x.decode("utf-8"),
    )

    try:
        for message in consumer:
            print(f"Received message: {message.value}")
    except KeyboardInterrupt:
        print("Consumer terminated by user.")
    finally:
        consumer.close()


if __name__ == "__main__":
    main()
