

#!/bin/bash

# Install wget if it's not already installed
if ! command -v wget &> /dev/null; then
    echo "wget not found. Installing..."
    yum install -y wget  # For Amazon Linux 2; use apt-get for Ubuntu, etc.
fi

# Specify the URL of the raw file on GitHub
GITHUB_RAW_URL="https://raw.githubusercontent.com/girish-devops-project/aws-app-hosting/main/kafka-topic/create_topics.py?token=GHSAT0AAAAAACHBAYUTLE3MNPKYJ6X7RJUCZHUZ2VQ"

# Destination path on the EC2 instance
DESTINATION_PATH="/home/ec2-user/"

# Use wget to download the file
wget -O "$DESTINATION_PATH/create_topic.py" "$GITHUB_RAW_URL"

# Check if the download was successful
if [ $? -eq 0 ]; then
    echo "File downloaded successfully."
else
    echo "Failed to download the file."
fi
