#!/bin/bash
# resilio-sync install
# turioul: https://www.vmvps.com/how-to-install-and-use-resilio-sync-or-bittorrent-sync-on-a-linux-vps.html


# install way 1
# https://download-cdn.resilio.com/stable/linux-i386/resilio-sync_i386.tar.gz
wget https://download-cdn.resilio.com/stable/linux-x64/resilio-sync_x64.tar.gz
tar zxvf resilio-sync_x64.tar.gz

# install way 2 
# debian
echo "deb http://linux-packages.resilio.com/resilio-sync/deb resilio-sync non-free" | sudo tee /etc/apt/sources.list.d/resilio-sync.list
curl -LO https://linux-packages.resilio.com/resilio-sync/key.asc && sudo apt-key add ./key.asc
apt-get update
sudo apt-get install resilio-sync

# CentOS系： 在/etc/yum.repos.d/resilio-sync.repo中加入如下内容
[resilio-sync]
name=Resilio Sync
baseurl=http://linux-packages.resilio.com/resilio-sync/rpm/$basearch
enabled=1
gpgcheck=1

#导入Key
rpm --import https://linux-packages.resilio.com/resilio-sync/key.asc
yum update
yum install resilio-sync


rslsync --webui.listen 0.0.0.0:8888

## 其他加载方法
./rslsync --dump-sample-config > sync.conf # 导出默认配置
vi /etc/rc.local  # 把BTSync加入开机启动

./rslsync --config sync.conf # 按配置 启动 rslsync
chmod +x /etc/rc.d/rc.local # 如果是CentOS 7还需要执行


# help
# killall rslsync  # kill all rslsync

