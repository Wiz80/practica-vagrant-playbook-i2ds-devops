#!/bin/bash

# add test user

username="test"

password="strongpasswordhere"

pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)

sudo useradd -m -s /bin/bash -p "$pass" "$username"

echo "%$username ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/test
