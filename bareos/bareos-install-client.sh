#!/bin/bash
# BareOS Client Installation Script by Ryan Maher
# Installs BareOS file daemon and creates director config file.
# WARNING: An inexperienced bash scripter scripted this script, so use with caution!

echo "Enter standard storage password:"
read pass

sudo sh ./add_bareos_repositories.sh
sudo dnf install -y bareos-filedaemon

echo 'Director {
  Name = "bareos-dir"
  Password = '"\"${pass}\""'
}
' > /etc/bareos/bareos-fd.d/director/bareos-dir.conf

echo "Created file: /etc/bareos/bareos-fd.d/director/bareos-dir.conf"
systemctl enable --now bareos-fd
echo "Enabled bareos-fd daemon"
