#!/bin/bash

# Update the system
sudo dnf update -y

# Install Queuemetrics
cd /home/distfiles/
sudo wget https://yum.loway.ch/loway.repo -O /etc/yum.repos.d/loway.repo
sudo yum -y install queuemetrics

# Install Uniloader
sudo wget https://yum.loway.ch/loway.repo -O /etc/yum.repos.d/loway.repo
sudo yum install uniloader

echo "Queuemetrics installation is complete."
