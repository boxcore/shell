#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install lnmp"
    exit 1
fi

clear
echo "=========================================================================="
echo "Install LAMP v0.1 for CentOS												"
echo "A tool to auto-compile & install Apache+MySQL+PHP on Linux 				"
echo "For more information please visit http://www.boxcore.org/  				"
echo "fork me : https://github.com/boxcore/boxcore-lamp/fork					"
echo "=========================================================================="
cur_dir=$(pwd)

#set mysql root password
	echo "==========================="
	# close var mysqlrootpwd
	mysqlrootpwd="root"
	echo "Please input the root password of mysql:"
	read -p "(Default password: root):" mysqlrootpwd
	if [ "$mysqlrootpwd" = "" ]; then
		mysqlrootpwd="root"
	fi
	echo "================================="
	echo "MySQL root password:$mysqlrootpwd"
	echo "================================="


function InitInstall()
{
	echo "================================================================="
	echo " Remove Basic LAMP and donwload install basic lib "
	echo "================================================================="
	cd $cur_dir
	cat /etc/issue
	uname -a
	MemTotal=`free -m | grep Mem | awk '{print  $2}'`  
	echo -e "\n Memory is: ${MemTotal} MB "
	#Set timezone
	rm -rf /etc/localtime
	ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

	yum install -y ntp
	ntpdate -u pool.ntp.org
	date

	rpm -qa|grep httpd
	rpm -e httpd
	rpm -qa|grep mysql
	rpm -e mysql
	rpm -qa|grep php
	rpm -e php

	yum -y remove httpd*
	yum -y remove php*
	yum -y remove mysql-server mysql
	yum -y remove php-mysql

	yum -y install yum-fastestmirror
	yum -y remove httpd
	#yum -y update

	#Disable SeLinux
	if [ -s /etc/selinux/config ]; then
	sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
	fi

	cp /etc/yum.conf /etc/yum.conf.lamp
	sed -i 's:exclude=.*:exclude=:g' /etc/yum.conf

	for packages in wget make patch gcc gcc-c++ bison file curl curl-devel openssl openssl-devel;
	do yum -y install $packages; done

	mv -f /etc/yum.conf.lamp /etc/yum.conf
	yum clean all
	
	echo "================================================================="
	echo " Install axel-1.0b "
	echo "================================================================="
	if [ -s axel-1.0b.tar.gz ]; then
	  echo "axel-1.0b.tar.gz [found]"
	else
	  echo "Error: axel-1.0b.tar.gz not found!!!download now......"
	  wget http://mirrors.boxcore.org/lnmp/axel-1.0b.tar.gz
	fi
	tar zxvf axel-1.0b.tar.gz
	cd axel-1.0b
	./configure
	make && make install
	cd ../

}


