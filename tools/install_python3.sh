#/bin/bash
yum install gcc gcc-c++ make cmake -y

cd ~
wget https://www.python.org/ftp/python/3.5.2/Python-3.5.2.tgz
tar -zxf Python-3.5.2.tgz 
cd Python-3.5.2
./configure --prefix=/usr/local/python3
make && make install

echo 'export PATH=$PATH:/usr/local/python3/bin' >> ~/.bashrc

cd ~
wget https://bootstrap.pypa.io/get-pip.py
/usr/local/python3/bin/python3 get-pip.py

/usr/local/python3/bin/pip3 install requests 