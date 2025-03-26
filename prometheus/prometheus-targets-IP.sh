#!/bin/bash
# Prometheus node add script by Ryan Maher
# Adds compute nodes as targets with labels to END prometheus config file
# The "nodes" job must be the last listed job in the config file since this script appends to the end of the file.
echo -n "Enter the number of the first node to add: (ex: node-101 -> 101): "
read first_node
echo -n "Enter the 3rd octet of the nodes to add (ex: node-104 -> 1): "
read third_octet
echo -n "Enter the 4th octet of the first node to add (ex: node-104 -> 4): "
read first_node_fourth_octet
echo -n "Enter the number of nodes to add:"
read nodecount

# Make sure input is provided else die with an error
if [[ "$nodecount" == "" ]]
then
    echo "$0 - Input is missing."
    exit 1
fi

#if [[ "$firstnode" == "" ]]
#then
#    echo "$0 - Input is missing."
#    exit 1
#fi

# The regular expression matches digits only
if [[ "$nodecount" =~ ^[0-9]+$ || "$nodecount" =~ ^[-][0-9]+$ || "$firstnode" =~ ^[0-9]+$ || "$firstnode" =~ ^[-][0-9]+$ ]]
	
then
   : 
else
    echo "Please enter integers only."
    exit
fi

#last_node_third_octet=$((first_node_third_octet + nodecount - 1))
last_node_fourth_octet=$((first_node_fourth_octet + nodecount - 1))

# Confirm info with user
echo -e "\n"
echo $nodecount' nodes will be added with the first being 10.201.'$third_octet'.'$first_node_fourth_octet' and the last being 10.201.'$third_octet'.'$last_node_fourth_octet''

echo -n "Proceed? [y/n]: "
read proceed

if [[ "$proceed" == "n" || "$proceed" == "N" ]]
then 
	exit
fi

for ((count=1; count<=nodecount; count++))
do
	# IF YOU USE ANY TABS INSTEAD OF SPACES PROMETHEUS WILL CRY
	echo '      - targets: ["10.201.'$third_octet'.'$first_node_fourth_octet':9100"]
        labels:
          instance: "node-'$first_node'"' >> /etc/prometheus/prometheus.yml
	((first_node+=1))
	((first_node_fourth_octet+=1))
done