function CheckAndDownloadLibFiles()
{
echo "============================check files=================================="
cd $cur_dir

if [ -s autoconf-2.61.tar.gz ]; then
  echo "autoconf-2.61.tar.gz [found]"
else
  echo "Error: autoconf-2.61.tar.gz not found!!!download now......"
  axel -n 10 http://mirrors.boxcore.org/lamp/autoconf-2.61.tar.gz
fi

if [ -s freetype-2.3.5.tar.gz ]; then
  echo "freetype-2.3.5.tar.gz [found]"
else
  echo "Error: freetype-2.3.5.tar.gz not found!!!download now......"
  axel -n 10 http://mirrors.boxcore.org/lamp/freetype-2.3.5.tar.gz
fi

if [ -s gd-2.0.35.tar.gz ]; then
  echo "gd-2.0.35.tar.gz [found]"
else
  echo "Error: gd-2.0.35.tar.gz not found!!!download now......"
  axel -n 10 http://mirrors.boxcore.org/lamp/gd-2.0.35.tar.gz
fi

if [ -s httpd-2.2.9.tar.gz ]; then
  echo "httpd-2.2.9.tar.gz [found]"
else
  echo "Error: httpd-2.2.9.tar.gz not found!!!download now......"
  axel -n 10 http://mirrors.boxcore.org/lamp/httpd-2.2.9.tar.gz
fi

if [ -s jpegsrc.v6b.tar.gz ]; then
  echo "jpegsrc.v6b.tar.gz [found]"
else
  echo "Error: jpegsrc.v6b.tar.gz not found!!!download now......"
  axel -n 10 http://mirrors.boxcore.org/lamp/jpegsrc.v6b.tar.gz
fi

if [ -s libmcrypt-2.5.8.tar.gz ]; then
  echo "libmcrypt-2.5.8.tar.gz [found]"
else
  echo "Error: libmcrypt-2.5.8.tar.gz not found!!!download now......"
  axel -n 10 http://mirrors.boxcore.org/lamp/libmcrypt-2.5.8.tar.gz
fi

if [ -s libpng-1.2.31.tar.gz ]; then
  echo "libpng-1.2.31.tar.gz [found]"
else
  echo "Error: libpng-1.2.31.tar.gz not found!!!download now......"
  axel -n 10 http://mirrors.boxcore.org/lamp/libpng-1.2.31.tar.gz
fi

if [ -s libxml2-2.6.30.tar.gz ]; then
  echo "libxml2-2.6.30.tar.gz [found]"
else
  echo "Error: libxml2-2.6.30.tar.gz not found!!!download now......"
  axel -n 10 http://mirrors.boxcore.org/lamp/libxml2-2.6.30.tar.gz
fi

if [ -s memcache-2.2.5.tgz ]; then
  echo "memcache-2.2.5.tgz [found]"
else
  echo "Error: memcache-2.2.5.tgz not found!!!download now......"
  axel -n 10 http://mirrors.boxcore.org/lamp/memcache-2.2.5.tgz
fi

if [ -s memcached-1.4.10.tar.gz ]; then
  echo "memcached-1.4.10.tar.gz [found]"
else
  echo "Error: memcached-1.4.10.tar.gz not found!!!download now......"
  axel -n 10 http://mirrors.boxcore.org/lamp/memcached-1.4.10.tar.gz
fi

if [ -s mysql-5.1.59.tar.gz ]; then
  echo "mysql-5.1.59.tar.gz [found]"
else
  echo "Error: mysql-5.1.59.tar.gz not found!!!download now......"
  axel -n 10 http://mirrors.boxcore.org/lamp/mysql-5.1.59.tar.gz
fi

if [ -s ncurses-5.6.tar.gz ]; then
  echo "ncurses-5.6.tar.gz [found]"
else
  echo "Error: ncurses-5.6.tar.gz not found!!!download now......"
  axel -n 10 http://mirrors.boxcore.org/lamp/ncurses-5.6.tar.gz
fi

if [ -s PDO_MYSQL-1.0.2.tgz ]; then
  echo "PDO_MYSQL-1.0.2.tgz [found]"
else
  echo "Error: PDO_MYSQL-1.0.2.tgz not found!!!download now......"
  axel -n 10 http://mirrors.boxcore.org/lamp/PDO_MYSQL-1.0.2.tgz
fi

if [ -s php-5.2.6.tar.gz ]; then
  echo "php-5.2.6.tar.gz [found]"
else
  echo "Error: php-5.2.6.tar.gz not found!!!download now......"
  axel -n 10 http://mirrors.boxcore.org/lamp/php-5.2.6.tar.gz
fi

if [ -s phpMyAdmin-3.0.0-rc1-all-languages.tar.gz ]; then
  echo "phpMyAdmin-3.0.0-rc1-all-languages.tar.gz [found]"
else
  echo "Error: phpMyAdmin-3.0.0-rc1-all-languages.tar.gz not found!!!download now......"
  axel -n 10 http://mirrors.boxcore.org/lamp/phpMyAdmin-3.0.0-rc1-all-languages.tar.gz
fi

if [ -s zlib-1.2.3.tar.gz ]; then
  echo "zlib-1.2.3.tar.gz [found]"
else
  echo "Error: zlib-1.2.3.tar.gz not found!!!download now......"
  axel -n 10 http://mirrors.boxcore.org/lamp/zlib-1.2.3.tar.gz
fi

echo "=======================tar==========================="
#/bin/ls *.tar.gz > ls.list
#/bin/ls *.tgz >> ls.list
#for TAR in `cat ls.list` 
#do /bin/tar -zxf $TAR
#done
#rm -rf ls.list

echo "============================check files=================================="
}

