#!/bin/bash

LINE="---------------------------------------------------------"
clear
echo "${LINE}"
echo "      Mount OneDrive For Business on Ubuntu/Debian       "
echo "                                        By YHIBLOG       "
echo "${LINE}"
echo " "

echo "Please Input the OD4B Link, e.g. 'https://****-my.sharepoint.com/personal/name_domain_com/Documents/test'"
read OD4B
echo " "
echo " "
echo "${LINE}"
echo "The OD4B Link:"
echo "${OD4B}"
echo "${LINE}"
echo " "
echo " "
echo " "


echo "Please Input the Mount Path, e.g. '/home/test'"
read MPATH
echo " "
echo " "
echo "${LINE}"
echo "The Mount Path:"
echo "${MPATH}"
echo "${LINE}"
echo " "
echo " "
echo " "


echo "Please Input the 'rtFa' Cookie, e.g. 'Ppr80/mXu........UAAAA='"
read rtFa
echo " "
echo " "
echo "${LINE}"
echo "The 'rtFa' Cookie:"
echo "${rtFa}"
echo "${LINE}"
echo " "
echo " "
echo " "



echo "Please Input the 'FedAuth' Cookie, e.g. '77u/PD94b........9TUD4='"
read FedAuth
echo " "
echo " "
echo "${LINE}"
echo "The 'FedAuth' Cookie:"
echo "${FedAuth}"
echo "${LINE}"
echo " "
echo "Press Any Key to Start"
read


sudo apt-get update && sudo apt-get install -y davfs2
sudo chmod 777 /etc/davfs2/davfs2.conf
echo " " >> /etc/davfs2/davfs2.conf
echo " " >> /etc/davfs2/davfs2.conf
echo "[${MPATH}]" >> /etc/davfs2/davfs2.conf
echo "add_header Cookie ${rtFa};${FedAuth}" >> /etc/davfs2/davfs2.conf
sudo /sbin/mount.davfs ${OD4B} ${MPATH}
