#!/bin/bash

# Get the directory of the script
declare SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Source environment variables
source "$SCRIPT_PATH/env-hadoop.sh"

# Stop NameNode daemon and DataNode daemon
echo "Stopping NameNode, secondary namenodes and DataNode daemon..."
if ! hd-stop-dfs; then
  echo "Failed to stop NameNode, secondary namenodes and DataNode daemon."
  exit 1
fi
echo ""

# Stop ResourceManager daemon
echo "Stopping ResourceManager and nodemanagers daemon..."
if ! hd-stop-yarn; then
  echo "Failed to stop ResourceManager and nodemanagers daemon."
  exit 1
fi
echo ""