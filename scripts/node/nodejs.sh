#!/bin/bash

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install node.js"
    exit 1
fi
hr="========================================================================="
clear
echo $hr

cur_dir=`pwd`

function InstallNodejs()
{
    cd $cur_dir
    # wget http://nodejs.org/dist/v0.10.26/node-v0.10.26.tar.gz
    wget https://nodejs.org/dist/v6.11.2/node-v6.11.2.tar.gz
    tar zxf node-v6.11.2.tar.gz
    cd node-v6.11.2
    ./configure
    make && make install
}

InstallNodejs 2>&1 | tee -a InstallNodejs-`date +%Y%m%d`.log