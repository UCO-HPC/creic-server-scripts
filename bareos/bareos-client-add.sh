#!/bin/bash
# BareOS Client Script by Ryan Maher
# Only adds config files to BareOS director, requires set up on client server.
# WARNING: An inexperienced bash scripter scripted this script, so use with caution!

echo "Adding BareOS Client"
echo "Enter server name (lowercase)"
read servername
echo "Enter server address"
read serveraddress
echo "Enter storage server address"
read storageaddress
echo "Enter standard storage password"
read pass
echo "Paste director storage password (from director config on storage server)"
read dirpass

echo "Adding $servername at $serveraddress with storage address ${storageaddress}"
echo "proceed? (y/n)"
read continue

if [[ "$continue" == "n" ]]; then
	exit
fi

echo 'Storage {
  Name = '"${servername^}"'Storage
  Address = '"\"${storageaddress}\""' # storage IP address
  Password = '"\"${dirpass}\""'
  Device = '"${servername^}"'FileStorage
  Media Type = File
}
' > /etc/bareos/bareos-dir.d/storage/${servername^}Storage.conf

echo 'JobDefs {
  Name = '"${servername^}"'Job
  Type = Backup
  Level = Incremental
  Client = '"${servername}"'-fd
  FileSet = "Full Set"
  Schedule = "WeeklyCycle"
  Storage = '"${servername^}"'Storage
  Messages = Standard
  Pool = Inc-Pool
  Priority = 10
  Write Bootstrap = "/var/lib/bareos/%c.bsr"
  Full Backup Pool = Full-Pool
  Differential Backup Pool = Diff-Pool
  Incremental Backup Pool = Inc-Pool
}
' > /etc/bareos/bareos-dir.d/jobdefs/${servername^}Job.conf

echo 'Job {
  Name = '"${servername}"'
  Client = '"${servername}"'-fd
  JobDefs = '"${servername^}"'Job
  FileSet = "Full Set"
}
' > /etc/bareos/bareos-dir.d/job/${servername}.conf

echo 'Client {
  Name = '"${servername}"'-fd
  Address = '"\"${serveraddress}\""'
  Password = '"\"${pass}\""'
}
' > /etc/bareos/bareos-dir.d/client/${servername}-fd.conf

echo "Files created:"
echo '/etc/bareos/bareos-dir.d/storage/'"${servername^}"'Storage.conf
/etc/bareos/bareos-dir.d/jobdefs/'"${servername^}"'Job.conf
/etc/bareos/bareos-dir.d/job/'"${servername}"'.conf
/etc/bareos/bareos-dir.d/client/'"${servername}"'-fd.conf'
