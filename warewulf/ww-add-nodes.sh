#!/bin/bash
# Warewulf node add script by Ryan Maher
# Adds nodes from a CSV file including the MAC address of the network interface.
# Needs a csv file to be passed as an argument when running, more details in documentation on GLPI

file="$1"
echo -n "Enter the node number of the first node (Ex: for node-201, enter 201): "
read nodenum
echo "Enter the C and D values for the first node (10.200.C.D)"
echo -n "C: "
read cval
echo -n "D: "
read dval
echo -n "Enter the profile name: "
read profile

# Make sure input is provided else die with an error
if [[ "$nodenum" == "" ]]
then
    echo "$0 - Input is missing."
    exit 1
fi

# The regular expression matches digits only
if [[ "$nodenum" =~ ^[0-9]+$ || "$nodenum" =~ ^[-][0-9]+$  ]]
	
then
   : 
else
    echo "$0 - $nodenum is NOT an integer. Please enter integers only."
    exit
fi

echo 'First node will be: node-'$nodenum'
      With an IP address of: 10.200.'$cval.$dval'
      Profile: '$profile''

echo -n "Proceed? [y/n]: "
read proceed
if [[ "$proceed" == "n" ]]
then 
	exit
fi

while IFS=";" read -r node_name mac_1 mac_2 mac_3
do
	# echo "Node name: $node_name"
	# echo "ENO1 MAC: $mac_2"
	# echo ""
	sudo wwctl node add node-$nodenum --ipmiaddr 10.200.$cval.$dval --profile $profile
	sudo wwctl node set --netname=Ethernet --ipaddr 10.202.$cval.$dval --hwaddr $mac_2 node-$nodenum -y
	sudo wwctl node set --netname=InfiniBand --ipaddr 10.201.$cval.$dval node-$nodenum -y
	echo "Added $node_name as node-$nodenum with MAC address $mac_2" 
	
	((nodenum+=1))
	((dval+=1))
done < <(tail -n +2 "$file")
