#!/bin/bash
#
# Master.sh
# Purpose: This script is used to run the following Openstack initialization scripts:
# ChangeHostname.sh
# DisableSELinux.sh
# EnableRootSSH.sh
#
# By: Joe Chambers
#
# INSTRUCTIONS FOR USE:
# 1. Copy this shell script, along with ChangeHostname.sh, DisableSELinux.sh, and EnableRootSSH.sh to your home directory or the /tmp directory.
# 2. Make it executable with the following command:
#      chmod a+x Master.sh
# 3. Execute the script as a sudo user:
#      sudo ./Master.sh


if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
    
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo "Current directory is $DIR"

# Verify that the files exist
if [ -f $DIR/ChangeHostname.sh -a -f $DIR/DisableSELinux.sh -a -f $DIR/EnableRootSSH.sh ]; then
    
	# Ensure they are executable
    chmod +x $DIR/ChangeHostname.sh
    chmod +x $DIR/DisableSELinux.sh
    chmod +x $DIR/EnableRootSSH.sh

    # Run the scripts
    $DIR/ChangeHostname.sh
    $DIR/DisableSELinux.sh
    $DIR/EnableRootSSH.sh
else
    echo "Unable to find one of the files. Ensure that ChangeHostname.sh, DisableSELinux.sh, and EnableRootSSH.sh are all in the same directory as Master.sh."
fi
