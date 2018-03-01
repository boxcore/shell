#!/bin/bash
#
####################################
#
# My Linux install script
# 
# USAGE: 
# curl -o 'init.sh' https://raw.githubusercontent.com/boxcore/shell/master/init.sh && chmod +x init.sh && ./init.sh
#
#-----------------------------------
# for centos 5+
# date:2016-12-27
####################################

yum install -y wget gcc gcc-c++ make gzip tar lrzsz screen git svn vim virt-what expect tree net-tools telnet
CUR_DIR=`pwd`

function check_crond()
{
if command -v crontab >/dev/null 2>&1; then 
echo 'crontab exist' 
else
echo 'crontab donot exist!' 
yum install -y cronie
chkconfig crond on
/etc/init.d/crond restart
fi
}

cd ~
git clone https://github.com/boxcore/shell.git

check_crond

#RSAAuthentication yes
#PubkeyAuthentication yes
#AuthorizedKeysFile     .ssh/authorized_keys
# file: /etc/ssh/sshd_config

sed -i "s:#RSAAuthentication yes:RSAAuthentication yes\nPubkeyAuthentication yes\nAuthorizedKeysFile .ssh/authorized_keys:g" /etc/ssh/sshd_config
mkdir ~/.ssh
chmod 600 ~/.ssh
touch ~/.ssh/authorized_keys
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCnSu5PR+iOChqiGllzN1PEqtAr04NP6Qu9KhV0aTd5BVUZzxa0ri+gyV4nOG+gwcnsEpGe+20pFmis9XfT3CVHVawD2kDJtB9NoUdqZudEbsYo5r67u+em//k1aYjSp5JdTJ19gpDsFZGZ12u1JxLVwFq+ojRk5ptTWMSQzYda0688AGYDukh1r5/ab4zzQls89BM8pGRZ4fZM/1OcggUq1WRkQMxk6cPWlE7XtPagk7AfQ+QuFtOJf5WQWEYUVXt8Ws9EuWmxy6UTOpJgNRHAIg/h7dzT/HRAPW6a3GA0tqyhcKzRhhHwo/2QNrxQ0O5UwLnDs6cMpx3W/Ahp9/+9 boxcore" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
/sbin/service sshd restart
/bin/bash ~/shell/tools/hk-mount.sh

yum remove -y git
/bin/bash ~/scripts/cvs/git.sh
sed -i "s:# .bashrc:# .bashrc\nalias gst='git status':g" ~/.bashrc
source ~/.bashrc
cd ~/shell/
gst

#/bin/bash ~/shell/shadowsocks/my-shadowsocks.sh

/bin/bash ~/shell/tools/iftop.sh
/bin/bash ~/shell/tools/rar.sh

# check if hk vps then run mount.sh
#/bin/bash ~/shell/tools/hk-mount.sh
#/bin/bash ~/shell/tools/hk-mount-check.sh

