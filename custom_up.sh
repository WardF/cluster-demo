#!/bin/bash
#
# Utility script to bring up nodes in parallel.
#
#

vagrant up master


xterm -bg black -fg white -e "vagrant up node1 && echo 'Press [Return] to close' && read"
sleep 10


xterm -bg black -fg white -e "vagrant up node2 && echo 'Press [Return] to close' && read"
sleep 10


xterm -bg black -fg white -e "vagrant up node3 && echo 'Press [Return] to close' && read"
sleep 10


xterm -bg black -fg white -e "vagrant up node4 && echo 'Press [Return] to close' && read"
sleep 10


xterm -bg black -fg white -e "vagrant up node5 && echo 'Press [Return] to close' && read"
sleep 10


xterm -bg black -fg white -e "vagrant up node6 && echo 'Press [Return] to close' && read"
sleep 10


xterm -bg black -fg white -e "vagrant up node7 && echo 'Press [Return] to close' && read"
sleep 10


xterm -bg black -fg white -e "vagrant up node8 && echo 'Press [Return] to close' && read"
sleep 10
