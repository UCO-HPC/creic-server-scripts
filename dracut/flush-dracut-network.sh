#!/bin/bash

#########################
##  UCO HPC
##  Script to erase dracut's network settings
##  by Brad Paynter
#########################

################################################################################
# Help                                                                         #
################################################################################
Help()
{
   # Display Help
   echo "Script to be run by flush-dracut-network@.service."
   echo "Script will erase Dracut network settings from /run/NetworkManager/system-connections"
   echo
   echo "Syntax: flush-dracut-network [options] [connection]"
   echo "options:"
   echo "-h --help       Print this Help."
   echo "-v --verbose    Verbose mode."
   echo
}

################################################################################
# Flush Connection Function                                                    #
################################################################################
flush_connection()
{
   if [ $2 -gt 0 ]
      then
          echo /usr/sbin/ip -statistics address flush dev $1
   fi
   /usr/sbin/ip -statistics address flush dev $1
   if [ $2 -gt 0 ]
      then
          echo rm /run/NetworkManager/system-connections/$1.nmconnection
   fi
   rm /run/NetworkManager/system-connections/$1.nmconnection
}

################################################################################
################################################################################
# Main program                                                                 #
################################################################################
################################################################################

# Set defaults
connection=0
verbose=0

# Check arguments
while [ $# -gt 0 ]; do
  case $1 in
        -v | --verbose)  verbose=1;;

        -h | --help)     # display Help
                         Help
                         exit;;

        *)               flush_connection $1 $verbose
                         connection=1
  esac
  shift
done

# Check if a network connection was given
if [ $connection -eq 0 ]
  then
    echo "ERROR: Network connection name required"
    echo
    Help
    exit 1
  else
#    if [ $verbose -gt 0 ]
#        then
#              echo systemctl restart NetworkManager
#    fi
#    systemctl restart NetworkManager
    exit
fi
