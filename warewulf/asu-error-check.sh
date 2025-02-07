#!/bin/bash

# ASU node error checker script
# Runs parallel ASU commands to connect to a node and return any event logs with high severity

for n in {1..30};
do
	# echo "node 10.200.1.$n:"
	# echo -e "\n"
	sudo /opt/ibm/toolscenter/asu/asu64 immapp showimmlog --host 10.200.1.$n --user admin --password $(cat /etc/imm.pass) | grep 'Severity:3\|Severity:4' | sed "s/^/node 10.200.1.$n:  /" & 	
done

for n in {1..32};
do
#	echo "node 10.200.2.$n:"
#	echo -e "\n"
	sudo /opt/ibm/toolscenter/asu/asu64 immapp showimmlog --host 10.200.2.$n --user admin --password $(cat /etc/imm.pass) | grep 'Severity:3\|Severity:4' | sed "s/^/node 10.200.1.$n:  /" & 
done

wait

echo "Done."
