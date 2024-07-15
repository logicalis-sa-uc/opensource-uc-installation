#!/bin/bash

# Update the system
sudo dnf update -y

# Disable SE Linux
sudo setenforce 0
sudo sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config

# Install dependencies
sudo dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
sudo dnf groupinstall "Development Tools" -y
sudo dnf install -y epel-release
sudo dnf config-manager --set-enabled powertools
sudo dnf install -y \
  git \
  wget \
  vim \
  svn \
  sngrep \
  net-tools \
  sqlite-devel \
  psmisc \
  ncurses-devel \
  ibtermcap-devel \
  newt-devel \
  libxml2-devel \
  libtiff-devel \
  gtk2-devel \
  libtool \
  libuuid-devel \
  subversion \
  kernel-devel \
  crontabs \
  cronie-anacron \
  sendmail \
  sendmail-cf \
  cronie \
  gnutls-devel \
  unixODBC \
  unixODBC-devel
  ncurses-devel \
  libxml2-devel \
  libedit \
  libedit-devel \
  sqlite-devel \
  mariadb-server \
  mariadb-devel
  
# Install Jansson
sudo mkdir /home/distfiles/
cd /home/distfiles/
sudo git clone https://github.com/akheron/jansson.git
cd jansson
sudo autoreconf -i
sudo ./configure --prefix=/usr/
sudo make
sudo make install

# Install PJSIP
cd /home/distfiles/
sudo git clone https://github.com/pjsip/pjproject.git
cd pjproject
sudo ./configure CFLAGS="-DNDEBUG -DPJ_HAS_IPV6=1" --prefix=/usr --libdir=/usr/lib64 --enable-shared --disable-video --disable-sound --disable-opencore-amr
sudo make dep
sudo make
sudo make install
sudo ldconfig

# Download Asterisk 18
cd /home/distfiles/
sudo wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-18-current.tar.gz
sudo tar -xzvf asterisk-18-current.tar.gz
cd asterisk-18*/
sudo ./contrib/scripts/install_prereq install
sudo ./contrib/scripts/get_mp3_source.sh
sudo ./configure --libdir=/usr/lib64
sudo make menuselect.makeopts
sudo menuselect/menuselect --enable res_config_mysql menuselect.makeopts
(I want to enable chan_mobile, chan_ooh323, format_mp3 and res_config_mysql in Add-ons)
(I want to enable CORE-SOUNDS-EN-WAV, CORE-SOUNDS-EN-ULAW, CORE-SOUNDS-EN-ALAW, CORE-SOUNDS-EN-GSM, CORE-SOUNDS-EN-G729, CORE-SOUNDS-EN-G722 in Core Sound Packages)
(I want to enable MOH-OPSOUND-WAV, MOH-OPSOUND-ULAW, MOH-OPSOUND-ALAW, MOH-OPSOUND-GSM, MOH-OPSOUND-GSM, MOH-OPSOUND-G729, MOH-OPSOUND-G722 in Music on Hold)
(I want to enable EXTRA-SOUNDS-EN-WAV, EXTRA-SOUNDS-EN-ULAW, EXTRA-SOUNDS-EN-ALAW, EXTRA-SOUNDS-EN-GSM, EXTRA-SOUNDS-EN-G729, EXTRA-SOUNDS-EN-G722 in Extra Sound Packages)
(I want to enable app_macro in Applications)

# Build and install Asterisk
sudo make
sudo make install
sudo make samples
sudo make config

# Create Users
sudo groupadd asterisk
sudo useradd -r -d /var/lib/asterisk -g asterisk asterisk
sudo usermod -aG audio,dialout asterisk
sudo chown -R asterisk.asterisk /etc/asterisk
sudo chown -R asterisk.asterisk /var/{lib,log,spool}/asterisk
sudo chown -R asterisk.asterisk /usr/lib64/asterisk

# Set Asterisk default user to asterisk
sudo bash -c 'echo "AST_USER=\"asterisk\"" >> /etc/sysconfig/asterisk'
sudo bash -c 'echo "AST_GROUP=\"asterisk\"" >> /etc/sysconfig/asterisk'
sudo bash -c 'echo "runuser= asterisk" >> /etc/sysconfig/asterisk'
sudo bash -c 'echo "rungroup= asterisk" >> /etc/sysconfig/asterisk'

# Enable and start Asterisk service
sudo systemctl enable asterisk
sudo systemctl start asterisk

# Verify Asterisk installation
sudo asterisk -vvvr

echo "Asterisk 18 installation is complete."