# install apache depand
function InstallLib()
{
cd $cur_dir


# install libxml2
echo "#===============================================================#"
echo "Install libxml2"
echo "#===============================================================#"
tar zxvf libxml2-2.6.30.tar.gz
cd libxml2-2.6.30
./configure --prefix=/usr/local/libxml2
make
make install
cp xml2-config /usr/bin/
cd ../

# install zlib
echo "#============================================================================#"
echo "Install zlib"
echo "#============================================================================#"
tar zxvf zlib-1.2.3.tar.gz
cd zlib-1.2.3
./configure --prefix=/usr/local/zlib
make
make install
cd ../
cat >>/etc/ld.so.conf<<eof
/usr/local/zlib/lib
eof
ldconfig

# install libmcrypt and libltdl
echo "#============================================================================#"
echo "Install libmcrypt and libltdl"
echo "#============================================================================#"
tar zxvf libmcrypt-2.5.8.tar.gz
cd libmcrypt-2.5.8/libltdl
./configure --enable-ltdl-install
make
make install
cd ../
./configure --prefix=/usr/local/libmcrypt
make && make install
cd ../



# install libpng
echo "#============================================================================#"
echo "Install libpng"
echo "#============================================================================#"
#export LDFLAGS="-L/usr/local/zlib/lib"
#export CPPFLAGS="-I/usr/local/zlib/include"
tar zxvf libpng-1.2.31.tar.gz
cd libpng-1.2.31
#cp scripts/makefile.linux ./makefile
#sed -i 's:ZLIBLIB=../zlib:ZLIBLIB=/usr/local/zlib/lib:g' makefile
#sed -i 's:ZLIBINC=../zlib:ZLIBINC=/usr/local/zlib/include:g' makefile
./configure --prefix=/usr/local/libpng
make && make install
cd ../


# install jpegsrc
echo "#============================================================================#"
echo "Install jpegsrc"
echo "#============================================================================#"
tar zxvf jpegsrc.v6b.tar.gz
cd jpeg-6b
mkdir -pv /usr/local/libjpeg/{,bin,lib,include,man/man1}
./configure --prefix=/usr/local/libjpeg --enable-shared --enable-static
make
make install
cd ../


# install freetype(ttf)
echo "#============================================================================#"
echo "Install freetype"
echo "#============================================================================#"
tar zxvf freetype-2.3.5.tar.gz
#  install freetype depand bzip2 harfbuzz
yum install -y bzip2-devel
cd freetype-2.3.5
./configure --prefix=/usr/local/freetype
make
make install
cd ../

# install autoconf
echo "#============================================================================#"
echo "Install autoconf"
echo "#============================================================================#"
tar zxvf autoconf-2.61.tar.gz
cd autoconf-2.61
./configure
make
make install
cd ../


# install gd
echo "#============================================================================#"
echo "Install gd2"
echo "#============================================================================#"
tar zxvf gd-2.0.35.tar.gz
cd gd-2.0.35
sed -i 's:#include "png.h":#include "/usr/local/libpng/include/png.h":g' gd_png.c
./configure --prefix=/usr/local/libgd --with-png=/usr/local/libpng --with-freetype=/usr/local/freetype --with-jpeg=/usr/local/libjpeg --enable-libxml2
make
make install
cd ../

# conf lib
echo "#============================================================================#"
echo "conf lib for ldconfig"
echo "#============================================================================#"
cat >>/etc/ld.so.conf<<eof
/usr/local/zlib/lib
/usr/local/freetype/lib
/usr/local/libjpeg/lib
/usr/local/libgd/lib
eof
ldconfig
}

