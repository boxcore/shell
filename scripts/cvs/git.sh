#!/bin/bash

yum install gettext curl curl-devel zlib-devel openssl-devel perl cpio expat-devel gettext-devel -y
yum -y install zlib-devel curl-devel openssl-devel perl cpio expat-devel gettext-devel openssl zlib autoconf tk perl-ExtUtils-MakeMaker

# https://www.kernel.org/pub/software/scm/git/git-2.9.0.tar.gz
# https://gitee.com/xob/git/repository/archivev2.11.0.zip
wget https://github.com/git/git/archive/v2.11.0.tar.gz
tar xzvf v2.11.0.tar.gz
cd git-2.11.0

autoconf
./configure
make
sudo make install
cd ../
rm -rf v2.11.0.tar.gz git-2.11.0
#export PATH=$PATH:/usr/local/bin

git --version
