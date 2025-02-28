#!/bin/bash

#########################
##  UCO HPC
##  Script to build images for WareWulf nodes
##  by Brad Paynter
#########################

################################################################################
# Help                                                                         #
################################################################################
Help()
{
   # Display Help
   echo "Script to build images for WareWulf nodes"
   echo
   echo "Syntax: build-images.sh [options]"
   echo "options:"
   echo "-h --help           Print this Help."
   echo "-v --verbose        Verbose mode."
   echo
   echo "--label=YYYY-MM-DD-hhmm"
   echo "                    The date/time label for the image. Default: Current System Time."
   echo "--image=[ all | base | compute | desktop ]"
   echo "                    Only build one image."
   echo "                    NOTE: This may cause the image to be built with an out-of-date base."
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
image="all"
label=$(date +%Y-%m-%d-%H%M)

color_on='\033[1;32m'
color_off='\033[0m'

# Check arguments
while [ $# -gt 0 ]; do
  case $1 in
    -v | --verbose)  verbose=1;;

    -h | --help)     # display Help
                     Help
                     exit;;

    --label*)        if has_equal_argument $@; then
                       label=$(extract_equal_argument $@)
                     elif has_space_argument $@; then
                       label=$2
                       shift
                     fi;;

    --image*)        if has_equal_argument $@; then
                       image=$(extract_equal_argument $@)
                     elif has_space_argument $@; then
                       image=$2
                       shift
                     fi;;

    *)               echo "Unknown Argument $1" >&2
                     echo
                     Help
                     exit 1;;
  esac
  shift
done

if [ $(whoami) != "hpcadmin" ]
then
  echo "Error: Script must be run as HPCAdmin user."
  exit 1
fi

sudo echo

if [[ ( $image == "all" || $image == "base" ) ]]
then
  echo -e ${color_on} "Building AlmaLinux-9 base image..." ${color_off}
  podman build --pull=newer --no-cache -f /opt/warewulf-node-images/almalinux-9/Containerfile --tag almalinux-9 --tag almalinux-9:$label
fi


if [[ ( $image == "all" || $image == "compute" ) ]]
then
  build="compute"  
fi
if [[ ( $image == "all" || $image == "desktop" ) ]]
then
  build="$build desktop"
fi

for i in $build 
do
  echo -e ${color_on} "Building $i-node image..." ${color_off}
  podman build --no-cache -f /opt/creic-server-scripts/images/almalinux-9/Containerfile-$i-node --tag $i-node --tag $i-node:$label
  podman save localhost/$i-node:latest -o ~/$i-node-$label.tar
  sudo wwctl container import --force file:///hpcadmin/$i-node-$label.tar $i-node-$label
  sudo wwctl container syncuser --write --build $i-node-$label
done
