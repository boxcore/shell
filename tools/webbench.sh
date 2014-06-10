#!/bin/bash


is_wbb=`which webbench`
hr="--------------------------------------------"

if [ $is_wbb ]; then
    echo "You have already install webbench!"
    echo $hr

else
    echo "Install webbench..."
    echo $hr
    src_dir='/root/src'
    mkdir -pv src_dir

    yum -y install ctags
    mkdir -pv /usr/local/man/man1

    wget -c http://mirrors.boxcore.org/webbench-1.5.tar.gz
    tar -zxf webbench-1.5.tar.gz
    cd webbench-1.5
    make
    make install
fi



