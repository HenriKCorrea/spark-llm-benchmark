#!/bin/bash

######################################################
# Install Apache Hadoop on Ubuntu OS
#
# This script will install Apache Hadoop on a single-node
# developer laptop in pseudo-distributed mode. It will also
# set up YARN and allow for running jobs by setting the
# necessary parameters and starting the ResourceManager
# daemon and NodeManager daemon.
######################################################

# Get the directory of the script
declare SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Source environment variables
source "$SCRIPT_PATH/env-hadoop.sh"

# Install Java if not already installed
echo "Checking if Java is installed..."
if ! command -v java; then
  sudo apt-get install openjdk-8-jre-headless 
fi
echo ""

echo "Checking if jps is installed (part of JDK, allows check java running process)..."
if ! command -v jps; then
  sudo apt-get install openjdk-8-jdk-headless
fi

# Ensure SSH client is installed
echo "Checking if SSH client is installed..."
if ! command -v ssh; then
  sudo apt-get install openssh-client
fi
echo ""

# Ensure SSH server is installed
echo "Checking if SSH server is installed..."
if ! command -v sshd; then
  sudo apt-get install openssh-server
fi
echo ""

# Ensure SSH daemon is running
echo "Checking if SSH daemon is running..."
if ! systemctl is-active "ssh"; then
  echo "Starting SSH daemon..."
  sudo systemctl start ssh
  systemctl is-active "ssh"
fi
echo ""

# Check if hadoop download copy exsists
echo "Checking if Hadoop distribution exists..."
if [ ! -d "$DOWNLOAD_PATH/$HADOOP_NAME" ]; then

  # Check if hadoop tar file exists
  echo "Checking if Hadoop tar file exists..."
  if [ ! -f "$DOWNLOAD_PATH/$HADOOP_NAME.tar.gz" ]; then
    # Download Apache Hadoop distribution
    wget "https://dlcdn.apache.org/hadoop/common/$HADOOP_NAME/$HADOOP_NAME.tar.gz" -O "$DOWNLOAD_PATH/$HADOOP_NAME.tar.gz"
  fi

  # Extract Hadoop distribution
  echo "Extracting Hadoop distribution..."
  tar -xzf "$DOWNLOAD_PATH/$HADOOP_NAME.tar.gz" -C "$DOWNLOAD_PATH"
fi
echo ""

# Delete previous Hadoop distribution
echo "Deleting previous Hadoop distribution..."
if [ -d "$HADOOP_HOME_PATH" ]; then
  rm -rf "$HADOOP_HOME_PATH"
fi
echo ""

# Move Hadoop distribution to $(dirname $HADOOP_HOME_PATH) directory
echo "Moving Hadoop distribution to '$(dirname $HADOOP_HOME_PATH)' directory..."
if ! mv "$DOWNLOAD_PATH/$HADOOP_NAME" "$(dirname $HADOOP_HOME_PATH)"; then
  echo "Failed to deploy Hadoop distribution."
  exit 1
fi
echo ""

# Copy Hadoop configuration files (YARN on Single Node)
echo "Copy Hadoop configuration files (YARN on Single Node)..."
if ! cp "$HADOOP_TEMPLATE_PATH/etc/hadoop/"*.xml "$HADOOP_HOME_PATH/etc/hadoop/"; then
  echo "Failed to deploy Hadoop configuration files."
  exit 1
fi
echo ""

# Set environment variables for Hadoop configuration
echo "Editing Hadoop environment variables..."
echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> "$HADOOP_HOME_PATH/etc/hadoop/hadoop-env.sh"
echo ""

# Function to test SSH connection
test_ssh_connection() {

  # Generate SSH Key Pair if not exists
  echo "Generating SSH Key Pair if not set yet..."
  if [ ! -f "$SSH_PATH/id_rsa" ]; then
    ssh-keygen -t rsa -P '' -f "$SSH_PATH/id_rsa"
  fi
  echo ""

  # Copy Public Key to Authorized Keys if not already copied
  echo "Copying Public Key to Authorized Keys if not already copied..."
  if ! grep -q "$(cat $SSH_PATH/id_rsa.pub)" "$SSH_PATH/authorized_keys"; then
    cat "$SSH_PATH/id_rsa.pub" >> "$SSH_PATH/authorized_keys"
    chmod 600 "$SSH_PATH/authorized_keys"
  fi
  echo ""

  # Add localhost host key to known hosts if not already added
  echo "Adding localhost host key to known hosts if not already added..."
  if ! ssh-keygen -F localhost > /dev/null; then
    echo "localhost host key not found in known hosts. Adding..."
    ssh-keyscan -H localhost >> "$SSH_PATH/known_hosts"
  fi
  echo ""

  # Test SSH Connection
  echo "Testing SSH connection..."
  if ssh -o BatchMode=yes -o ConnectTimeout=5 localhost exit; then
    echo "SSH connection successful"
  else
    echo "SSH connection failed"
    exit 1
  fi
  echo ""
}

# Call the function to test SSH connection
test_ssh_connection

