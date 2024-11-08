#!/bin/bash

# Get the directory of the script
declare SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Define GIT project root path
declare PROJECT_ROOT_PATH="$SCRIPT_PATH/.."

# Define Hadoop name with version
declare HADOOP_NAME="hadoop-3.2.4"

# Define Hadoop configuration template path (Will define operation mode in future)
declare HADOOP_TEMPLATE_PATH="$PROJECT_ROOT_PATH/hadoop-template"

# Define Hadoop home directory
declare HADOOP_HOME_PATH="/opt/$HADOOP_NAME"

# Define user download path
declare DOWNLOAD_PATH="$HOME/Downloads"

# Define SSH path
declare SSH_PATH="$HOME/.ssh"

# Define HSFS user directory path
declare HD_HDFS_USER_PATH="/user/$USER"

# Define HDFS (Hadoop Distributed File System) command path
declare HD_HDFS_CMD="$HADOOP_HOME_PATH/bin/hdfs"

# Define Hadoop command path
declare HD_HADOOP_CMD="$HADOOP_HOME_PATH/bin/hadoop"

# Define Start DFS (Distributed File System) command
declare HD_START_DFS_CMD="$HADOOP_HOME_PATH/sbin/start-dfs.sh"

# Define Stop DFS (Distributed File System) command
declare HD_STOP_DFS_CMD="$HADOOP_HOME_PATH/sbin/stop-dfs.sh"

# Define Start YARN (Yet Another Resource Negotiator) command
declare HD_START_YARN_CMD="$HADOOP_HOME_PATH/sbin/start-yarn.sh"

# Define Stop YARN (Yet Another Resource Negotiator) command
declare HD_STOP_YARN_CMD="$HADOOP_HOME_PATH/sbin/stop-yarn.sh"

# Define HDFS (Hadoop Distributed File System) function alias
hd-hdfs() {
  "$HD_HDFS_CMD" "$@"
}

export -f hd-hdfs

# Define Hadoop function alias
hd-hadoop() {
  "$HD_HADOOP_CMD" "$@"
}

export -f hd-hadoop

# Define Hadoop start-dfs function alias
hd-start-dfs() {
  "$HD_START_DFS_CMD" "$@"
}

export -f hd-start-dfs

# Define Hadoop stop-dfs function alias
hd-stop-dfs() {
  "$HD_STOP_DFS_CMD" "$@"
}

export -f hd-stop-dfs

# Define Hadoop start-yarn function alias
hd-start-yarn() {
  "$HD_START_YARN_CMD" "$@"
}

export -f hd-start-yarn

# Define Hadoop stop-yarn function alias
hd-stop-yarn() {
  "$HD_STOP_YARN_CMD" "$@"
}

export -f hd-stop-yarn