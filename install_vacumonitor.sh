#!/bin/bash

# Extract files
sudo mv vacumonitor.tar.gz /home/distfiles/
cd /home/distfiles/
sudo tar -xzvf vacumonitor.tar.gz

# Make Directories
sudo mkdir -p /home/opsmail/bin/
sudo mkdir -p /home/opsmail/etc/
sudo mkdir -p /home/opsmail/log/
sudo mkdir -p /usr/local/etc/

# Move the files
cd /home/distfiles/vacumonitor/
sudo cp hoover.sh /home/opsmail/bin/
sudo cp vacumonitor.sh /home/opsmail/bin/
sudo cp vacumonitor.conf /home/opsmail/etc/
sudo cp opsmail.conf /usr/local/etc/opsmail.conf
sudo touch /home/opsmail/log/vacumonitor.log
sudo touch /home/opsmail/log/vacumonitor.error.log

# Add cron job as root
(crontab -l 2>/dev/null; echo "30 00 * * * /home/opsmail/bin/hoover.sh >/home/opsmail/log/hoover.log 2>&1") | sudo crontab -

echo "Vacumonitor installation is complete."
