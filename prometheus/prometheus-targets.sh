#!/bin/bash
# Prometheus node add script by Ryan Maher
# Appends compute nodes to END prometheus config file as individual targets with label = node name
# The "nodes" job must be the last listed job in the config file since this script appends to the end of the file.

echo -n "Enter the number of the first node to add (Ex: for node-205, enter 205): "
read firstnode
echo -n "Enter number of nodes to add: "
read nodecount

# Make sure input is provided else die with an error
if [[ "$nodecount" == "" ]]
then
    echo "$0 - Input is missing."
    exit 1
fi

if [[ "$firstnode" == "" ]]
then
    echo "$0 - Input is missing."
    exit 1
fi

# The regular expression matches digits only
if [[ "$nodecount" =~ ^[0-9]+$ || "$nodecount" =~ ^[-][0-9]+$ || "$firstnode" =~ ^[0-9]+$ || "$firstnode" =~ ^[-][0-9]+$ ]]
	
then
   : 
else
    echo "Please enter integers only."
    exit
fi

lastnode=$((firstnode + nodecount - 1))

# Confirm info with user
echo -e "\n"
echo $nodecount' nodes will be added with the first being node-'$firstnode' and the last being node-'$lastnode

echo -n "Proceed? [y/n]: "
read proceed

if [[ "$proceed" == "n" || "$proceed" == "N" ]]
then 
	exit
fi

for ((count=1; count<=nodecount; count++))
do
	# IF YOU USE ANY TABS INSTEAD OF SPACES PROMETHEUS WILL CRY
	echo '      - targets: ["node-'$firstnode'.hpc.uco.edu:9100"]
        labels:
          instance: "node-'$firstnode'"' >> /etc/prometheus/prometheus.yml
	((firstnode+=1))
done
