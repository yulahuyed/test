#!/bin/bash


line="---------------------------------------------------------"
clear
echo "${line}"
echo "                 Google Voice (YHIBLOG)                  "
echo "${line}"
echo " "

echo "Please Input the Phone Number, e.g. 3859998880"
read gv
echo " "
echo " "
echo "${line}"
echo "The Google Voice Number:"
echo "${gv}"
echo "${line}"
echo " "
echo " "
echo " "

echo "Please Input your Curl Command, e.g. curl 'https://www.google.com/voice/b/0/service/post' *** --data ****"
read curl

echo $curl > gv.txt

sed -i 's/--2.0 //' gv.txt
sed -i 's/\"%\"/%/g' gv.txt
sed -i 's/$/& 2>\/dev\/null/g' gv.txt
sed -i 's/mid=2/mid=6/' gv.txt
sed -i 's/true%5D/%22%2B1'$gv'%22%2Ctrue%2C%22%22%5D/' gv.txt

echo " "
echo " "
echo "${line}"
echo "Check the Curl Command:"
cat gv.txt
echo "${line}"
echo " "
echo " "
echo " "

echo "Please input your slack incoming webhook, e.g. https://hooks.slack.com/services/***/***/****"
read SLACK_WEBHOOK
echo " "
echo " "
echo "${line}"
echo "The Slack incoming webhook:"
echo "${SLACK_WEBHOOK}"
echo "${line}"

echo " "
echo " "
echo " "
echo "Please input your slack channel, e.g. private"
read SLACK_CHANNEL
echo " "
echo " "
echo "${line}"
echo "The Slack Channel:"
echo "${SLACK_CHANNEL}"
echo "${line}"
echo " "
echo "Press Any Key to Start";
read

for (( i=1; i>0; i++ ))
    do
	a=`bash gv.txt`;
	b="[]"
	if [[ "$a" == "$b" ]];
		then
			echo "Get the $gv successful, Total $i times" >> result.txt
			echo "${a}" >> result.txt
			curl -X POST --data-urlencode "payload={\"channel\": \"#${SLACK_CHANNEL}\", \"username\": \"Notice\", \"text\": \"Total $i times, $gv have been applied successfully.\", \"icon_emoji\": \":smile:\"}" "${SLACK_WEBHOOK}"
			exit 0
		else
			echo "$i times) ${a}"
	fi
done
