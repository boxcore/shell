#!/bin/bash
#########################################
#Function:    解决da面板ip动态变化自动退出问题
#website:     www.boxcore.org
#Version:     0.1
#########################################

#Disable SeLinux
DA_CONF='/usr/local/directadmin/conf/directadmin.conf'

if [ -z $DA_CONF ]; then
echo "$DA_CONF don't exists!"
fi

DA_CONF_DYNIP_CHECK=`cat $DA_CONF | grep disable_ip_check`

if [ -z "$DA_CONF_DYNIP_CHECK" ]
then

cat >> $DA_CONF <<EOF
disable_ip_check=1
EOF
echo "add disable_ip_check=1 success!"
/sbin/service directadmin restart
echo "directadmin start done"

else
echo "disable_ip_check already set!"
sed -i 's/disable_ip_check=0/disable_ip_check=1/g' $DA_CONF

fi


