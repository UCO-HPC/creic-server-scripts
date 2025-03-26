#!/bin/bash

# ASU node error checker script
# Runs parallel ASU commands to connect to a node and return any event logs with high severity

<< comment
# Left side of B6
for n in {1..36};
do
	# echo "node 10.200.1.$n:"
	# echo -e "\n"
	sudo /opt/ibm/toolscenter/asu/asu64 immapp showimmlog --host 10.200.1.$n --user admin --password $(cat /etc/imm.pass) | grep 'Severity:3\|Severity:4' | sed "s/^/node 10.200.1.$n:  /" & 	
done

# High mem nodes (left side of B6)
for n in {1..6};
do
	sudo /opt/ibm/toolscenter/asu/asu64 immapp showimmlog --host 10.200.64.$n --user admin --password $(cat /etc/imm.pass) | grep 'Severity:3\|Severity:4' | sed "s/^/node 10.200.64.$n:  /" &
done

# Right side of B6
for n in {1..42};
do
#	echo "node 10.200.2.$n:"
#	echo -e "\n"
	sudo /opt/ibm/toolscenter/asu/asu64 immapp showimmlog --host 10.200.2.$n --user admin --password $(cat /etc/imm.pass) | grep 'Severity:3\|Severity:4' | sed "s/^/node 10.200.1.$n:  /" & 
done
comment

# Left side of A6
for n in {1..42};
do
#       echo "node 10.200.2.$n:"
#       echo -e "\n"
        sudo /opt/ibm/toolscenter/asu/asu64 immapp showimmlog --host 10.200.3.$n --user admin --password $(cat /etc/imm.pass) | grep 'Severity:3\|Severity:4' | sed "s/^/node 10.200.3.$n:  /" &
done

wait

echo "Done."
exit
