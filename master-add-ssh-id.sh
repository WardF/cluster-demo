#!/usr/bin/expect -f
#
# Script to make ssh-copy-id seamless.
#
# Adapted from http://serverfault.com/questions/306541/automating-ssh-copy-id

spawn ssh-copy-id -i /home/mpiuser/.ssh/id_rsa.pub mpiuser@localhost
expect "(yes/no)?"
send "yes\n"
expect "password:"
send "password1234\n"
expect eof
