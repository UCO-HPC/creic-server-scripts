#!/bin/bash

#########################
##  UCO HPC
##  Script to install dynamic MotD for servers
##  by Brad Paynter
#########################

################################################################################
# Help                                                                         #
################################################################################
Help()
{
   # Display Help
   echo "Script to install dynamic system info MotD for servers."
   echo
   echo "Syntax: install-system-info-motd [options]"
   echo "options:"
   echo "-h --help           Print this Help."
   echo "-v --verbose        Verbose mode."
   echo
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

# From: https://stackoverflow.com/questions/16679369/count-occurrences-of-a-char-in-a-string-using-bash
check_ip() {
    var=$1
    res="${var//[^.]}"
    echo "${#res}"
}

################################################################################
################################################################################
# Main program                                                                 #
################################################################################
################################################################################

# Set defaults
verbose=0

# Check arguments
while [ $# -gt 0 ]; do
  case $1 in
        -v | --verbose)  verbose=1;;

        -h | --help)     # display Help
                         Help
                         exit;;

        *)               echo "Unknown Argument $1" >&2
                         echo
                         Help
                         exit 1;;
  esac
  shift
done

# Setup and install flush-dracut service for OOB
mkdir -p /usr/lib/creic
install --owner=root --group=root --mode=744 ./system-info-motd.sh /usr/lib/creic/
install --owner=root --group=root --mode=644 ./system-info-motd.service /etc/systemd/system/
install --owner=root --group=root --mode=644 ./every-ten-min.timer /etc/systemd/system/
systemctl daemon-reload
systemctl enable --now system-info-motd.service
systemctl enable --now every-ten-min.timer


exit
