# Opensource UC Installation

This repository helps install Asterisk 18, FreePBX 16, Queuemetrics, and Vacumonitor on Rocky Linux 8.

## Installation Instructions

Run the below commands to ensure that you can download and install the files in the repo:

```bash
sudo yum -y update
sudo yum -y install git
sudo mkdir -p /home/support
cd /home/support/
sudo git clone https://github.com/logicalis-sa-uc/opensource-uc-installation.git /home/support/
