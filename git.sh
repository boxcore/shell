#!/bin/bash

yum install gettext curl curl-devel zlib-devel openssl-devel perl cpio expat-devel gettext-devel -y

wget https://git-core.googlecode.com/files/git-1.8.3.2.tar.gz
tar xzvf git-1.8.3.2.tar.gz
cd git-1.8.3.2

autoconf
./configure
make
sudo make install

git --version