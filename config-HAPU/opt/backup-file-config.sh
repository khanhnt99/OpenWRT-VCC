#!/bin/bash
# Author: sondx

# Prepare: Install git, git-http package for OpenWRT OS
# opkg install git git-http

# Remove old configuration file
rm -rf /opt/configuration-file/etc/
rm -rf /opt/configuration-file/root/
rm -rf /opt/configuration-file/usr/


# Copy serveral file of /etc/ folder
mkdir /opt/configuration-file/etc/
mkdir /opt/configuration-file/etc/init.d/

cp -r /etc/config /opt/configuration-file/etc/
cp -r /etc/crontabs/ /opt/configuration-file/etc/
cp /etc/init.d/telegraf /opt/configuration-file/etc/init.d/
cp -r /etc/luci-uploads/ /opt/configuration-file/etc/
cp -r /etc/openvpn/ /opt/configuration-file/etc/
cp /etc/firewall.user /opt/configuration-file/etc/
cp /etc/mwan3.user /opt/configuration-file/etc/
cp /etc/rc.local /opt/configuration-file/etc/
cp /etc/telegraf.conf /opt/configuration-file/etc/


# Copy /root/ folder
cp -r /root/ /opt/configuration-file/


# Copy /usr/sbin/telegraf file
mkdir -p /opt/configuration-file/usr/sbin
cp /usr/sbin/telegraf /opt/configuration-file/usr/sbin/


# Push to repo: https://git.paas.vn/hermios/configuration-file
cd /opt/configuration-file/
git add -A
git commit -m "Update configuration file"
git push origin master
