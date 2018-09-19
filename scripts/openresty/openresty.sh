#!/bin/bash
#
# download from : http://openresty.org/en/download.html
#

# install dependent
yum install readline-devel pcre-devel openssl-devel gcc curl -y
yum install -y yum-utils

cd ~
wget https://openresty.org/download/openresty-1.13.6.2.tar.gz
tar zxf openresty-1.13.6.2.tar.gz
./configure
# or use : ./configure --with-luajit && make && make install
gmake
sudo gmake install


# for test openresty is up:
#  /usr/local/openresty/nginx/sbin/nginx -c /usr/local/openresty/nginx/conf/nginx.conf
# /usr/local/openresty/nginx/sbin/nginx -p 'pwd' -c /usr/local/openresty/nginx/conf/nginx.conf
# ln -s /usr/local/openresty/nginx/sbin/nginx /usr/sbin/nginx
# /usr/sbin/nginx -c /usr/local/openresty/nginx/conf/nginx.conf