#!/bin/bash
#
####################################
#
# Install KDE script
# 
# USAGE: 
# by https://digitalocean.youhuima.cc/centos-7-kde-vnc-remote.html

yum grouplist
yum groupinstall -y "KDE Plasma Workspaces"
yum install -y tigervnc-server tigervn

# cp /lib/systemd/system/vncserver@.service /lib/systemd/system/vncserver@:1.service

vncserver

#
#You will require a password to access your desktops.

# Password:
# 
# Verify:
# Would you like to enter a view-only password (y/n)?
# Password:
# Verify:
# xauth:  file /root/.Xauthority does not exist

# New 'localhost.localdomain:1 (root)' desktop is localhost.localdomain:1

# Creating default startup script /root/.vnc/xstartup
# Creating default config /root/.vnc/config
# Starting applications specified in /root/.vnc/xstartup
# Log file is /root/.vnc/localhost.localdomain:1.log
# firewall-cmd --permanent --add-port=5901/tcp 
# service firewalld restart
systemctl start vncserver@:1.service # or vncserver :1
systemctl enable vncserver@:1.service  # 设置开机启动
systemctl stop vncserver@:1.service # 关闭 或 vncserver -kill :1


# 共享粘贴，在vncviwer连上后执行 `vncconfig &`   即可