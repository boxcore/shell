#!/bin/bash 
# auto.sh
# yum install -y tigervnc-server tigervn

expect<<- END 
spawn vncserver
expect "Password:" 
send "abc654321\n" 
expect "Verify:" 
send "abc654321\n" 
expect "Would you like to enter a view-only password (y/n)?" 
send "n\n" 
expect eof
END

firewall-cmd --permanent --add-port=5901/tcp 
service firewalld reload

systemctl start vncserver@:1.service
systemctl enable vncserver@:1.service
