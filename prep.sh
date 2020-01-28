#!/bin/sh

# /etc/sysconfig/network-scripts/ifcfg-eth0
# DEVICE=eth0
# TYPE=Ethernet
# BOOTPROTO=dhcp
# ONBOOT=yes

# Update the packages on this template master
#ifup eth0
yum update -y
#reboot

# Ensure root user account is enabled by giving it a password, then use it to continue
#sudo passwd root
#logout

# TODO Remove any custom user accounts created during installation
#deluser ggoodrich --remove-home
userdel --remove ggoodrich

# Hostname management - CentOs configures this automatcially on boot

# Remove udev persistent device rules that get created during creation of template
# Centos/RHEL seems to have these within /usr/lib/udev/rules.d/70* ???
rm -r /etc/udev/rules.d/70*
rm -r /usr/lib/udev/rules.d/70*
# Centos/RHEL NetworkManager puts these under /var/lib/NetworkManager
rm -r /var/lib/dhclient/*
rm /var/lib/NetworkManager/timestamps
rm /var/lib/NetworkManager/*.lease
rm /var/lib/NetworkManager/secret_key # Appears to use this as, or to generate, the mac address, so get rid of it

# Remove ssh keys
rm -f /etc/ssh/*key*

# Clean log files
cat /dev/null > /var/log/audit/audit.log 2>/dev/null
cat /dev/null > /var/log/wtmp 2>/dev/null
logrotate -f /etc/logrotate.conf 2>/dev/null
rm -f /var/log/*-* /var/log/*.gz 2>/dev/null

# Set hostname
hostname localhost
echo "localhost" > /etc/hostname

# Force root passwd to expire to force setting it
passwd --expire root

# Clear user history
history -c
>/root/.bash_history
unset HISTFILE

# Shutdown the vm
#halt -p

# Create the template from the stopped vm
