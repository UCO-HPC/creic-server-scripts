#!/bin/bash
#
# File: 00-system-info - create the MOTD
# Copyright: (C) Martin Doering <martin@datapulp.de>
# License: Public Domain (do what you want with it)
#

diskusage=$(df -H -x squashfs -x tmpfs -x devtmpfs --total|grep /$)

echo "###############################################"
echo -e " Hostname: \033[1;33m$(hostname)\033[0m"
echo " Distro: $(hostnamectl | grep -Po 'Operating System: \K.*')"
echo " Kernel: $(hostnamectl | grep -Po 'Kernel: \K.*')"
echo
echo " Machine: $(hostnamectl | grep -Po 'Hardware Vendor: \K.*') $(hostnamectl | grep -Po 'Hardware Model: \K.*')"
echo " CPU: $(cat /proc/cpuinfo | grep 'model name' | head -1 | cut -d':' -f2)"
echo " Disk: $(echo $diskusage | awk '{ a = $2 } END { print a }'|sed 's/G/ G/'|sed 's/T/ T/')"
echo " Memory: $(free -m | head -n 2 | tail -n 1 | awk {'print $2'}) M"
echo " Swap: $(free -m | tail -n 1 | awk {'print $2'}) M"
echo

if which ip >/dev/null
then
echo " IP V4 Networks"
ip -o -4 -br a|grep -v '^lo'|sed 's/^/ /'|sed 's/\/..//'
echo
echo " IP V6 Networks"
ip -o -6 -br a|grep -v '^lo'|sed 's/^/ /'|sed 's/\/..//'
fi
echo "###############################################"
# printf "%`tput cols`s"|tr ' ' '#'
