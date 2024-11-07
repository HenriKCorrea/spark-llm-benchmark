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

# Install Java if not already installed
echo "Checking if Java is installed..."
if ! command -v java; then
  sudo apt-get install openjdk-8-jre-headless
fi
echo ""

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
  sudo systemctl start ssh
fi
echo ""

# Define Hadoop version
declare -r HADOOP_DIR_NAME="hadoop-3.2.4"

# Check if hadoop download copy exsists
echo "Checking if Hadoop distribution exists..."
if [ ! -d "$HOME/Downloads/$HADOOP_DIR_NAME" ]; then

  # Check if hadoop tar file exists
  echo "Checking if Hadoop tar file exists..."
  if [ ! -f "$HOME/Downloads/$HADOOP_DIR_NAME.tar.gz" ]; then
    # Download Apache Hadoop distribution
    wget "https://dlcdn.apache.org/hadoop/common/$HADOOP_DIR_NAME/$HADOOP_DIR_NAME.tar.gz" -O "$HOME/Downloads/$HADOOP_DIR_NAME.tar.gz"
  fi

  # Extract Hadoop distribution
  echo "Extracting Hadoop distribution..."
  tar -xzf "$HOME/Downloads/$HADOOP_DIR_NAME.tar.gz" -C "$HOME/Downloads"
fi
echo ""

# Delete previous Hadoop distribution
echo "Deleting previous Hadoop distribution..."
if [ -d "/opt/$HADOOP_DIR_NAME" ]; then
  sudo rm -rf "/opt/$HADOOP_DIR_NAME"
fi
echo ""

# Move Hadoop distribution to /opt directory
echo "Moving Hadoop distribution to /opt directory..."
sudo mv "$HOME/Downloads/$HADOOP_DIR_NAME" /opt
echo ""

# Create symlink for Hadoop binaries
# sudo ln -s "/opt/$HADOOP_DIR_NAME/bin/*" /usr/local/bin/

# Set environment variables for Hadoop configuration
echo "Editing Hadoop environment variables..."
echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> /opt/$HADOOP_DIR_NAME/etc/hadoop/hadoop-env.sh
echo ""

# # Setup Hadoop configuration
# sudo mkdir "/opt/$HADOOP_DIR_NAME/etc/hadoop"
# sudo cp etc/hadoop/* "/opt/$HADOOP_DIR_NAME/etc/hadoop"

# # Start Hadoop services
# sudo -u hduser hadoop namenode -format
# sudo start-all.sh

# # Setup YARN
# sudo mkdir /opt/$HADOOP_DIR_NAME/yarn
# sudo cp yarn-site.xml /opt/$HADOOP_DIR_NAME/etc/hadoop

# # Start YARN services
# sudo -u hduser hadoop resourcemanager
# sudo -u hduser hadoop nodemanager

# ######################################################
# # Additional configuration for running jobs on YARN
# ######################################################

# # Set environment variables for YARN
# echo "export HADOOP_CONF_DIR=/opt/$HADOOP_DIR_NAME/etc/hadoop" >> ~/.bashrc
# source ~/.bashrc

# # Start YARN services
# sudo -u hduser hadoop resourcemanager
# sudo -u hduser hadoop nodemanager
