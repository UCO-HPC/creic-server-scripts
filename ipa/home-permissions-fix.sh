#!/usr/bin/env bash
# script to set each user's home directory to chmod 700 
# To be used when rsync copies over (potentially incorrect) permissions from old buddy

input="userlist.txt"

while IFS= read -r line
do
        #echo "chmod 700 /export/home/$(echo $line | awk '{print $1}')"
	sudo chmod 700 /export/home/$(echo $line | awk '{print $1}')
	echo "Set permissions for $(echo $line | awk '{print $1}')"

done < "$input"
