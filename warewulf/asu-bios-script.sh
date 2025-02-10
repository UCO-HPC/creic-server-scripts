#!/bin/bash

for n in {1..30};
do
	sudo /opt/ibm/toolscenter/asu/asu64 set BootOrder.BootOrder "PXE Network" --host 10.200.1.$n --user admin --password $(cat /etc/imm.pass) | sed "s/^/[node 10.200.1.$n]:  /" &
	sudo /opt/ibm/toolscenter/asu/asu64 set BootModes.QuietBoot Disable --host 10.200.1.$n --user admin --password $(cat /etc/imm.pass) | sed "s/^/[node 10.200.1.$n]:  /" &
	sudo /opt/ibm/toolscenter/asu/asu64 set BootModes.SystemBootMode "UEFI Only" --host 10.200.1.$n --user admin --password $(cat /etc/imm.pass) | sed "s/^/[node 10.200.1.$n]:  /" &
done

for n in {1..32};
do
	sudo /opt/ibm/toolscenter/asu/asu64 set BootOrder.BootOrder "PXE Network" --host 10.200.2.$n --user admin --password $(cat /etc/imm.pass) | sed "s/^/[node 10.200.2.$n]:  /" &
	sudo /opt/ibm/toolscenter/asu/asu64 set BootModes.QuietBoot Disable --host 10.200.2.$n --user admin --password $(cat /etc/imm.pass) | sed "s/^/[node 10.200.2.$n]:  /" &
	sudo /opt/ibm/toolscenter/asu/asu64 set BootModes.SystemBootMode "UEFI Only" --host 10.200.2.$n --user admin --password $(cat /etc/imm.pass) | sed "s/^/[node 10.200.2.$n]:  /" &
done
