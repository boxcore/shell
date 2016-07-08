#!/bin/bash

cd ~
wget http://nchc.dl.sourceforge.net/project/p7zip/p7zip/9.20.1/p7zip_9.20.1_src_all.tar.bz2
tar -jxvf p7zip_9.20.1_src_all.tar.bz2
cd p7zip_9.20.1
make
make install