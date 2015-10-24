#/bin/bash
yum install flex byacc  libpcap ncurses ncurses-devel libpcap-devel
wget http://www.ex-parrot.com/pdw/iftop/download/iftop-0.17.tar.gz
tar zxvf iftop-0.17.tar.gz
cd iftop-0.17
./configure
make && make install
