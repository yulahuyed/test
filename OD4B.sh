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
if [ ! -d "${MPATH}" ]
then
  sudo mkdir -p ${MPATH}
fi
echo " "
echo " "
echo "${LINE}"
echo "The Mount Path:"
echo "${MPATH}"
echo "${LINE}"
echo " "
echo " "
echo " "


echo "Please Input the Username, e.g. 'user@domain.edu'"
read USERNAME
echo " "
echo " "
echo "${LINE}"
echo "The USERNAME:"
echo "${USERNAME}"
echo "${LINE}"
echo " "
echo " "
echo " "



echo "Please Input the Password:"
read PASSWORD
echo " "
echo " "
echo "${LINE}"
echo "The PASSWORD:"
echo "${PASSWORD}"
echo "${LINE}"
echo " "
echo "Press Any Key to Start"
read


sudo apt-get update && sudo apt-get install -y davfs2 wget python

if [ ! -f "/etc/davfs2/davfs2.conf" ]
then 
sudo echo " " >> /etc/davfs2/davfs2.conf
sudo echo " " >> /etc/davfs2/davfs2.conf
sudo chmod 777 /etc/davfs2/davfs2.conf
else
sudo chmod 777 /etc/davfs2/davfs2.conf
echo " " >> /etc/davfs2/davfs2.conf
echo " " >> /etc/davfs2/davfs2.conf
fi

wget https://raw.githubusercontent.com/yulahuyed/test/master/get-sharepoint-auth-cookie.py
python get-sharepoint-auth-cookie.py ${OD4B} ${USERNAME} ${PASSWORD} > cookie.txt
sed -i "s/ //g" cookie.txt
COOKIE=$(cat cookie.txt)
DAVFS_CONFIG=$(grep -i "use_locks 0" /etc/davfs2/davfs2.conf)
if [ "${DAVFS_CONFIG}" == "use_locks 0" ] 
then
  echo "continue..."
else
  echo "use_locks 0" >> /etc/davfs2/davfs2.conf
fi
echo "[${MPATH}]" >> /etc/davfs2/davfs2.conf
echo "add_header Cookie ${COOKIE}" >> /etc/davfs2/davfs2.conf
sudo /sbin/mount.davfs ${OD4B} ${MPATH}
