#!/bin/bash

yum install gettext curl curl-devel zlib-devel openssl-devel perl cpio expat-devel gettext-devel -y
yum -y install zlib-devel curl-devel openssl-devel perl cpio expat-devel gettext-devel openssl zlib autoconf tk perl-ExtUtils-MakeMaker

# https://www.kernel.org/pub/software/scm/git/git-2.9.0.tar.gz
wget -o 'git-2.11.0.tar.gz' https://github.com/git/git/archive/v2.11.0.tar.gz
tar xzvf git-2.11.0.tar.gz
cd git-2.11.0

autoconf
./configure
make
sudo make install

#export PATH=$PATH:/usr/local/bin

git --version
