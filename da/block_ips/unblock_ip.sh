#!/bin/sh

BF=/root/blocked_ips.txt
OS=`uname`;

if [ "$ip" = "" ]; then
        echo "Usage:";
        echo "  $0 1.2.3.4";
        exit 1;
fi

if [ ! -e "$BF" ]; then
        echo "cannot find $BF to unblock the IP";
        exit 2;
fi

COUNT=`grep -c "^$ip=" $BF`;

if [ "$COUNT" -eq 0 ]; then
        echo "$1 was not in $BF. Not unblocking";
        exit 2;
fi

#unblock.
echo "Unblocking $ip ...";

cat $BF | grep -v "^$ip=" > $BF.temp
mv $BF.temp $BF

chmod 600 $BF

if [ "$OS" = "FreeBSD" ]; then
	/sbin/ipfw -q table 10 delete $ip
else
	echo "Restarting iptables ...<br>";
	/etc/init.d/iptables restart
	#echo "Unblocking ip ...<br>";
	#/sbin/iptables -D INPUT -s $ip -j DROP
fi

exit 0;

