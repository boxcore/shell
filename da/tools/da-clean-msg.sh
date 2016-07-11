#!/bin/bash
#########################################
#Function:    clean msg(清理da面板短消息)
#Usage:       bash da-clean-msg.sh
#website:     www.boxcore.org
#Version:     0.1
#########################################

cat /dev/null >/usr/local/directadmin/data/admin/tickets.list
rm -rf /usr/local/directadmin/data/tickets/*