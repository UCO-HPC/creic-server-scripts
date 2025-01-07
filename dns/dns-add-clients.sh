#!/bin/bash

# Gets file as argument
#file="$1"

echo "WARNING: Running this script creates a \"hpc.uco.edu.backup\" file of the CURRENT DNS entry list and will OVERWRITE the previous backup file!"
echo -n "Proceed? (y) (n): "

read proceed
if [[ "${proceed,}" == "n" ]]
then 
	exit
fi

# Create a backup of the current DNS entry list
cp /var/named/hpc.uco.edu /var/named/hpc.uco.edu.backup

echo "Would you like to add a single server (1) or a range of servers (2) ?"
echo "Enter 1 or 2:"
read option

# Make sure input is provided else die with an error
if [[ "$option" == "" ]]
then
    echo "$0 - Input is missing."
    exit 1
fi

# The regular expression matches digits only
if [[ "$option" =~ ^[0-9]+$ || "$option" =~ ^[-][0-9]+$  ]]

then
   :
else
    echo "$0 - $option is NOT an integer. Please enter integers only."

    exit
fi

# Gets serial number
serial="$(awk "NR==3{print;exit}" /var/named/hpc.uco.edu | awk -v RS='[0-9]+' '$0=RT')"

# Increment serial number
echo 'Serial is: '$serial', incrementing it to '$((serial+=1))
#echo $serial

# Creates header
# header="$(head -n 12 /var/named/hpc.uco.edu.save)"

# 12 lines in header
header="\$TTL 1d
@               IN      SOA     dns.hpc.uco.edu.    hpc.uco.edu. (
                        "$serial"       ; serial
        6h       ; refresh after 6 hours
        1h       ; retry after 1 hour
        1w       ; expire after 1 week
        1d )     ; minimum TTL of 1 day


        IN  NS      dns.hpc.uco.edu.
        IN  NS      dns2.hpc.uco.edu.
        "

# echo $header

# 15 lines in footer
footer="

_kerberos-master._tcp.hpc.uco.edu. 3600 IN SRV 0 100 88 ipa.hpc.uco.edu.
_kerberos-master._udp.hpc.uco.edu. 3600 IN SRV 0 100 88 ipa.hpc.uco.edu.
_kerberos._tcp.hpc.uco.edu. 3600 IN SRV 0 100 88 ipa.hpc.uco.edu.
_kerberos._udp.hpc.uco.edu. 3600 IN SRV 0 100 88 ipa.hpc.uco.edu.
_kerberos.hpc.uco.edu. 3600 IN TXT \"HPC.UCO.EDU\"
_kerberos.hpc.uco.edu. 3600 IN URI 0 100 \"krb5srv:m:tcp:ipa.hpc.uco.edu.\"
_kerberos.hpc.uco.edu. 3600 IN URI 0 100 \"krb5srv:m:udp:ipa.hpc.uco.edu.\"
_kpasswd._tcp.hpc.uco.edu. 3600 IN SRV 0 100 464 ipa.hpc.uco.edu.
_kpasswd._udp.hpc.uco.edu. 3600 IN SRV 0 100 464 ipa.hpc.uco.edu.
_kpasswd.hpc.uco.edu. 3600 IN URI 0 100 \"krb5srv:m:tcp:ipa.hpc.uco.edu.\"
_kpasswd.hpc.uco.edu. 3600 IN URI 0 100 \"krb5srv:m:udp:ipa.hpc.uco.edu.\"
_ldap._tcp.hpc.uco.edu. 3600 IN SRV 0 100 389 ipa.hpc.uco.edu.
ipa-ca.hpc.uco.edu. 3600 IN A 10.202.208.15

;===================================================================="

# echo $footer


# Gets number of lines in file
linecount="$(wc -l < /var/named/hpc.uco.edu)"
start=12
end=$((linecount-15))

# Existing entries will start from line (lines in header + 1) to (linecount - lines in footer)
existingEntries="$(sed -n "$start","$end"\p /var/named/hpc.uco.edu)"
# echo $existingEntries

