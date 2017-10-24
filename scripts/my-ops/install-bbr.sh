#!/bin/bash
#
# 说明:本文不适用于linode主机
#

uname -r

sudo rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
sudo rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
sudo yum --enablerepo=elrepo-kernel install kernel-ml -y

# search kernel-ml-4.xxxx
rpm -qa | grep kernel


echo 'net.core.default_qdisc=fq' | sudo tee -a /etc/sysctl.conf
echo 'net.ipv4.tcp_congestion_control=bbr' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

sudo sysctl net.ipv4.tcp_available_congestion_control

sudo sysctl -n net.ipv4.tcp_congestion_control

lsmod | grep bbr