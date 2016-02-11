#!/bin/bash
#
# Delete generated files.

echo "Deleting Generated Files"

set -x
set -e

rm -f Vagrantfile custom_up.sh etc_hosts.txt mpiuser_hosts.txt *~

set +x

echo ""
echo "Finished."
