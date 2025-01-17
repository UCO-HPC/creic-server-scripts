#!/bin/bash

#########################
##  UCO HPC
##  Script to build images with Mock
##  by Brad Paynter
#########################

################################################################################
# Help                                                                         #
################################################################################
Help()
{
   # Display Help
   echo "Script to build images with Mock."
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
code="2025-01-09"
verbose=0

# Check arguments
while [ $# -gt 0 ]; do
  case $1 in
        -v | --verbose)  verbose=1;;

        -h | --help)     # display Help
                         Help
                         exit;;

        --ip=* | --ip)   if has_equal_argument $@; then
                             ipCD=$(extract_equal_argument $@)
                         elif has_space_argument $@; then
                             ipCD=$2
                             shift
                         else
                             echo "IP not specified." >&2
                             echo
                             Help
                             exit 1
                         fi

                         if [[ ! $(check_ip $ipCD) -eq 1 ]]; then
                            echo "Invalid IP. Only give the last two octets of the IP." >&2
                            echo "E.g., --ip=208.15, not --ip=10.202.208.15"
                            exit 1
                         fi
                         ;;

        --interface*)    if has_equal_argument $@; then
                             oob_int=$(extract_equal_argument $@)
                         elif has_space_argument $@; then
                             oob_int=$2
                             shift
                         fi;;

        --ipmi*)         if has_equal_argument $@; then
                             ipmi_int=$(extract_equal_argument $@)
                         elif has_space_argument $@; then
                             ipmi_int=$2
                             shift
                         else
                             ipmi_int=eno5
                         fi;;

        *)               echo "Unknown Argument $1" >&2
                         echo
                         Help
                         exit 1;;
  esac
  shift
done

su -l installer -c "mock -r /opt/creic-server-scripts/mock/compute-node.cfg --rootdir=/var/lib/mock/compute-node-${code}/ --clean --scrub=all"
su -l installer -c "mock -r /opt/creic-server-scripts/mock/compute-node.cfg --rootdir=/var/lib/mock/compute-node-${code}/ --init"
su -l installer -c "mock -r /opt/creic-server-scripts/mock/compute-node.cfg --rootdir=/var/lib/mock/compute-node-${code}/ --remove selinux-policy"
wwctl container import --force /var/lib/mock/compute-node-$code compute-node-$code
chmod u+w /var/lib/warewulf/chroots/compute-node-${code}/rootfs
wwctl container syncuser --write --build compute-node-$code
