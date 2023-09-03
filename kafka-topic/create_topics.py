import argparse
import subprocess

# Check if tabulate and kafka-python are installed, if not, install them
try:
    from tabulate import tabulate
except ImportError:
    subprocess.call(["pip3", "install", "tabulate"])
    from tabulate import tabulate


try:
    from kafka.admin import KafkaAdminClient, NewTopic
except ImportError:
    subprocess.call(["pip3", "install", "kafka-python"])
    from kafka.admin import KafkaAdminClient, NewTopic

token = "g54cr3"
kafka_servers = [
    f"b-1.demomskcluster.{token}.c2.kafka.us-east-2.amazonaws.com",
    f"b-2.demomskcluster.{token}.kafka.us-east-2.amazonaws.com",
    f"b-3.demomskcluster.{token}.kafka.us-east-2.amazonaws.com",
]


def create_topic_list(topics, current_topics):
    topic_list = []
    for each_topic in topics:
        if each_topic not in current_topics:
            topic_list.append(
                NewTopic(
                    name=each_topic,
                    num_partitions=1,
                    replication_factor=1,
                )
            )
    return topic_list


def get_all_topics(admin_client):
    current_topics = admin_client.list_topics()

    # Print the list of topics
    print("\n************ List of topics: **************")
    topics_table = [[topic] for topic in current_topics]

    print(tabulate(topics_table, headers=["Topics"], tablefmt="pretty"))

    return current_topics


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Create Kafka topics.")
    parser.add_argument(
        "topics", metavar="topic", nargs="+", help="List of topics to create"
    )

    args = parser.parse_args()
    topics_to_create = args.topics

    admin_client = KafkaAdminClient(bootstrap_servers=kafka_servers)

    current_topics = admin_client.list_topics()
    topic_list = create_topic_list(topics_to_create, current_topics)

    if topic_list:
        status = admin_client.create_topics(
            new_topics=topic_list, validate_only=False
        )
        print("Status of Kafka topic creation: ", status)
    else:
        print("No new topics to create.")

    get_all_topics(admin_client)
