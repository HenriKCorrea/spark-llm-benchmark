#!/bin/bash

# Get the directory of the script
declare SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Source environment variables
source "$SCRIPT_PATH/env-hadoop.sh"

# Format Hadoop Distributed File System
echo "Formatting Hadoop Distributed File System..."
if ! hd-hdfs namenode -format -nonInteractive -force; then
  echo "Failed to format HDFS NameNode."
  exit 1
fi

# Start NameNode daemon and DataNode daemon
# The hadoop daemon log output is written to the $HADOOP_LOG_DIR directory (defaults to $HADOOP_HOME/logs).
# Browse the web interface for the NameNode; by default it is available at: NameNode - http://localhost:9870/
echo "Starting NameNode daemon and DataNode daemon..."
if ! hd-start-dfs; then
  echo "Failed to start NameNode daemon and DataNode daemon."
  exit 1
else
    echo "Success! NameNode web interface: http://localhost:9870"
fi

# Make the HDFS directories required to execute MapReduce jobs:

if ! hd-hdfs dfs -mkdir -p "$HD_HDFS_USER_PATH"; then
  echo "Failed to create '$HD_HDFS_USER_PATH' directory."
  exit 1
fi

