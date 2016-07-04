#!/bin/bash

xvdb=$(fdisk -l|grep "/dev/xvdb")
Judge=0
if [ "$xvdb" = "" ]; then
    exit 1
else
    mounted_xvdb=$(df -h|grep "xvdb")

    if [ "$mounted_xvdb" = "" ]; then
        lvchange -a y /dev/mapper/Xvdbgroup-xvdb1
        mount /dev/mapper/Xvdbgroup-xvdb1 /home
        resize2fs -p /dev/mapper/Xvdbgroup-xvdb1
    fi

fi
