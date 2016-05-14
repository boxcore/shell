#/bin/bash

mv /etc/init.d/iptables /etc/init.d/iptables.backup
cp iptables /etc/init.d/iptables
chmod 755 /etc/init.d/iptables
/etc/init.d/iptables restart
cp block_ip.sh /usr/local/directadmin/scripts/custom/block_ip.sh
cp show_blocked_ips.sh /usr/local/directadmin/scripts/custom/show_blocked_ips.sh
cp unblock_ip.sh /usr/local/directadmin/scripts/custom/unblock_ip.sh
cp brute_force_notice_ip.sh /usr/local/directadmin/scripts/custom/brute_force_notice_ip.sh
chmod 700 /usr/local/directadmin/scripts/custom/*.sh
touch /root/blocked_ips.txt
touch /root/exempt_ips.txt
