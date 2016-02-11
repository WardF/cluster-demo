#!/bin/bash
#
# Utility script to set number of nodes in Vagrant configuration.
#
# Here's what needs to be updated:
#
# 1. Vagrantfile (Using vagrantfile.in
# 2. mpiuser_hosts.txt
# 3. etc_hosts.txt
#

set -e

DOHELP() {
    echo "You must specify the number of compute nodes to be used in this configuration."
    echo "e.g.:"
    echo -e "\t\$ $0 [nodecount]"
    echo ""
}

if [ $# -ne 1 ]; then
    DOHELP
    exit 0
fi

TOTNODE=$1

##
# First, do Vagrantfile.
##
echo "Creating Vagrantfile"
sed "s/xxnodecount/$TOTNODE/g" Vagrantfile.in > Vagrantfile

##
# Next mpiuser_hosts.txt
##

rm -f mpiuser_hosts.txt
echo "Creating mpiuser_hosts.txt"

COUNTER=1

while [ $COUNTER -le $TOTNODE ]; do
    echo "node$COUNTER" >> mpiuser_hosts.txt
    let COUNTER=COUNTER+1
done

##
# Finally, create etc_hosts.txt
##

echo "Creating etc_hosts.txt"

COUNTER=1


echo '###' > etc_hosts.txt
echo '# Cluster IP list' >> etc_hosts.txt
echo '###' >> etc_hosts.txt
echo "" >> etc_hosts.txt
echo '10.1.2.10 master' >> etc_hosts.txt

while [ $COUNTER -le $TOTNODE ]; do

    echo "10.1.2.$((10+$COUNTER)) node$COUNTER" >> etc_hosts.txt

    let COUNTER=COUNTER+1
done
