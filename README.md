This repo is to help install Asterisk18, FreePBX16, Queuemetrics and Vacumonitor on Rocky Linux 8

Run the below commands to ensure that you can download and install the files in the repo.

sudo yum -y update \n
sudo yum -y install git \n
sudo mkdir -p /home/support \n
cd /home/support/ \n
sudo git clone https://github.com/logicalis-sa-uc/opensource-uc-installation.git \n
 \n
Make sure that you do chmod +x *.sh to make the scripts executable.
