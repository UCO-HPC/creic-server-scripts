#!/bin/bash

echo "Enter server name (lowercase):"
read servername

echo 'Device {
  Name = '"${servername^}"'FileStorage
  Media Type = File
  Archive Device = /mnt/backup/bareos/'"${servername}"'
  LabelMedia = yes;                   # lets Bareos label unlabeled media
  Random Access = yes;
  AutomaticMount = yes;               # when device opened, read it
  RemovableMedia = no;
  AlwaysOpen = no;
  Description = "File device. A connecting Director must have the same Name and MediaType."
}
' > /etc/bareos/bareos-sd.d/device/"${servername^}"FileStorage

echo "Storage device configured at /etc/bareos/bareos-sd.d/device/"${servername^}"FileStorage
