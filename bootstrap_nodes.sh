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

apt-get -y -q install nfs-common nfs-kernel-server sshpass expect git ubuntu-dev-tools libtool cmake m4 autoconf zlib1g-dev curl flex bison wget libcurl4-openssl-dev fortran emacs

##
# Concatonate cluster_hosts.txt onto /etc/hosts
##
cat /vagrant/etc_hosts.txt >> /etc/hosts

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

    x=$(HOME=/home/mpiuser sudo -u mpiuser /home/mpiuser/master-add-ssh-id.sh)
fi

echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config

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

fi

###
# If this is the master, we are going to use the Hydra process manager.
# See documentation at:
#   * https://wiki.mpich.org/mpich/index.php/Using_the_Hydra_Process_Manager
#
# This is an mpich2 thing I think.  Dont' know about openmpi.
# We need to create a hosts file in /home/mpiuser/ and then
# set the global environmental variable HYDRA_HOST_FILE to point to it.
# Without this env variable, we have to specify the file with a flag
# any time mpiexec is invoked.
###

# All nodes need mpich2
apt-get install -y libopenmpi-dev openmpi-bin

if [ "x$ISMASTER" != "x" ]; then

    cp /vagrant/mpiuser_hosts.txt /home/mpiuser/hosts
    chown mpiuser:mpiuser /home/mpiuser/hosts

    ##
    # Set up an environmental system-wide variable that will
    # tell the master where the hosts file is for hydra, the mpich2
    # job manager.
    ##
    echo "export HYDRA_HOST_FILE=/home/mpiuser/hosts" >> /etc/bash.bashrc
fi

###
# If this is a compute node, set it up so that
# the nfs mount starts automatically.
###
if [ "x$ISMASTER" == "x" ]; then
    echo "master:/home/mpiuser /home/mpiuser nfs" >> /etc/fstab
fi

###
# Download and install pnetcdf into mpiuser, if master.
###
if [ "x$ISMASTER" != "x" ]; then
    PNET_VER="parallel-netcdf-1.6.1"
    PNET_FILE="$PNET_VER.tar.bz2"
    if [ ! -f "/vagrant/$PNET_FILE" ]; then
        wget http://cucis.ece.northwestern.edu/projects/PnetCDF/Release/$PNET_FILE
        cp "$PNET_FILE" /vagrant
    else
        cp "/vagrant/$PNET_FILE" .
    fi

    tar -jxf $PNET_FILE
    pushd $PNET_VER
    CPPFLAGS="-fPIC" CC=`which mpicc` ./configure --prefix=/home/mpiuser/usr
    make -k install
    popd
    rm -rf $PNET_VER
fi
###
# End pnetcdf
###

###
# Download and install hdf5 into mpiuser, if master.
###

if [ "x$ISMASTER" != "x" ]; then
    HDF5VER="1.8.16"
    HDF5_VER="hdf5-$HDF5VER"
    TARGDIR=/home/mpiuser/usr
    # Install hdf5 from source
    if [ ! -f /usr/lib/libhdf5.settings ]; then
        HDF5_FILE="$HDF5_VER".tar.bz2
        if [ ! -f "/vagrant/$HDF5_FILE" ]; then
	        wget http://www.hdfgroup.org/ftp/HDF5/releases/$HDF5_VER/src/$HDF5_FILE
	        cp "$HDF5_FILE" /vagrant
        else
	        cp "/vagrant/$HDF5_FILE" .
        fi

        tar -jxf $HDF5_FILE
        pushd $HDF5_VER


        CFLAGS="-Wno-format-security" CC=`which mpicc` ./configure --enable-shared --disable-static --disable-fortran --enable-hl --disable-fortran --enable-parallel --prefix="${TARGDIR}"

        make install -j 4
        popd
        rm -rf $HDF5_VER
    fi
fi

###
# Everybody needs to know where the HDF5 stuff is.
###

echo "export C_INCLUDE_PATH=/home/mpiuser/usr/include" >> /etc/bash.bashrc
echo "export CPLUS_INCLUDE_PATH=/home/mpiuser/usr/include" >> /etc/bash.bashrc
echo "export LIBRARY_PATH=/home/mpiuser/usr/lib" >> /etc/bash.bashrc
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/mpiuser/usr/lib' >> /etc/bash.bashrc

###
# End HDF5 Install
###

###
# Cleanup items.
#
# Restart nfs-kernel-server
###
service nfs-kernel-server restart
exportfs -a

###
# Final: If not master, reboot.
###
if [ "x$ISMASTER" == "x" ]; then
    reboot
fi
