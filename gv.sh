#!/bin/bash
keyerrorlogo='
==================================================================

           --------- Google Voice申请脚本 ----------
		   		   
                                                 -----  jialezi 
==================================================================';


line="---------------------------------------------------------"
clear
echo "$keyerrorlogo";

echo "Please Input your Curl Command:"
read curl
echo " "
echo " "
echo "${line}"
echo "The Curl Command:"
echo "${curl}"
echo "${line}"
echo " "
echo " "
echo " "
echo "Please Input the Phone Number, e.g.3859998880"
read gv
echo " "
echo " "
echo "${line}"
echo "The Google Voice Number:"
echo "${gv}"
echo "${line}"

echo $curl > gv.txt

sed -i 's/--2.0 //' gv.txt
sed -i 's/\"%\"/%/g' gv.txt
sed -i 's/$/& 2>\/dev\/null/g' gv.txt
sed -i 's/mid=2/mid=6/' gv.txt
sed -i 's/true%5D/%22%2B1'$gv'%22%2Ctrue%2C%22%22%5D/' gv.txt
echo " "
echo " "
echo " "
echo "Please input your slack incoming webhook:"
read slack
echo " "
echo " "
echo "${line}"
echo "The Slack incoming webhook:"
echo "${slack}"
echo "${line}"
echo " "
echo "Press Any Key to Start";
read

for (( i=1; i>0; i++ ))
    do
	a=`bash gv.txt`;
    b='[[null,null,"There was an error with your request. Please try again."]]';
	if [[ "$a" != "$b" ]];
    then
        echo "执行失败/申请成功";
        echo "共执行 $i 次";
        curl -X POST --data-urlencode "payload={\"channel\": \"#private\", \"username\": \"Notice\", \"text\": \"Google Voice may have been applied successfully.\", \"icon_emoji\": \":smile:\"}" "${slack}"
    else
        echo "$i times) ${a}"
	fi
    sleep 0.5s;
done
