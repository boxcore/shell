#/bin/bash
yum -y install fuse fuse-* glib2 glib2-*
wget http://nchc.dl.sourceforge.net/project/fuse/sshfs-fuse/2.4/sshfs-fuse-2.4.tar.gz
tar xvf sshfs-fuse-2.4.tar.gz
cd sshfs-fuse-2.4
./configure
make
make install
