#!/bin/bash

# Get the directory of the script
declare SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Source environment variables
source "$SCRIPT_PATH/env-hadoop.sh"

# Ensure SSH daemon is running
echo "Checking if SSH daemon is running..."
if ! systemctl is-active "ssh"; then
  echo "Starting SSH daemon..."
  sudo systemctl start ssh
  systemctl is-active "ssh"
fi
echo ""

# Format Hadoop Distributed File System
echo "Formatting Hadoop Distributed File System..."
if ! hd-hdfs namenode -format -nonInteractive -force; then
  echo "Failed to format HDFS NameNode."
  exit 1
fi

# Start NameNode daemon and DataNode daemon
# The hadoop daemon log output is written to the $HADOOP_LOG_DIR directory (defaults to $HADOOP_HOME/logs).
# Browse the web interface for the NameNode; by default it is available at: NameNode - http://localhost:9870/
echo "Starting NameNode, secondary namenodes and DataNode daemon..."
if ! hd-start-dfs ; then
  echo "Failed to start NameNode, secondary namenodes and DataNode daemon."
  hd-stop-dfs
  exit 1
else
  echo "Finished! NameNode available at http://localhost:9870/"
fi
echo ""

# Start ResourceManager daemon
# The hadoop daemon log output is written to the $HADOOP_LOG_DIR directory (defaults to $HADOOP_HOME/logs).
# Browse the web interface for the ResourceManager; by default it is available at: ResourceManager - http://localhost:8088/
echo "Starting ResourceManager and nodemanagers daemon..."
if ! hd-start-yarn ; then
  echo "Failed to start ResourceManager and nodemanagers daemon."
  hd-stop-yarn
  exit 1
else
  echo "Finished! ResourceManager available at http://localhost:8088/"
fi
echo ""