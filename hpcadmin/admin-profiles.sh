#!/bin/bash

install --owner=hpcadmin --group=hpcadmin --mode=700 -d /hpcadmin/.history
install --owner=hpcadmin --group=hpcadmin --mode=600 .bashrc /hpcadmin/
install --owner=hpcadmin --group=hpcadmin --mode=600 .bash_aliases /hpcadmin/
install --owner=hpcadmin --group=hpcadmin --mode=600 .bash_profile /hpcadmin/

install --owner=root --group=root --mode=700 -d /root/.history
install --owner=root --group=root --mode=600 .bashrc.root /root/.bashrc
install --owner=root --group=root --mode=600 .bash_aliases /root/
install --owner=root --group=root --mode=600 .bash_profile /root/