# install apache
function InstallApache()
{
echo "============================Install Apache 2.2================================="
cd $cur_dir
tar -zxf httpd-2.2.9.tar.gz
cd httpd-2.2.9/
./configure --prefix=/usr/local/apache2 --sysconfdir=/usr/local/apache2/etc --with-included-apr --enable-so --enable-deflate=shared --enable-expires=shared --enable-rewrite=shared --with-zlib-dir=/usr/local/zlib
make
make install
sed '/\<IfModule \!mpm\_netware\_module\>/i\AddType application\/x\-httpd\-php \.php \.phtml \.phps' -i /usr/local/apache2/etc/httpd.conf
sed -i 's/#ServerName www.example.com:80/ServerName 127.0.0.1:80/g'  /usr/local/apache2/etc/httpd.conf
echo "/usr/local/apache2/bin/apachectl start" >> /etc/rc.d/rc.local
cd ../


}

# install MYSQL
function InstallMYSQL()
{
echo "============================Install MySQL================================="
cd $cur_dir

# install mysql depand
tar -zxf ncurses-5.6.tar.gz
cd ncurses-5.6/
./configure --with-shared --without-debug --without-ada --enable-overwrite
make 
make install
cd ../


# install mysql
mkdir -pv /var/mysql/data
groupadd -r mysql
useradd -g mysql -r -s /bin/false -M -d /var/mysql/data mysql
chown mysql:mysql /var/mysql/data
tar -zxvf mysql-5.1.59.tar.gz
cd mysql-5.1.59/
./configure --prefix=/usr/local/mysql --without-debug --enable-thread-safe-client --with-pthread --enable-assembler --enable-profiling --with-mysqld-ldflags=-all-static --with-client-ldflags=-all-static --with-extra-charsets=all --with-plugins=all --with-mysqld-user=mysql --without-embedded-server --with-server-suffix=-community --with-unix-socket-path=/tmp/mysql.sock
make
make install
mv -f /etc/my.cnf /etc/my.cnf.bak
cp -rf /usr/local/mysql/share/mysql/my-medium.cnf  /etc/my.cnf
sed '/\[client\]/a\default-character-set=utf8' -i /etc/my.cnf
sed '/\[mysqld\]/a\collation-server = utf8_general_ci' -i /etc/my.cnf
sed '/\[mysqld\]/a\character-set-server=utf8' -i /etc/my.cnf
sed '/skip-locking/i\datadir = /var/mysql/data' -i /etc/my.cnf
sed -i 's:#innodb:innodb:g' /etc/my.cnf
sed -i 's:/usr/local/mysql/data:/var/mysql/data:g' /etc/my.cnf
setfacl -m u:mysql:rwx -R /var/mysql
setfacl -m d:u:mysql:rwx -R /var/mysql

/usr/local/mysql/bin/mysql_install_db --user=mysql
/usr/local/mysql/bin/mysql_install_db --defaults-file=/etc/my.cnf --basedir=/usr/local/mysql --datadir=/var/mysql/data --user=mysql
/usr/local/mysql/bin/mysql_install_db --defaults-file=/etc/my.cnf --basedir=/usr/local/mysql --datadir=/var/mysql/data --user=mysql

chown -R mysql /usr/local/mysql/var
chgrp -R mysql /usr/local/mysql/.

cp /usr/local/mysql/share/mysql/mysql.server /etc/init.d/mysql
chmod 755 /etc/init.d/mysql
chkconfig mysql on
echo 'export PATH=/usr/local/mysql/bin:$PATH' >> /etc/profile

cat > /etc/ld.so.conf.d/mysql.conf<<EOF
/usr/local/mysql/lib
/usr/local/lib
EOF
ldconfig
ln -s /usr/local/mysql/lib/mysql /usr/lib/mysql
ln -s /usr/local/mysql/include/mysql /usr/include/mysql

if [ -d "/proc/vz" ];then
ulimit -s unlimited
fi
/etc/init.d/mysql start
ln -s /usr/local/mysql/bin/mysql /usr/bin/mysql
ln -s /usr/local/mysql/bin/mysqldump /usr/bin/mysqldump
ln -s /usr/local/mysql/bin/myisamchk /usr/bin/myisamchk
ln -s /usr/local/mysql/bin/mysqld_safe /usr/bin/mysqld_safe
touch /tmp/mysql.sock
chown mysql:mysql /tmp/mysql.sock

/usr/local/mysql/bin/mysqladmin -uroot password $mysqlrootpwd
cat > /tmp/mysql_sec_script<<EOF
use mysql;
update user set password=password('$mysqlrootpwd') where user='root';
delete from user where not (user='root') ;
delete from user where user='root' and password=''; 
drop database test;
DROP USER ''@'%';
flush privileges;
EOF
/usr/local/mysql/bin/mysql -u root -p$mysqlrootpwd -h localhost < /tmp/mysql_sec_script
rm -f /tmp/mysql_sec_script
/etc/init.d/mysql restart
/etc/init.d/mysql stop
echo "/usr/local/mysql/bin/mysqld_safe --user=mysql &" >> /etc/rc.d/rc.local

cd ../

echo "============================MySQL 5.1 install completed========================="
}


