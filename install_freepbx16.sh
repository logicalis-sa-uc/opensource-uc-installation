#!/bin/bash

# Update the system
sudo dnf update -y

# Disable SE Linux
sudo setenforce 0
sudo sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config

# Install dependencies
sudo dnf -y install mariadb mariadb-server 
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Install Node.js
NODE_MAJOR=18
sudo dnf install -y https://rpm.nodesource.com/pub_$NODE_MAJOR.x/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm
sudo dnf install -y nodejs
  
# Install Apache Web Server
sudo dnf -y install httpd
sudo rm -f /var/www/html/index.html
sudo systemctl enable --now httpd

# Install PHP and extensions
sudo dnf -y install yum-utils
sudo dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
sudo dnf -y install https://rpms.remirepo.net/enterprise/remi-release-8.rpm
sudo dnf module -y reset php
sudo dnf module -y install php:remi-7.4
sudo dnf install -y wget \
  php \
  php-pear \
  php-cgi \
  php-common \
  php-curl \
  php-mbstring \
  php-gd \
  php-mysqlnd \
  php-gettext \
  php-bcmath \
  php-zip \
  php-xml \
  php-json \
  php-process \
  php-snmp

# Update PHP settings
sudo sed -i 's/upload_max_filesize = .*/upload_max_filesize = 20M/' /etc/php.ini
sudo sed -i 's/^memory_limit = .*/memory_limit = 128M/' /etc/php.ini

# Restart services
sudo systemctl restart httpd php-fpm
sudo systemctl enable php-fpm httpd

# Modify Apache settings
sudo sed -i 's/^\(User\|Group\).*/\1 asterisk/' /etc/httpd/conf/httpd.conf
sudo sed -i 's/AllowOverride None/AllowOverride All/' /etc/httpd/conf/httpd.conf
sudo sed -i 's/^\(user = \).*/\1asterisk/' /etc/php-fpm.d/www.conf
sudo sed -i 's/^\(group = \).*/\1asterisk/' /etc/php-fpm.d/www.conf
sudo sed -i 's/^\(listen.acl_users = \).*/\1apache,nginx,asterisk/' /etc/php-fpm.d/www.conf

# Install FreePBX
cd /home/distfiles/
sudo wget http://mirror.freepbx.org/modules/packages/freepbx/7.4/freepbx-16.0-latest.tgz
sudo tar -xvzf freepbx-16.0-latest.tgz
cd freepbx
sudo systemctl stop asterisk
sudo ./start_asterisk start
sudo ./install --webroot=/var/www/html -n

# Install FreePBX modules
sudo fwconsole ma disablerepo commercial
sudo fwconsole ma installall
sudo fwconsole ma delete firewall
sudo fwconsole reload
sudo fwconsole restart

sudo systemctl restart httpd php-fpm

# Create FreePBX startup script
sudo tee /etc/systemd/system/freepbx.service <<EOF
[Unit]
Description=FreePBX VoIP Server
After=mariadb.service

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/sbin/fwconsole start -q
ExecStop=/usr/sbin/fwconsole stop -q

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable freepbx

sudo systemctl stop firewalld
sudo systemctl disable firewalld

echo "FreePBX installation is complete."
