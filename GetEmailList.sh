#!/bin/bash
#
# GetEmailList.sh
# Purpose: This script is used to obtain an email list of all openldap users.
#
# How to use:
# 1. If users want to be excluded from the list, add them (CASE SENSITIVE!) to a new line in /root/excludeEmails.txt
# 2. To generate the email list, submit this command: sudo /root/GetEmailList.sh
# 3. The outlook-formatted list of emails can be found here: /root/LDAPEmailList.txt
#
# By: Joe Chambers

exc=/root/excludeEmails.txt
all=/tmp/allmails.txt
final=/root/LDAPEmailList.txt

#verify the ldap service is running
systemctl is-active --quiet slapd && ldapservice=up

if [ "$ldapservice" == "up" ]
then
    #obtain list of emails
    ldapsearch -x -LLL -H ldapi:/// -b "dc=usiss-openldap,dc=unx,dc=sas,dc=com" mail | grep mail  > /tmp/file.txt

    #display emails only
    cat /tmp/file.txt | cut -d " " -f 2 > $all

    #exclude emails on the exclusion list
    if [ -f "$exc" ] && [ -s "$exc" ]; then
        echo "Excluding the list of emails from $exc"
        awk 'NR == FNR{ a[$0] = 1;next } !a[$0]' $exc $all > /tmp/mod.txt

    else
        echo "The file $exc does not exist or is empty...skipping exclusions"
        cat $all > /tmp/mod.txt
    fi

    #remove the fake email accounts
    grep -v -e "sas@usiss-openldap.unx.sas.com" -e "cas@usiss-openldap.unx.sas.com" -e "pydemo@something.com" -e "Demo.demo@sas.com" -e "donotreply@sas.com" /tmp/mod.txt > /tmp/file4.txt

    #change from a list to a space separated text file
    emails=$(</tmp/file4.txt)
    echo $emails > /tmp/file5.txt

    #replace the space with a semicolon
    sed 's/ /;/g' /tmp/file5.txt > $final

    echo
    echo The file $final now contains an updated version email list of your openldap users.
    echo Use the following command to display the list:   cat $final
else
    echo
    echo The LDAP service appears to be down!
    echo Check the status by running:   systemctl status slapd
    echo Start the service by running:   systemctl start slapd
    echo Then, run this script again!

fi
