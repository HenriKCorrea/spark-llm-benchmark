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
if ! command -v java &> /dev/null; then
  sudo apt-get install openjdk-8-jre-headless
fi

# Download Apache Hadoop distribution
wget 
https://archive.apache.org/dist/hadoop/common/hadoop-3.2.4/hadoop-3.2.4.tarhttps://archive.apache.org/dist/hadoop/common/hadoop-3.2.4/hadoop-3.2..tar.gz

# Extract Hadoop distribution
tar -xzf hadoop-3.2.4.tar.gz

# Move Hadoop distribution to /opt directory
sudo mv hadoop-3.2.4 /opt

# Create symlink for Hadoop binaries
sudo ln -s /opt/hadoop-3.2.4/bin/* /usr/local/bin/

# Set environment variables for Hadoop configuration
echo "export HADOOP_HOME=/opt/hadoop-3.2.4" >> ~/.bashrc
echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> ~/.bashrc
source ~/.bashrc

# Setup Hadoop configuration
sudo mkdir /opt/hadoop-3.2.4/etc/hadoop
sudo cp etc/hadoop/* /opt/hadoop-3.2.4/etc/hadoop

# Start Hadoop services
sudo -u hduser hadoop namenode -format
sudo start-all.sh

# Setup YARN
sudo mkdir /opt/hadoop-3.2.4/yarn
sudo cp yarn-site.xml /opt/hadoop-3.2.4/etc/hadoop

# Start YARN services
sudo -u hduser hadoop resourcemanager
sudo -u hduser hadoop nodemanager

######################################################
# Additional configuration for running jobs on YARN
######################################################

# Set environment variables for YARN
echo "export HADOOP_CONF_DIR=/opt/hadoop-3.2.4/etc/hadoop" >> ~/.bashrc
source ~/.bashrc

# Start YARN services
sudo -u hduser hadoop resourcemanager
sudo -u hduser hadoop nodemanager
