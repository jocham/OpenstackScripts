#!/bin/bash
#
# GetEmailList.sh
# Purpose: This script is used to obtain an email list of all openldap users.
# By: Joe Chambers

systemctl is-active --quiet slapd && ldapservice=up

if [ "$ldapservice" == "up" ]
then
    #obtain list of emails
    ldapsearch -x -LLL -H ldapi:/// -b "dc=usiss-openldap,dc=unx,dc=sas,dc=com" mail | grep mail  > /tmp/file.txt

    #display emails only
    cat /tmp/file.txt | cut -d " " -f 2 > /tmp/file2.txt

    #remove the fake email accounts
    grep -v -e "sas@usiss-openldap.unx.sas.com" -e "cas@usiss-openldap.unx.sas.com" -e "pydemo@something.com" -e "Demo.demo@sas.com" -e "donotreply@sas.com" /tmp/file2.txt > /tmp/file4.txt

    #change from a list to a space separated text file
    emails=$(</tmp/file4.txt)
    echo $emails > /tmp/file5.txt

    #replace the space with a semicolon
    sed 's/ /;/g' /tmp/file5.txt > /root/LDAPEmailList.txt

    echo
    echo The file /root/LDAPEmailList.txt now contains an updated version email list of your openldap users.
    echo Use the following command to display the list:   cat /root/LDAPEmailList.txt
else
    echo
    echo The LDAP service appears to be down!
    echo Check the status by running:   systemctl status slapd
    echo Start the service by running:   systemctl start slapd
    echo Then, run this script again!

fi
