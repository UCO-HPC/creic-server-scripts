#!/bin/bash

<< comment
# Left side of B6
for n in {1..36};
do
	sudo /opt/ibm/toolscenter/asu/asu64 set BootOrder.BootOrder "PXE Network" --host 10.200.1.$n --user admin --password $(cat /etc/imm.pass) | sed "s/^/[node 10.200.1.$n]:  /" &
	sudo /opt/ibm/toolscenter/asu/asu64 set BootModes.QuietBoot Disable --host 10.200.1.$n --user admin --password $(cat /etc/imm.pass) | sed "s/^/[node 10.200.1.$n]:  /" &
	sudo /opt/ibm/toolscenter/asu/asu64 set BootModes.SystemBootMode "UEFI Only" --host 10.200.1.$n --user admin --password $(cat /etc/imm.pass) | sed "s/^/[node 10.200.1.$n]:  /" &
done

# High mem nodes (left side of B6)
for n in {1..6}
do
	sudo /opt/ibm/toolscenter/asu/asu64 set BootOrder.BootOrder "PXE Network" --host 10.200.64.$n --user admin --password $(cat /etc/imm.pass) | sed "s/^/[node 10.200.64.$n]:  /" &
        sudo /opt/ibm/toolscenter/asu/asu64 set BootModes.QuietBoot Disable --host 10.200.64.$n --user admin --password $(cat /etc/imm.pass) | sed "s/^/[node 10.200.64.$n]:  /" &
        sudo /opt/ibm/toolscenter/asu/asu64 set BootModes.SystemBootMode "UEFI Only" --host 10.200.64.$n --user admin --password $(cat /etc/imm.pass) | sed "s/^/[node 10.200.64.$n]:  /" &

# Right side of B6
for n in {1..42};
do
	sudo /opt/ibm/toolscenter/asu/asu64 set BootOrder.BootOrder "PXE Network" --host 10.200.2.$n --user admin --password $(cat /etc/imm.pass) | sed "s/^/[node 10.200.2.$n]:  /" &
	sudo /opt/ibm/toolscenter/asu/asu64 set BootModes.QuietBoot Disable --host 10.200.2.$n --user admin --password $(cat /etc/imm.pass) | sed "s/^/[node 10.200.2.$n]:  /" &
	sudo /opt/ibm/toolscenter/asu/asu64 set BootModes.SystemBootMode "UEFI Only" --host 10.200.2.$n --user admin --password $(cat /etc/imm.pass) | sed "s/^/[node 10.200.2.$n]:  /" &
done
comment

# Left side of A6
for n in {20..21};
do
	sudo /opt/ibm/toolscenter/asu/asu64 set BootOrder.BootOrder "PXE Network" --host 10.200.3.$n --user admin --password $(cat /etc/imm.pass) | sed "s/^/[node 10.200.3.$n]:  /" &
        sudo /opt/ibm/toolscenter/asu/asu64 set BootModes.QuietBoot Disable --host 10.200.3.$n --user admin --password $(cat /etc/imm.pass) | sed "s/^/[node 10.200.3.$n]:  /" &
        sudo /opt/ibm/toolscenter/asu/asu64 set BootModes.SystemBootMode "UEFI Only" --host 10.200.3.$n --user admin --password $(cat /etc/imm.pass) | sed "s/^/[node 10.200.3.$n]:  /" &
done

wait

exit
