#!/bin/bash
# install LuaJit
# download from : http://luajit.org/download.html

cd ~
wget http://luajit.org/download/LuaJIT-2.0.5.tar.gz
tar zxf LuaJIT-2.0.5.tar.gz
cd LuaJIT-2.0.5
make
sudo make install
ldconfig

# 执行luajit print("hello");如果能正常输出则ok