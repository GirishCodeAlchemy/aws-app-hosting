

#!/bin/bash

# Install wget if it's not already installed
if ! command -v wget &> /dev/null; then
    echo "wget not found. Installing..."
    yum install -y wget  # For Amazon Linux 2; use apt-get for Ubuntu, etc.
fi

# Specify the URL of the raw file on GitHub
create_topic_URL="https://raw.githubusercontent.com/GirishCodeAlchemy/upload-files/main/create_topics.py"
kafka_consumer_URL="https://raw.githubusercontent.com/GirishCodeAlchemy/upload-files/main/kafka_consumer.py"

# Destination path on the EC2 instance
DESTINATION_PATH="/home/ec2-user"

# Use wget to download the file
wget -O "$DESTINATION_PATH/create_topic.py" "$create_topic_URL"
wget -O "$DESTINATION_PATH/kafka_consumer.py" "$kafka_consumer_URL"

# Check if the download was successful
if [ $? -eq 0 ]; then
    echo "File downloaded successfully."
else
    echo "Failed to download the file."
fi