# install php 5.2
function InstallPHP()
{
echo "============================Install MySQL================================="
cd $cur_dir

yum -y install libtool*
yum -y install libtool-ltdl*

tar -zxvf php-5.2.6.tar.gz
cd php-5.2.6/
./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --with-apxs2=/usr/local/apache2/bin/apxs --with-mysql=/usr/local/mysql --with-libxml-dir=/usr/local/libxml2 --with-jpeg-dir=/usr/local/libjpeg --with-png-dir=/usr/local/libpng --with-freetype-dir=/usr/local/freetype --with-gd=/usr/local/libgd --with-mcrypt=/usr/local/libmcrypt --with-mysqli=/usr/local/mysql/bin/mysql_config --with-zlib-dir=/usr/local/zlib --enable-soap --enable-mbstring=all --enable-sockets
make
make install

cp -rf php.ini-dist  /usr/local/php/etc/php.ini


}


# install PHPExtension
function InstallPHPExtension()
{
echo "============================ Install PHP Extension ================================="
cd $cur_dir

# install memcache
echo "Install memcache php extension..."
tar -zxf memcache-2.2.5.tgz
cd memcache-2.2.5/
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config --with-zlib-dir=/usr/local/zlib
make && make install
cd ../

# install  PDO_MYSQL
echo "Install PDO_MYSQL php extension..."
tar -zxf PDO_MYSQL-1.0.2.tgz
cd PDO_MYSQL-1.0.2
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config --with-pdo-mysql=/usr/local/mysql
make && make install
cd ../

sed -i 's#extension\_dir = "\.\/"#extension\_dir = "\/usr\/local\/php\/lib\/php\/extensions\/no\-debug\-non\-zts\-20060613\/"#g' /usr/local/php/etc/php.ini
sed '/; Be sure to appropriately set the extension\_dir directive\./a\extension="memcache\.so";\nextension="pdo\.so";\nextension="pdo_mysql\.so";' -i /usr/local/php/etc/php.ini

# install ZendOptimizer
if [ `getconf WORD_BIT` = '32' ] && [ `getconf LONG_BIT` = '64' ] ; then
	if [ -s ZendOptimizer-3.2.6-linux-glibc23-x86_64.tar.gz ]; then
	  echo "ZendOptimizer-3.2.6-linux-glibc23-x86_64.tar.gz [found]"
	else
	  echo "Error: ZendOptimizer-3.2.6-linux-glibc23-x86_64.tar.gz not found!!!download now......"
	  axel -n 10 http://mirrors.boxcore.org/lamp/ZendOptimizer-3.2.6-linux-glibc23-x86_64.tar.gz
	fi
	tar zxvf ZendOptimizer-3.2.6-linux-glibc23-x86_64.tar.gz
	mkdir -p /usr/local/zend/
	cp ZendOptimizer-3.3.9-linux-glibc23-x86_64/data/5_2_x_comp/ZendOptimizer.so /usr/local/zend/
else
	if [ -s ZendOptimizer-3.2.6-linux-glibc21-i386.tar.gz ]; then
	  echo "ZendOptimizer-3.2.6-linux-glibc21-i386.tar.gz [found]"
	else
	  echo "Error: ZendOptimizer-3.2.6-linux-glibc21-i386.tar.gz not found!!!download now......"
	  axel -n 10 http://mirrors.boxcore.org/lamp/ZendOptimizer-3.2.6-linux-glibc21-i386.tar.gz
	fi
	tar -zxf ZendOptimizer-3.2.6-linux-glibc21-i386.tar.gz
	cd ZendOptimizer-3.2.6-linux-glibc21-i386/
	mkdir -p /usr/local/zend/
	cp data/5_2_x_comp/ZendOptimizer.so /usr/local/zend/
fi
cd ../

cat >>/usr/local/php/etc/php.ini<<EOF
;eaccelerator

;ionCube

[Zend Optimizer] 
zend_optimizer.optimization_level=1 
zend_extension="/usr/local/zend/ZendOptimizer.so" 
EOF

}

