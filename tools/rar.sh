#/bin/bash

bit=`uname -m`

cd ~

if [ "$bit" = "x86_64" ]; then
    wget http://www.rarlab.com/rar/rarlinux-x64-5.3.0.tar.gz
    tar -zxf rarlinux-x64-5.3.0.tar.gz

else
    wget http://www.rarlab.com/rar/rarlinux-5.3.0.tar.gz
    tar -zxf rarlinux-5.3.0.tar.gz
fi

cd rar
make
make install