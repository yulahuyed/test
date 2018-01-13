#!/bin/bash

LINE="---------------------------------------------------------"
clear
echo "${LINE}"
       Mount OneDrive For Business on Ubuntu/Debian
                                      By YHIBLOG
echo "${LINE}"
echo " "

echo "Please Input the OD4B Link, e.g. 'https://****-my.sharepoint.com/personal/name_domain_com/Documents/test'"
read OD4B
echo " "
echo " "
echo "${LINE}"
echo "The OD4B Link:"
echo " "
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
echo "The Mount Path"
echo " "
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
echo "The 'rtFa' Cookie"
echo " "
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
echo "The 'FedAuth' Cookie"
echo " "
echo "${FedAuth}"
echo "${LINE}"
echo " "
echo " "
echo " "

sudo apt-get update && apt-get install davfs2
sudo chmod 777 /etc/davfs2/davfs2.conf
echo "[${MPATH}]" >> /etc/davfs2/davfs2.conf
echo "[add_header Cookie ${rtFa};${FedAuth}]" >> /etc/davfs2/davfs2.conf
sudo /sbin/mount.davfs ${OD4B} ${MPATH}
