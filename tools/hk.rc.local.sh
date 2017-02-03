#!/bin/sh
# file path: /etc/rc.local
# only for centos 6
# This script will be executed *after* all the other init scripts.
# You can put your own initialization stuff in here if you don't
# want to do the full Sys V style init stuff.
/etc/rc.d/init.d/crond restart
/bin/sh /root/shell/tools/hk-mount-check.sh
/etc/rc.d/init.d/nginx restart
/etc/rc.d/init.d/mysql restart
/etc/rc.d/init.d/php-fpm restart
/etc/rc.d/init.d/php-fpm52 restart
/etc/rc.d/init.d/pureftpd restart
/etc/rc.d/init.d/shadowsocks restart
touch /var/lock/subsys/local
sleep 3
