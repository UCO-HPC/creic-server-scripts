#!/bin/bash

#########################
##  UCO HPC
##  Script to install custom dracut scripts
##  by Brad Paynter
#########################

################################################################################
# Help                                                                         #
################################################################################
Help()
{
   # Display Help
   echo "Script to install custom dracut scripts."
   echo
   echo "Syntax: install-dracut-scripts [options] [connections]"
   echo "options:"
   echo "-h --help           Print this Help."
   echo "-v --verbose        Verbose mode."
   echo
   echo "--ip=C.D            The last two octets of the IPv4 for this node."
   echo "--interface=enoX    The interface for the OOB network. (default: eno2)"
   echo "--ipmi[=enoX]       The interface for the IPMI network master connection. (default: eno5 or None if flag not given)"
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
ipA=10
ipB_oob=202
ipB_ipmi=200
ipCD=None
gatewayCD=224.1
subnet_mask=255.255.0.0
subnet_bits=16
dns=10.202.208.88
oob_int=eno2
ipmi_int=None
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

# Check if an IP address was given
if [ "$ipCD" == "None" ]
  then
    echo "ERROR: IP Address required"
    echo
    Help
    exit 1
fi

echo "Using IPv4 $ipA.$ipB_oob.$ipCD for OOB network."
echo "Using $oob_int as OOB interface."

# Setup and install Dracut Static IP Config
cp ./20-static-ip.conf /tmp/
perl -pi -e "s/<IP>/$ipA.$ipB_oob.$ipCD/" /tmp/20-static-ip.conf
perl -pi -e "s/<GATEWAY>/$ipA.$ipB_oob.$gatewayCD/" /tmp/20-static-ip.conf
perl -pi -e "s/<MASK>/$subnet_mask/" /tmp/20-static-ip.conf
perl -pi -e "s/<INT>/$oob_int/" /tmp/20-static-ip.conf
perl -pi -e "s/<DNS>/$dns/" /tmp/20-static-ip.conf
install --owner=root --group=root --mode=644 /tmp/20-static-ip.conf /etc/dracut.conf.d/
rm /tmp/20-static-ip.conf
install --owner=root --group=root --mode=644 ./99-cmdline.conf /etc/dracut.conf.d/
dracut -f --regenerate-all

# Setup and install flush-dracut service for OOB
chmod u+x ./flush-dracut-network.sh
install --owner=root --group=root --mode=644 ./flush-dracut-network@.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable flush-dracut-network@$oob_int

# Setup and install OOB network
rm /etc/NetworkManager/system-connections/$oob_int.nmconnection
cp ./oob.nmconnection /tmp/
perl -pi -e "s/<INT>/$oob_int/" /tmp/oob.nmconnection
perl -pi -e "s/<IP>/$ipA.$ipB_oob.$ipCD/" /tmp/oob.nmconnection
perl -pi -e "s/<SUBNET_BITS>/$subnet_bits/" /tmp/oob.nmconnection
perl -pi -e "s/<GATEWAY>/$ipA.$ipB_oob.$gatewayCD/" /tmp/oob.nmconnection
perl -pi -e "s/<DNS>/$dns/" /tmp/oob.nmconnection
install --owner=root --group=root --mode=600 /tmp/oob.nmconnection /etc/NetworkManager/system-connections/
rm /tmp/oob.nmconnection

if [ ! "$ipmi_int" == "None" ]; then
  echo "Using IPv4 $ipA.$ipB_ipmi.$ipCD for IPMI network."
  echo "Using $ipmi_int as IPMI master interface."

  # Setup and install IPMI network
  rm /etc/NetworkManager/system-connections/$ipmi_int.nmconnection
  cp ./ipmi.nmconnection /tmp/
  perl -pi -e "s/<INT>/$ipmi_int/" /tmp/ipmi.nmconnection
  perl -pi -e "s/<IP>/$ipA.$ipB_ipmi.$ipCD/" /tmp/ipmi.nmconnection
  perl -pi -e "s/<SUBNET_BITS>/$subnet_bits/" /tmp/ipmi.nmconnection
  perl -pi -e "s/<GATEWAY>/$ipA.$ipB_ipmi.$gatewayCD/" /tmp/ipmi.nmconnection
  perl -pi -e "s/<DNS>/$dns/" /tmp/ipmi.nmconnection
  install --owner=root --group=root --mode=600 /tmp/ipmi.nmconnection /etc/NetworkManager/system-connections/
  rm /tmp/ipmi.nmconnection
fi

exit
