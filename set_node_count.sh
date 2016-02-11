#!/bin/bash
#
# Utility script to set number of nodes in Vagrant configuration.
#
# Here's what needs to be updated:
#
# 1. Vagrantfile (Using vagrantfile.in
# 2. mpiuser_hosts.txt
# 3. etc_hosts.txt
# 4. custom_up.txt
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
# Status message
##
echo "Configuring cluster of $TOTNODE nodes."

##
# First, do Vagrantfile.
##
echo "o Creating Vagrantfile"
sed "s/xxnodecount/$TOTNODE/g" Vagrantfile.in > Vagrantfile

##
# Next mpiuser_hosts.txt
##

rm -f mpiuser_hosts.txt
echo "o Creating mpiuser_hosts.txt"

COUNTER=1

while [ $COUNTER -le $TOTNODE ]; do
    echo "node$COUNTER" >> mpiuser_hosts.txt
    let COUNTER=COUNTER+1
done

##
# Create etc_hosts.txt
##

echo "o Creating etc_hosts.txt"

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

##
# Finally, create custom_up.sh
##

echo "o Creating custom_up.sh"

echo '#!/bin/bash' > custom_up.sh
echo '#' >> custom_up.sh
echo '# Utility script to bring up nodes in parallel.' >> custom_up.sh
echo "" >> custom_up.sh

echo 'vagrant up master' >> custom_up.sh
echo "" >> custom_up.sh

COUNTER=1

while [ $COUNTER -le $TOTNODE ]; do

    echo "xterm -bg black -fg white -e \"vagrant up node$COUNTER && echo 'Press [Return] to close' && read\" &" >> custom_up.sh
    echo "sleep 10" >> custom_up.sh
    echo "" >> custom_up.sh

    let COUNTER=COUNTER+1
done

echo ""
