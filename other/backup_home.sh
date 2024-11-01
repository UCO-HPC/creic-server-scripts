#!/bin/bash
echo "##############################"
# Timestamp
DATETIME=$(date)
echo ${DATETIME}
echo "------------------------------"

if { findmnt --target '/home' >/dev/null;}; then
	echo "Starting RSync Copy"
	rsync -az --delete /home /mnt/backup/
	echo "RSync Copy Complete"
else
	echo "Drive Mount Error"
fi
echo "##############################"