# install memcache resource
function InstallMemcache()
{
echo "============================ Install Memcache Resource ================================="
cd $cur_dir

# install memcache depend libevent
if [ -s libevent-2.0.13-stable.tar.gz ]; then
  echo "libevent-2.0.13-stable.tar.gz [found]"
else
  echo "Error: libevent-2.0.13-stable.tar.gz not found!!!download now......"
  axel -n 10 http://mirrors.boxcore.org/lamp/libevent-2.0.13-stable.tar.gz
fi
tar zxvf libevent-2.0.13-stable.tar.gz
cd libevent-2.0.13-stable/
./configure --prefix=/usr/local/libevent
make && make install
cd ../
echo "/usr/local/libevent/lib/" >> /etc/ld.so.conf
ln -s /usr/local/libevent/lib/libevent-2.0.so.5  /lib/libevent-2.0.so.5
ldconfig
#yum -y install libevent*

echo "Install memcached..."
tar -zxf memcached-1.4.10.tar.gz
cd memcached-1.4.10/
./configure --prefix=/usr/local/memcached --with-libevent=/usr/local/libevent
make &&make install
ln /usr/local/memcached/bin/memcached /usr/bin/memcached
cd ../

cd $cur_dir
cp -rf conf/memcached-init /etc/init.d/memcached
chmod +x /etc/init.d/memcached
useradd -s /sbin/nologin nobody

if [ -s /etc/debian_version ]; then
update-rc.d -f memcached defaults
elif [ -s /etc/redhat-release ]; then
chkconfig --level 345 memcached on
fi

echo "Copy Memcached PHP Test file..."
cp conf/memcached.php /usr/local/apache2/htdocs/memcached.php

echo "Starting Memcached..."
/etc/init.d/memcached start
useradd memcache
passwd memcache

echo "/usr/local/memcache/bin/memcached -umemcache &" >> /etc/rc.d/rc.local

}

mkdir -pv logs
InitInstall 2>&1 | tee -a logs/InitInstall-`date +%Y%m%d`.log
CheckAndDownloadLibFiles 2>&1 | tee -a logs/CheckAndDownloadLibFiles-`date +%Y%m%d`.log
InstallLib 2>&1 | tee -a logs/InstallLib-`date +%Y%m%d`.log
InstallApache 2>&1 | tee -a logs/InstallApache-`date +%Y%m%d`.log
InstallMYSQL 2>&1 | tee -a logs/InstallMYSQL-`data +%Y%m%d`.log
InstallPHP 2>&1 | tee -a logs/InstallPHP-`date +%Y%m%d`.log
InstallPHPExtension 2>&1 | tee logs/InstallPHPExtension-`date +%Y%m%d`.log
InstallMemcache 2>&1 | tee logs/InstallMemcache-`date +%Y%m%d`.log