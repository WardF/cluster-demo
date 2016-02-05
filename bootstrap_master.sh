#!/bin/bash
#
# Boostrap a beowulf cluster node.
# Parameterized to determine if it's a master node or not.
#

set -e
set -u

DOHELP()
{
    echo ""
    echo "Usage: $0 [option]"
    echo -e "\t-h\tThis Dialog"
    echo -e "\t-m\tCreate a master node."
    echo ""
}

ISMASTER=""

##
# Parse options
##

while getopts "th" o; do
    case "${o}" in
        t)
            ISMASTER="TRUE"
            ;;
        *)
            DOHELP
            exit 0
            ;;
    esac
done


apt-get update
export DEBIAN_FRONTEND=noninteractive

apt-get -y -q install nfs-common nfs-kernel-server

##
# Concatonate local_hosts.txt onto /etc/hosts
##
cat /vagrant/local_hosts.txt >> /etc/hosts

##
# Create an mpi user
##
useradd -ms /bin/bash -u 999 mpiuser
echo "mpiuser ALL=NOPASSWD: ALL" >> /etc/sudoers
sudo -u mpiuser ssh-keygen -t rsa -N "" -f /home/mpiuser/.ssh/id_rsa
chown -R mpiuser:mpiuser /home/mpiuser


if [ "x$ISMASTER" != "x" ]; then
    ##
    # Make mpiuser home directory a shared directory.
    ##
    echo "# In the future, when this is file changes, " >> /etc/exports
    echo "# run 'sudo exportfs -a'" >> /etc/exports
    echo "/home/mpiuser *(rw,sync,no_subtree_check)" >> /etc/exports
    service nfs-kernel-server restart
fi
