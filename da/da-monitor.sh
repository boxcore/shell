#!/bin/bash
directadmin=`ps -ef|grep directadmin | grep "/usr" | awk -F " " '{print $2}'`
exim=`ps -ef|grep exim | grep "/usr" | awk -F " " '{print $2}'`
httpd=`ps -ef|grep httpd | grep "/usr" | awk -F " " '{print $2}'`
mysqld=`ps -ef|grep mysqld | grep "/usr" | awk -F " " '{print $2}'`
proftpd=`ps -ef|grep proftpd | grep "accepting" | awk -F " " '{print $2}'`
named=`ps -ef|grep named | grep "\-u" | awk -F " " '{print $2}'`

if [ -z "$directadmin" ]
then
/sbin/service directadmin restart
echo "directadmin start done"

else
echo "directadmin shell is running"

fi


if [ -z "$exim" ]
then
/sbin/service exim restart
echo "exim start done"

else
echo "exim shell is running"

fi



if [ -z "$httpd" ]
then
/sbin/service httpd restart
echo "httpd start done"

else
echo "httpd shell is running"
fi

if [ -z "$mysqld" ]
then
/sbin/service mysqld restart
echo "mysqld start done"

else
echo "mysqld shell is running"

fi

if [ -z "$proftpd" ]
then
/sbin/service proftpd restart
echo "proftpd start done"

else
echo "proftpd shell is running"

fi



if [ -z "$named" ]
then
/sbin/service named restart
echo "named start done"

else
echo "named shell is running"

fi

# check shadowsocks
shadowsocks=`ps -ef|grep shadowsocks | grep "\-c" | awk -F " " '{print $2}'`
if [ -z "$shadowsocks" ]
then
/sbin/service shadowsocks restart
echo "shadowsocks start done"

else
echo "shadowsocks shell is running"

fi

