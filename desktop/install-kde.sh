#!/bin/bash
#
####################################
#
# Install KDE script
# 
# USAGE: 
# by https://digitalocean.youhuima.cc/centos-7-kde-vnc-remote.html

yum grouplist
yum groupinstall "KDE Plasma Workspaces"
yum install -y tigervnc-server tigervn

# cp /lib/systemd/system/vncserver@.service /lib/systemd/system/vncserver@:1.service

vncserver
systemctl start vncserver@:1.service # or vncserver :1
systemctl enable vncserver@:1.service  # 设置开机启动
systemctl stop vncserver@:1.service # 关闭 或 vncserver -kill :1


# 共享粘贴，在vncviwer连上后执行 `vncconfig &`   即可