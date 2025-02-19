#!/bin/bash

#########################
##  UCO HPC
##  Script to reboot a range of nodes, 
##  with pauses between so as to not overwhelm the WareWulf server
##  by Brad Paynter
#########################

################################################################################
# Help                                                                         #
################################################################################
Help()
{
   # Display Help
   echo "Script to reboot a range of nodes, with pauses between so as to not overwhelm the WareWulf server"
   echo
   echo "Syntax: reboot-nodes.sh [options] NODE_RANGE"
   echo "options:"
   echo "-h --help           Print this Help."
   echo "-v --verbose        Verbose mode."
   echo
   echo "--pause=p           The length of time to pause between commands. Default: 20s."
   echo "--prefix=pre        The prefix for node names. Default: 'node-'"
   echo
   echo "NODE_RANGE          The range of node numbers to reboot. Use '20[4-6]' format. Do NOT include the prefix."
   echo
}

################################################################################
# Argument Helper Functions                                                    #
################################################################################

# From: https://medium.com/@wujido20/handling-flags-in-bash-scripts-4b06b4d0ed04
has_equal_argument() {
    [[ ("$1" == *=* && -n ${1#*=}) ]];
}

has_space_argument() {
    [[ ( ! -z "$2" && "$2" != -*) ]]
}
# From: https://medium.com/@wujido20/handling-flags-in-bash-scripts-4b06b4d0ed04
extract_equal_argument() {
  echo "${1#*=}"
}

################################################################################
################################################################################
# Main program                                                                 #
################################################################################
################################################################################

# Set defaults
pause="20s"
prefix="node-"

# Check arguments
while [ $# -gt 0 ]; do
  case $1 in
    -v | --verbose)  verbose=1;;

    -h | --help)     # display Help
                     Help
                     exit;;

    --pause*)        if has_equal_argument $@; then
                       pause=$(extract_equal_argument $@)
                     elif has_space_argument $@; then
                       pause=$2
                       shift
                     fi;;

    --prefix*)        if has_equal_argument $@; then
                       prefix=$(extract_equal_argument $@)
                     elif has_space_argument $@; then
                       prefix=$2
                       shift
                     fi;;

    *)               nodes=$@
  esac
  shift
done

if [ $(whoami) != "root" ]
then
  echo "This script must be run as root."
  exit 1
fi

# Parse NODE-RANGE into a space-separated list
# From: https://unix.stackexchange.com/questions/576776/parsing-ranges-into-discrete-values-in-bash
H0=${nodes//$prefix/}
H1=${H0//[/{}
H2=${H1//]/\}}
H3=${H2//,/ }
nodelist=$(eval echo ${H3//-/..})

for n in $nodelist
do
  wwctl power cycle $prefix$n
  sleep $pause
done