if [[ $option -eq 1 ]]
then
        echo "Option 1 selected."
        echo "Enter the server name:"
        read serverName

        echo "Enter the last two octets (ex: 208.10):"
        read lastTwoOctets

        echo '
        Server:     '$serverName'
        (1) IPMI:           10.200.'$lastTwoOctets'
        (2) IB:         10.201.'$lastTwoOctets'
        (3) OOB:        10.202.'$lastTwoOctets'
        '

        echo "Choose the default DNS entry: (1), (2), or (3):"
        read defaultChoice

        if [[ "$defaultChoice" =~ ^[0-9]+$ || "$defaultChoice" =~ ^[-][0-9]+$  ]]

        then
           :
        else
            echo "$0 - $defaultChoice is NOT an integer. Please enter integers only."
            exit
        fi

        case $defaultChoice in

        1)
                defaultEntry="10.200."$lastTwoOctets
                echo "Default entry will be IPMI"
                ;;

        2)
                defaultEntry="10.201."$lastTwoOctets
                echo "Default entry will be IB"
                ;;

        3)
                defaultEntry="10.202."$lastTwoOctets
                echo "Default entry will be OOB"
                ;;

        *)
                ;;
        esac


        echo "Confirm? (Y) (N):"
        read confirm

        # Converts input to lowercase
        if [[ "${confirm,}" == "n" ]]; then
                exit
        fi

        echo "Adding DNS entry..."

        # Append this to existing entries
        existingEntries=""$existingEntries"

"$serverName"           IN      A       "$defaultEntry"
"$serverName".ipmi      IN      A       10.200."$lastTwoOctets"
"$serverName".ib        IN      A       10.201."$lastTwoOctets"
"$serverName".oob       IN      A       10.202."$lastTwoOctets""

        filecontents="$(echo "$header ""$existingEntries ""$footer")"

	# Comment out first line when testing output
        echo "$filecontents" > /var/named/hpc.uco.edu
	# echo "$filecontents" > test-output.txt

        echo "Restart named service? (Y) (N)"
        read confirm

        if [[ "${confirm,}" == "y" ]]; then
        	sudo systemctl restart named
        	echo "named restarted"
	fi

	echo "Done."

fi

if [[ $option -eq 2 ]]

        if [ "$#" -eq 0 ]
	then
  		echo "No CSV file supplied"
  		exit 1
	fi

	then
        file="$1"

        echo "Option 2 selected."
        echo "Ensure that the Alternate Username is included in the list:"
        echo " "
        echo "View CSV file? (y) (n)"
        read view

        if [[ "${view}" == "y" ]]
        then
                cat $1

                echo "Proceed? (y) (n)"
                read proceed
                if [[ "$proceed" == "n" ]]
                then
                        exit
                fi
        fi

        echo "Adding DNS entries..."

        while IFS="," read -r creic_name mac_imm mac_eno1 mac_eno2 node_name rack_pos network_names rack_name
        do
				octet_B=${node_name:5:1}
				octet_C=${node_name:6:2}
				lastTwoOctets="$(echo "$octet_B"".""$octet_C")"
				lastTwoOctets=${lastTwoOctets//".0"/"."}
				
                # Append this to existing entries
                existingEntries=""$existingEntries"

"$node_name"           IN      A       10.201."$lastTwoOctets"
"$node_name".ipmi      IN      A       10.200."$lastTwoOctets"
"$node_name".ib        IN      A       10.201."$lastTwoOctets"
"$node_name".oob       IN      A       10.202."$lastTwoOctets""

        done < <(tail -n +3 "$file")

        filecontents="$(echo "$header ""$existingEntries ""$footer")"

        # Comment out first line when testing output
	echo "$filecontents" > /var/named/hpc.uco.edu
	# echo "$filecontents" > test-output.txt


	echo "Restart named service? (Y) (N)"
        read confirm

        if [[ "${confirm,}" == "y" ]]; then
                sudo systemctl restart named
        	echo "named restarted"
	fi
	echo "Done."
fi
