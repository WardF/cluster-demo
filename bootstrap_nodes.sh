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

apt-get -y -q install nfs-common nfs-kernel-server sshpass expect

##
# Concatonate local_hosts.txt onto /etc/hosts
##
cat /vagrant/local_hosts.txt >> /etc/hosts

##
# Create an mpi user
##
useradd -ms /bin/bash -u 999 mpiuser
echo "mpiuser:password1234" | chpasswd
echo "mpiuser ALL=NOPASSWD: ALL" >> /etc/sudoers


# Stuff to permit
# passwordless ssh between
# master and nodes.
if [ "x$ISMASTER" != "x" ]; then
    sudo -u mpiuser ssh-keygen -t rsa -N "" -f /home/mpiuser/.ssh/id_rsa

    cp /vagrant/master-add-ssh-id.sh /home/mpiuser
    chown mpiuser:mpiuser /home/mpiuser/master-add-ssh-id.sh

    sudo -u mpiuser /home/mpiuser/master-add-ssh-id.sh

fi

chown -R mpiuser:mpiuser /home/mpiuser

###
# If this is a master node, set up some nfs stuff.
###
if [ "x$ISMASTER" != "x" ]; then
    ##
    # Make mpiuser home directory a shared directory.
    ##
    echo "# In the future, when this is file changes, " >> /etc/exports
    echo "# run 'sudo exportfs -a'" >> /etc/exports
    echo "/home/mpiuser *(rw,sync,no_subtree_check)" >> /etc/exports
    service nfs-kernel-server restart

    ##
    # Also set up an environmental system-wide variable that will
    # tell the master where the hosts file is for hydra, the mpich2
    # job manager.
    ##
    echo "export HYDRA_HOST_FILE=/home/mpiuser/hosts" >> /etc/bash.bashrc

fi

###
# If this is a master, we are going to use the Hydra process manager.
# See documentation at:
#   * https://wiki.mpich.org/mpich/index.php/Using_the_Hydra_Process_Manager
#
# This is an mpich2 thing I think.  Dont' know about openmpi.
# We need to create a hosts file in /home/mpiuser/ and then
# set the global environmental variable HYDRA_HOST_FILE to point to it.
# Without this env variable, we have to specify the file with a flag
# any time mpiexec is invoked.
###
if [ "x$ISMASTER" != "x" ]; then


fi

###
# If this is a compute node, set it up so that
# the nfs mount starts automatically.
###
if [ "x$ISMASTER" == "x" ]; then
    echo "master:/home/mpiuser /mpiuser nfs" >> /etc/fstab
fi
