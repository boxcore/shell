#/bin/bash

mv /etc/init.d/iptables /etc/init.d/iptables.backup
mv iptables /etc/init.d/iptables
chmod 755 iptables
/etc/init.d/iptables restart
mv block_ip.sh /usr/local/directadmin/scripts/custom/block_ip.sh
mv show_blocked_ips.sh /usr/local/directadmin/scripts/custom/show_blocked_ips.sh
mv unblock_ip.sh /usr/local/directadmin/scripts/custom/unblock_ip.sh
mv brute_force_notice_ip.sh /usr/local/directadmin/scripts/custom/brute_force_notice_ip.sh
chmod 700 /usr/local/directadmin/scripts/custom/*.sh
touch /root/blocked_ips.txt
touch /root/exempt_ips.txt
