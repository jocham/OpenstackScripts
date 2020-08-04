#!/bin/bash
#
# EnableRootSSH.sh
# Purpose: This script is used to enable root login using SSH.
# By: Joe Chambers
#
# INSTRUCTIONS FOR USE:
# 1. Copy this shell script to your home directory or the /tmp directory.
# 2. Make it executable with the following command:
#      chmod a+x EnableRootSSH.sh
# 3. Execute the script as a sudo user:
#      sudo ./EnableRootSSH.sh


# Back up the authorized_keys, ssh and cloud config files.
AKEY=/root/.ssh/authorized_keys.bak
SSHCFG=/etc/ssh/sshd_config.bak
CLDCFG=/etc/cloud/cloud.cfg.bak

if [ -f "$AKEY" ]; then
    echo "$AKEY exists, skipping backup."
else 
    cp /root/.ssh/authorized_keys /root/.ssh/authorized_keys.bak
fi

if [ -f "$SSHCFG" ]; then
    echo "$SSHCFG exists, skipping backup."
else 
    cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
fi

if [ -f "$CLDCFG" ]; then
    echo "$CLDCFG exists, skipping backup."
else 
    cp /etc/cloud/cloud.cfg /etc/cloud/cloud.cfg.bak
fi

# Modify the "PermitRootLogin" and "PasswordAuthentication" options within /etc/ssh/sshd_config.
sed -i -e 's/^#PermitRootLogin yes/PermitRootLogin without-password/g' /etc/ssh/sshd_config
sed -i -e 's/^PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config

# Enable root login in the /etc/cloud/cloud.cfg
sed -i -e 's/disable_root: 1/disable_root: 0/g' /etc/cloud/cloud.cfg
sed -i -e 's/ssh_pwauth:   0/ssh_pwauth:   1/g' /etc/cloud/cloud.cfg

systemctl restart sshd.service

# Set the root and centos password to Orion123
echo "****Setting the password for Root and Centos to Orion123."
echo "Orion123" | passwd --stdin centos
echo "Orion123" | passwd --stdin root
echo 
# Are you sure?
read -p 'This script will remove the first 156 characters from /root/.ssh/authorized_keys which prevents root login by default. Do you want to continue? [y/n] ' CONFIRM

if [ "$CONFIRM" == "y" ]; then
    echo "****Removing the stuff from authorized_keys preventing root from SSH."
    cat /root/.ssh/authorized_keys.bak | cut -c 156- > /root/.ssh/authorized_keys
else
    echo
    echo You entered $CONFIRM
    echo Exiting the EnableRootSSH script
fi
echo 
