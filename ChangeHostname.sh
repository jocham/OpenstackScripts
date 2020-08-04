#!/bin/bash
#
# ChangeHostname.sh
# Purpose: This script is used to rename your hostname.
# By: Joe Chambers
#
# INSTRUCTIONS FOR USE:
# 1. Copy this shell script to your home directory or the /tmp directory.
# 2. Make it executable with the following command:
#      chmod a+x ChangeHostname.sh
# 3. Execute the script as a sudo user:
#      sudo ./ChangeHostname.sh

# Find the current Hostname
HOST=`hostnamectl | awk '/Static/ {print $3}'`

#Remove the spaces from the Hostname variable
HOST=`echo $HOST | sed -e 's/^[[:space:]]*//'`

echo Your current hostname is: $HOST
echo

# Are you sure?
read -p 'This script will rename your hostname. You must sudo or run as root. Do you want to continue? [y/n] ' CONTINUE

if [ "$CONTINUE" == "y" ]
then

    #Must set selinux to permissive to run this script
    sudo setenforce 0

    #Ask user for hostname
    read -p 'Hostname: ' USERHOST

    #Update Hostname in three places: hostnamectl, /etc/hosts, and /etc/hostname
    echo
    echo ****Modifying the /etc/host file to your new hostname: $USERHOST
    sudo sed -i -e "s/$HOST/$USERHOST/" /etc/hosts
    sudo sed -i -e "s/$HOST/$USERHOST/" /etc/hostname
    echo ****Modifying the hostnamectl
    sudo hostnamectl --static set-hostname $USERHOST
    sudo hostnamectl --transient set-hostname $USERHOST
    sudo systemctl restart systemd-hostnamed
    echo
    echo You can review the change here: /tmp/ChangeHostname.log

    #Create the log with the changes
    sudo rm -f /tmp/ChangeHostname.log
tee -a /tmp/ChangeHostname.log > /dev/null <<FOO
Review your changes:
***********************
****/etc/hosts file****
***********************
FOO

   cat /etc/hosts >> /tmp/ChangeHostname.log
cat <<EOT >> /tmp/ChangeHostname.log


***********************
******hostnamectl******
***********************
EOT
    hostnamectl >> /tmp/ChangeHostname.log

else
    echo
    echo You entered $CONTINUE
    echo Exiting the ChangeHostname script
fi
echo 