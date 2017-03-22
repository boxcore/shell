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
    /etc/rc.d/init.d/nginx restart
/etc/rc.d/init.d/mysql restart
/etc/rc.d/init.d/php-fpm restart
/etc/rc.d/init.d/php-fpm52 restart
/etc/rc.d/init.d/pureftpd restart
/etc/rc.d/init.d/shadowsocks restart
/etc/rc.d/init.d/crond restart
    else
        echo 'already mount!'
    fi

fi
