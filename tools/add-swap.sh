#!/bin/bash

# add swap
dd if=/dev/zero of=/swapfile bs=1024 count=1024k
mkswap /swapfile
swapon /swapfile
cat >> /etc/fstab <<EOF
/swapfile swap swap defaults 0 0
EOF
chown root:root /swapfile
chmod 0600 /swapfile

cat >> /etc/sysctl.conf <<EOF
vm.swappiness=10
EOF
