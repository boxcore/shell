#!/bin/bash
xvdb=$(fdisk -l|grep "/dev/xvdb")
Judge=0
if [ "$xvdb" = "" ]; then
	exit 1
else
	Partition=$(fdisk -l|grep "/dev/xvdb1")
	cylinders=$(fdisk -l /dev/xvdb|grep cylinders|awk 'NR==1'|awk '{print $5}')
fi
if [ "$cylinders" -eq 0 ]; then
	exit 1
fi
if [ "$Partition" = "" ]; then
cat>>/root/fdisk.sh<<EOF
#!/usr/bin/expect
set timeout 30
spawn	fdisk /dev/xvdb
expect	"Command (m for help):"
send "n\r"
send "p\r"
send "1\r"
expect "First cylinder"
send "\n"
expect "Last cylinder or +size or +sizeM or +sizeK"
send "\n"
expect "Command (m for help):"
send "w\r"
interact
EOF
chmod a+x /root/fdisk.sh
cd /root
./fdisk.sh>>/dev/null
rm -rf /root/fdisk.sh
#<!open server load root>
partx -a /dev/xvdb>>/dev/null
partx -a /dev/xvdb>>/dev/null
vgcreate Xvdbgroup /dev/xvdb1
vgssize=$(vgdisplay Xvdbgroup|grep -i "free"|awk '{print $7}')
num=$(vgdisplay Xvdbgroup|grep -i "free"|awk '{print $8}')
vgnum=$(echo $vgssize 0.1|awk '{print $1 - $2}')
	if [ "$num" = "GB" -o "$num" = "GiB" ]; then
		lvcreate -n xvdb1 -L +$vgnum$num Xvdbgroup
		mkfs.ext3 /dev/mapper/Xvdbgroup-xvdb1>>/dev/null
		mount /dev/mapper/Xvdbgroup-xvdb1 /home
	else
		lvcreate -n xvdb1 -L +$vgssize$num Xvdbgroup
		mkfs.ext3 /dev/mapper/Xvdbgroup-xvdb1>>/dev/null
		mount /dev/mapper/Xvdbgroup-xvdb1 /home
	fi
#<!open server load root>
else
	Judge=1
fi

if [ "$Judge" -eq 1 ]; then
	lvchange -a y /dev/mapper/Xvdbgroup-xvdb1
	mount /dev/mapper/Xvdbgroup-xvdb1 /home
	resize2fs -p /dev/mapper/Xvdbgroup-xvdb1
fi
