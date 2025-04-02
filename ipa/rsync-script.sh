#!/usr/bin/env bash

# Script to be run on storage-bak ONLY
# Script to transfer user home space contents from Buddy 2.0 to 2.5
# Utilizes ssh key to allow for automatic passwordless ssh connection for each rsync job

input="userlist.txt"

while IFS= read -r line
do
	echo "Syncing files for user $(echo $line | awk '{print $1}')..."
	sudo rsync -azXA -e "ssh -i /hpcadmin/.ssh/id_ed25519" --rsync-path="sudo rsync" /mnt/backup/home/$(echo $line | awk '{print $1}')/ hpcadmin@10.201.192.3:/export/home/$(echo $line | awk '{print $1}')
	wait
	echo "Done syncing files for user $(echo $line | awk '{print $1}')"
	
done < "$input"
