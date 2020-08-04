#!/bin/bash
#
# DisableSELinux.sh
# Purpose: This script is used to disable firewalld and SELinux.
# By: Joe Chambers
#
# INSTRUCTIONS FOR USE:
# 1. Copy this shell script to your home directory or the /tmp directory.
# 2. Make it executable with the following command:
#      chmod a+x DisableSELinux.sh
# 3. Execute the script as a sudo user:
#      sudo ./DisableSELinux.sh

#Disable firewalld
systemctl stop firewalld 2> /dev/null
systemctl disable firewalld 2> /dev/null

# Disable SELinux
setenforce 0
sed -i.bak -e 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
echo ****Firewalld and SELinux successfully disabled.
echo 