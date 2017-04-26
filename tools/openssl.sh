#!/bin/bash
# install newer openssl version for protect 0day bug
# @link: http://www.cnblogs.com/nayu/p/5521486.html

cd ~
# mv /usr/local/bin/openssl /usr/local/bin/openssl.bak
# mv /usr/bin/openssl /usr/bin/openssl.bak
wget https://www.openssl.org/source/openssl-1.1.0e.tar.gz
tar zxf openssl-1.1.0e.tar.gz
cd openssl-1.1.0e
./config shared zlib
make depend
make
make install

rm -rf ~/openssl-1.1.0e

# fixed so depend:
# openssl: error while loading shared libraries: libssl.so.1.1: cannot open shared object file: No such file or directory
ln -s /usr/local/lib64/libssl.so.1.1 /usr/lib64/libssl.so.1.1
ln -s /usr/local/lib64/libcrypto.so.1.1 /usr/lib64/libcrypto.so.1.1