#!/bin/bash
#########################################
#Function:    install lnmp
#Usage:       bash lnmp.sh
#website:     lnmp.boxcore.org
#Version:     0.1
#########################################
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install lnmp"
    exit 1
fi
hr="========================================================================="
clear
echo $hr
echo "Install LNMP v1.0 for CentOS"
echo "A tool to auto-compile & install Nginx+MySQL+PHP on Linux For more information please visit http://lnmp.boxcore.org/"
echo $hr
# close var cur_dir now
cur_dir=$(pwd)
mkdir src
src_dir=$cur_dir/src
cd src_dir

#set mysql root password
    echo $hr
    mysqlrootpwd="root"
    echo "Please input the root password of mysql:"
    read -p "(Default password: root):" mysqlrootpwd
    if [ "$mysqlrootpwd" = "" ]; then
        mysqlrootpwd="root"
    fi
    echo $hr
    echo "MySQL root password:$mysqlrootpwd"
    echo $hr

# set install dependent method
function ChooseDependentType()
{
    # echo $hr
    # echo "You now have 2 options for your dependent setup."
    # echo ""
    # echo "1: Install Dependent By Yum"
    # echo "2: Install Dependent By Compiled Resource"
    # echo $hr
    # echo -n "Enter your choice (1 or 2): ";
    # read dependent_type

    # if [ "$dependent_type" = "1" ]; then
    #     export LNMP_DTYPE="1"
    # elif [ "$dependent_type" = "2" ]; then
    #     export LNMP_DTYPE="2"
    # else
    #     echo "You input a wrong number, please choose again!"
    #     ChooseDependentType
    # fi

    export LNMP_DTYPE="1"
}

# set run nginx and php user
function ChooseRunUser()
{
    # echo $hr
    # echo "Which User you want to run php and nginx?"
    # echo ""
    # echo "www: install for servers product"
    # echo "root: only u!"
    # echo $hr
    # echo -n "Enter your choice (www or root): ";
    # read runuser

    # if [ "$runuser" = "www" ]; then
    #     export LNMP_USER="www"
    #     groupadd www
    #     useradd -s /sbin/nologin -g www www
    # elif [ "$runuser" = "root" ]; then
    #     export LNMP_USER="root"
    # else
    #     echo "You input a wrong user name, please choose again!"
    #     ChooseRunUser
    # fi

    export LNMP_USER="www"
    groupadd www
    useradd -s /sbin/nologin -g www www
}

function InitInstall()
{
    echo $hr
    echo " Remove Basic LNMP and donwload install basic lib "
    echo $hr
    cd $src_dir
    cat /etc/issue
    uname -a
    MemTotal=`free -m | grep Mem | awk '{print  $2}'`
    export LNMP_MEM=$MemTotal
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

    yum -y update

    cp /etc/yum.conf /etc/yum.conf.lnmp
    sed -i 's:exclude=.*:exclude=:g' /etc/yum.conf

    for packages in wget make gcc gcc-c++ openssl openssl-devel;
    do yum -y install $packages; done

    mv -f /etc/yum.conf.lnmp /etc/yum.conf
    yum clean all

    InstallAxel

}



function InstallAxel()
{
    echo $hr
    echo " Install axel-1.0b "
    echo $hr
    if [ -f /usr/local/bin/axel ]; then
        echo "You already install axel!"
    else
        cd $src_dir
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
    fi
    echo $hr
}


function DownloadBasic()
{
    echo $hr
    echo "check files..."
    echo $hr
    cd $src_dir

    if [ -s php-5.3.28.tar.gz ]; then
      echo "php-5.3.28.tar.gz [found]"
    else
      echo "Error: php-5.3.28.tar.gz not found!!!download now......"
      axel -n 10 http://mirrors.boxcore.org/lnmp/php-5.3.28.tar.gz
    fi

    if [ -s mysql-5.5.35.tar.gz ]; then
      echo "mysql-5.5.35.tar.gz [found]"
    else
      echo "Error: mysql-5.5.35.tar.gz not found!!!download now......"
      axel -n 10 http://mirrors.boxcore.org/lnmp/mysql-5.5.35.tar.gz
    fi

    if [ -s nginx-1.4.4.tar.gz ]; then
      echo "nginx-1.4.4.tar.gz [found]"
      else
      echo "Error: nginx-1.4.4.tar.gz not found!!!download now......"
      axel -n 10 http://mirrors.boxcore.org/lnmp/nginx-1.4.4.tar.gz
    fi

    if [ -s conf.tar.gz ]; then
      echo "conf.tar.gz [found]"
      else
      echo "Error: conf.tar.gz not found!!!download now......"
      axel -n 10 http://mirrors.boxcore.org/lnmp/conf.tar.gz
    fi

    if [ -s pcre-8.34.tar.gz ]; then
      echo "pcre-8.34.tar.gz [found]"
    else
      echo "Error: pcre-8.34.tar.gz not found!!!download now......"
      wget -c http://mirrors.boxcore.org/lnmp/pcre-8.34.tar.gz
    fi

    echo $hr
}


# download depandent
function DownloadDependent()
{
    # if [ -s autoconf-2.69.tar.gz ]; then
    #   echo "autoconf-2.69.tar.gz [found]"
    # else
    #   echo "Error: autoconf-2.69.tar.gz not found!!!download now......"
    #   wget -c http://mirrors.boxcore.org/lnmp/autoconf-2.69.tar.gz
    # fi

    # if [ -s fontconfig-2.11.0.tar.gz ]; then
    #   echo "fontconfig-2.11.0.tar.gz [found]"
    # else
    #   echo "Error: fontconfig-2.11.0.tar.gz not found!!!download now......"
    #   wget -c http://mirrors.boxcore.org/lnmp/fontconfig-2.11.0.tar.gz
    # fi

    # if [ -s freetype-2.5.3.tar.gz ]; then
    #   echo "freetype-2.5.3.tar.gz [found]"
    # else
    #   echo "Error: freetype-2.5.3.tar.gz not found!!!download now......"
    #   wget -c http://mirrors.boxcore.org/lnmp/freetype-2.5.3.tar.gz
    # fi

    if [ -s gd-2.0.35.tar.gz ]; then
      echo "gd-2.0.35.tar.gz [found]"
    else
      echo "Error: gd-2.0.35.tar.gz not found!!!download now......"
      wget -c http://mirrors.boxcore.org/lnmp/gd-2.0.35.tar.gz
    fi

    if [ -s jpegsrc.v9a.tar.gz ]; then
      echo "jpegsrc.v9a.tar.gz [found]"
    else
      echo "Error: jpegsrc.v9a.tar.gz not found!!!download now......"
      wget -c http://mirrors.boxcore.org/lnmp/jpegsrc.v9a.tar.gz
    fi

    # if [ -s libiconv-1.14.tar.gz ]; then
    #   echo "libiconv-1.14.tar.gz [found]"
    # else
    #   echo "Error: libiconv-1.14.tar.gz not found!!!download now......"
    #   wget -c http://mirrors.boxcore.org/lnmp/libiconv-1.14.tar.gz
    # fi

    # if [ -s libmcrypt-2.5.8.tar.gz ]; then
    #   echo "libmcrypt-2.5.8.tar.gz [found]"
    # else
    #   echo "Error: libmcrypt-2.5.8.tar.gz not found!!!download now......"
    #   wget -c http://mirrors.boxcore.org/lnmp/libmcrypt-2.5.8.tar.gz
    # fi

    if [ -s libpng-1.6.2.tar.gz ]; then
      echo "libpng-1.6.2.tar.gz [found]"
    else
      echo "Error: libpng-1.6.2.tar.gz not found!!!download now......"
      wget -c http://mirrors.boxcore.org/lnmp/libpng-1.6.2.tar.gz
    fi

    # if [ -s libxml2-2.9.1.tar.gz ]; then
    #   echo "libxml2-2.9.1.tar.gz [found]"
    # else
    #   echo "Error: libxml2-2.9.1.tar.gz not found!!!download now......"
    #   wget -c http://mirrors.boxcore.org/lnmp/libxml2-2.9.1.tar.gz
    # fi

    # if [ -s mcrypt-2.6.8.tar.gz ]; then
    #   echo "mcrypt-2.6.8.tar.gz [found]"
    # else
    #   echo "Error: mcrypt-2.6.8.tar.gz not found!!!download now......"
    #   wget -c http://mirrors.boxcore.org/lnmp/mcrypt-2.6.8.tar.gz
    # fi

    # if [ -s mhash-0.9.9.9.tar.gz ]; then
    #   echo "mhash-0.9.9.9.tar.gz [found]"
    # else
    #   echo "Error: mhash-0.9.9.9.tar.gz not found!!!download now......"
    #   wget -c http://mirrors.boxcore.org/lnmp/mhash-0.9.9.9.tar.gz
    # fi

    # if [ -s zlib-1.2.5.tar.gz ]; then
    #   echo "zlib-1.2.5.tar.gz [found]"
    # else
    #   echo "Error: zlib-1.2.5.tar.gz not found!!!download now......"
    #   wget -c http://mirrors.boxcore.org/lnmp/zlib-1.2.5.tar.gz
    # fi
}

# install dependent by yum
function InstallDependentByYum()
{
    # for packages in patch cmake gcc-g77 flex bison file libtool libtool-libs autoconf kernel kernel-devel kernel-headers libjpeg libjpeg-devel libpng libpng-devel libpng10 libpng10-devel gd gd-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glib2 glib2-devel bzip2 bzip2-devel libevent libevent-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5 krb5-devel libidn libidn-devel openssl openssl-devel vim-minimal nano fonts-chinese gettext gettext-devel gmp-devel pspell-devel unzip libcap automake compat* cpp cloog-ppl ppl glibc jpegsrc keyutils keyutils-libs-devel libcom_err-devel libgomp libiconv libjpeg* libmcrypt libmcrypt-devel libsepol-devel libselinux-devel libXpm* libstdc++-devel mhash mpfr pcre-devel  perl php-gd php-common python-devel fontconfig cmake apr* ncurses ncurses-devel;
    # do yum -y install $packages; done

    # for basic dependent
    yum -y install glibc zlib zlib-devel libjpeg libjpeg-devel jpegsrc libpng libpng-devel libpng10 libpng10-devel gd gd-devel freetype freetype-devel libxml2 libxml2-devel glib2 glib2-devel bzip2 bzip2-devel libevent libevent-devel curl curl-devel libidn libidn-devel openssl openssl-devel
    yum -y install unzip automake

    # for php resource : http://koda.iteye.com/blog/420991
    yum -y install autoconf automake libidn-devel curl curl-devel
    yum -y install libmcrypt libmcrypt-devel mcrypt mhash
    yum -y install libxml2 libxml2-devel

}

# install dependent
function InstallDependentByCompile()
{
    cd $src_dir

    # install zlib
    echo $hr
    echo "Install zlib"
    echo $hr
    tar zxvf zlib-1.2.5.tar.gz
    cd zlib-1.2.5
    ./configure
    make && make install
    cd ../

    # install libpng
    echo $hr
    echo "Install libpng"
    echo $hr
    tar zxvf libpng-1.6.2.tar.gz
    cd libpng-1.6.2
    # cp scripts/makefile.linux ./makefile
    # when have /usr/lcoal/zlib, then use it:
    # sed -i 's:ZLIBLIB=../zlib:ZLIBLIB=/usr/local/zlib/lib:g' makefile
    # sed -i 's:ZLIBINC=../zlib:ZLIBINC=/usr/local/zlib/include:g' makefile
    ./configure --prefix=/usr/local/libpng
    make && make install
    cd ../

    # install jpegsrc
    echo $hr
    echo "Install jpegsrc"
    echo $hr
    tar zxvf jpegsrc.v9a.tar.gz
    cd jpeg-9a
    mkdir -pv /usr/local/libjpeg/{,bin,lib,include,man/man1,man1}
    ./configure --prefix=/usr/local/libjpeg --enable-shared --enable-static
    make && make install
    cd ../

    # install libxml2
    echo $hr
    echo "Install libxml2(must install python-devel depand)"
    echo $hr
    yum -y install python-devel
    tar zxvf libxml2-2.9.1.tar.gz
    cd libxml2-2.9.1
    ./configure --prefix=/usr/local/libxml2
    make && make install
    cp xml2-config /usr/bin/
    cd ../

    # install libmcrypt
    echo $hr
    echo "Install libmcrypt"
    echo $hr
    tar zxvf libmcrypt-2.5.8.tar.gz
    cd libmcrypt-2.5.8
    ./configure
    make && make install
    cd ../

    # install gd
    echo $hr
    echo "Install gd2"
    echo $hr
    yum -y install freetype freetype-devel zlib-devel fontconfig fontconfig-devel  libXpm-devel
    tar zxvf gd-2.0.35.tar.gz
    cd gd-2.0.35
    ./configure --prefix=/usr/local/libgd --with-png=/usr/local/libpng --with-jpeg=/usr/local/libjpeg --enable-libxml2
    make && make install
    cd ../

# conf lib
echo $hr
echo "conf lib for ldconfig"
echo $hr
cat >>/etc/ld.so.conf<<eof
/usr/local/zlib/lib
/usr/local/libpng/lib
/usr/local/libjpeg/lib
/usr/local/libgd/lib
eof
ldconfig
}

# install MYSQL
function InstallMYSQL5_5()
{
#######################################################################
# refer :   http://www.cnblogs.com/zz0412/archive/2013/05/21/mysql.html
# info:     set mysql db dir: '/var/mysql/data' and run by sid: 'mysql'
# author :  boxcore
# version:  v0.1 stable
# date:     2014-04-09
#######################################################################
echo $hr
echo "Install MySQL"
echo $hr
    
# yum install mysql dependent packages
yum -y install cmake ncurses ncurses-devel

# Add mysql user and document
mkdir -pv /var/mysql/data
groupadd -r mysql
useradd -g mysql -r -s /bin/false -M -d /var/mysql/data mysql
chown mysql:mysql /var/mysql/data

# Compile and install mysql
cd $src_dir
tar -zxf mysql-5.5.35.tar.gz
cd mysql-5.5.35
cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql -DMYSQL_DATADIR=/var/mysql/data -DSYSCONFDIR=/etc -DWITH_MYISAM_STORAGE_ENGINE=1 -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_ARCHIVE_STORAGE_ENGINE=1 -DWITH_BLACKHOLE_STORAGE_ENGINE=1 -DENABLED_LOCAL_INFILE=1 -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DEXTRA_CHARSETS=utf8 -DMYSQL_TCP_PORT=3306 -DMYSQL_USER=mysql -DMYSQL_UNIX_ADDR=/tmp/mysql.sock -DWITH_SSL=yes -DWITH_PARTITION_STORAGE_ENGINE=1 -DINSTALL_PLUGINDIR=/usr/local/mysql/plugin -DWITH_DEBUG=0
make && make install

# setting mysql conf
mv -f /etc/my.cnf /etc/my.cnf.bak
cp -rf /usr/local/mysql/support-files/my-medium.cnf /etc/my.cnf
sed '/skip-external-locking/i\datadir = /var/mysql/data' -i /etc/my.cnf
sed -i 's:#innodb:innodb:g' /etc/my.cnf
sed -i 's:/usr/local/mysql/data:/var/mysql/data:g' /etc/my.cnf

# install mysql data
chmod 755 /usr/local/mysql/scripts/mysql_install_db
/usr/local/mysql/scripts/mysql_install_db --defaults-file=/etc/my.cnf --basedir=/usr/local/mysql --datadir=/var/mysql/data --user=mysql
# chown -R mysql /usr/local/mysql/var  #if mysql data path in /usr/local/mysql then use it!
chgrp -R mysql /usr/local/mysql/.

# add mysql server to system
cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysql
chmod 755 /etc/init.d/mysql
chkconfig mysql on
echo 'export PATH=/usr/local/mysql/bin:$PATH' >> /etc/profile

# ? how it work?
cat > /etc/ld.so.conf.d/mysql.conf<<EOF
/usr/local/mysql/lib
/usr/local/lib
EOF
ldconfig

# add mysql shell to system
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

# setting mysql root password
/usr/local/mysql/bin/mysqladmin -u root password $mysqlrootpwd
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

# done for mysql install, enjoy it!
/etc/init.d/mysql restart
/etc/init.d/mysql stop
echo "============================MySQL 5.5.35 install completed========================="
}


# install Nginx
function InstallNginx_1_4()
{
echo "============================Install Nginx================================="
cd $src_dir

# install pcre for nginx
tar zxvf pcre-8.34.tar.gz
cd pcre-8.34/
./configure
make && make install
cd ../
ldconfig

# install nginx
tar zxvf nginx-1.4.4.tar.gz
cd nginx-1.4.4/
./configure --user=$LNMP_USER --group=$LNMP_USER --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module --with-http_gzip_static_module --with-ipv6 --with-pcre
make && make install
cd ../

# install nginx service shell
tar zxvf conf.tar.gz
rm -rf /etc/rc.d/init.d/nginx
cp -rf conf/nginx /etc/rc.d/init.d/nginx
chmod 775 /etc/rc.d/init.d/nginx
chkconfig nginx on
/etc/rc.d/init.d/nginx restart
service nginx restart

ln -s /usr/local/nginx/sbin/nginx /usr/bin/nginx

#rm -f /usr/local/nginx/conf/nginx.conf
#cd /root/lnmp
#cp conf/nginx.conf /usr/local/nginx/conf/nginx.conf
#cp conf/www-conf /home/www/conf

if [[ "$LNMP_USER" = "www" ]]; then
    cd $src_dir
    mkdir -p /home/www/{default,logs,logs/nginx,logs/php}
    touch /home/www/logs/nginx/error.log
    chmod +w /home/www/default
    chmod 777 /home/www/logs
    chown -R www:www /home/www
fi

}

function InstallPHP5_3()
{
    # install php basic dependent
    yum -y install php-common php-cli php-mbstring php-gd php-ldap php-pear php-xmlrpc php-mcrypt php-mysql php-pdo php-xml

    # compiled php resource
    cd $src_dir
    tar -zxf php-5.3.28.tar.gz
    rm -rf /usr/local/php*
    cd php-5.3.28
    if [ "$LNMP_DTYPE" = "1" ]; then
        #if use yum dependent
        ./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --enable-fpm --with-fpm-user=$LNMP_USER --with-fpm-group=$LNMP_USER --with-mysql=/usr/local/mysql --with-mysql-sock --with-pdo-mysql=/usr/local/mysql/bin/mysql --with-zlib  --with-libxml-dir --with-curl --with-xmlrpc --with-openssl --with-mhash  --with-pear --enable-mbstring --enable-sysvshm --enable-zip  --enable-soap --enable-sockets
		# bug: configure: error: Cannot find php_pdo_driver.h.
    else
        #yum list installed|grep mcrypt
        ./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --enable-fpm --with-fpm-user=$LNMP_USER --with-fpm-group=$LNMP_USER --with-mysql=/usr/local/mysql --with-mysql-sock --with-pdo-mysql=/usr/local/mysql/bin/mysql --with-zlib --with-libxml-dir --with-curl --with-xmlrpc --with-openssl --with-mhash --with-mcrypt=/usr/local/libmcrytp --with-pear --enable-mbstring --enable-sysvshm --enable-zip  --enable-soap --enable-sockets
    fi
    
    make && make install

    # setting php conf
    cp -rf php.ini-development /usr/local/php/etc/php.ini
    sed -i "s#\;date\.timezone \=#date\.timezone \= \"Asia\/Chongqing\"#g" /usr/local/php/etc/php.ini

    # install  php-fpm service
    cp -rf sapi/fpm/init.d.php-fpm  /etc/rc.d/init.d/php-fpm
    chmod +x /etc/init.d/php-fpm
    chkconfig --add php-fpm
    chkconfig php-fpm on

# setting php-fpm conf
cp -rf /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf
if [ -s /usr/lib/php/modules/gd.so ]; then
    sed -i '/;extension=php_zip.dll/a\extension=/usr/lib/php/modules/gd.so' /usr/local/php/etc/php.ini
fi
# vi php-fpm.conf 
# //一般配置的依据如下
# ===============================================
# 内存小于4G服务器（值可逐级递减）：
# 修改如下参数：
# pm=dynamic
# pm.max_children=40
# pm.start_servers=10
# pm.min_spare_servers=10
# pm.max_spare_servers=40
#  ******************************
# 内存大于4G服务器（值可逐级递增）：
# 修改如下参数：
# pm=static
# pm.max_children=100
# ===============================================
if [ "$LNMP_MEM" -gt "3900" ]; then
    sed -i 's:pm = dynamic:pm = static:g' /usr/local/php/etc/php-fpm.conf
    sed -i 's:pm\.max\_children = 5:pm\.max\_children \= 100:g' /usr/local/php/etc/php-fpm.conf
else
    sed -i 's:pm\.max\_children = 5:pm\.max\_children \= 40:g' /usr/local/php/etc/php-fpm.conf
    sed -i 's:pm\.start\_servers = 2:pm\.start\_servers \= 10:g' /usr/local/php/etc/php-fpm.conf
    sed -i 's:pm\.min\_spare\_servers = 1:pm\.min\_spare\_servers \= 10:g' /usr/local/php/etc/php-fpm.conf
    sed -i 's:pm\.max\_spare\_servers = 3:pm\.max\_spare\_servers \= 40:g' /usr/local/php/etc/php-fpm.conf
fi

# modify nginx.conf for php
cp /usr/local/nginx/conf/nginx.conf /usr/local/nginx/conf/nginx.conf.org.bak
sed -i "s:#user\s*nobody;:user $LNMP_USER $LNMP_USER;:g" /usr/local/nginx/conf/nginx.conf
sed -i '/# pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000/a\location \~ \\.php\$ \{\nroot           html;\nfastcgi_pass   127.0.0.1:9000;\nfastcgi_index  index.php;\nfastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;\nfastcgi_param PATH_INFO $fastcgi_path_info;\nfastcgi_param PATH_TRANSLATED $document_root$fastcgi_path_info;\nfastcgi_connect_timeout 60;\nfastcgi_send_timeout    180;\nfastcgi_read_timeout    180;\nfastcgi_buffer_size 128k;\nfastcgi_buffers 4 256k;\nfastcgi_busy_buffers_size 256k;\nfastcgi_temp_file_write_size 256k;\nfastcgi_intercept_errors on;\ninclude        fastcgi_params;\n\}\n' /usr/local/nginx/conf/nginx.conf

cd $cur_dir
cp -rf conf/p.php /usr/local/nginx/html/p.php
cp -rf conf/phpinfo.php /usr/local/nginx/html/phpinfo.php

# create nginx vhost dir
mkdir -pv /usr/local/nginx/conf/vhost
sed -i '/# another virtual host using mix of IP-, name-, and port-based configuration/a\include vhost/*.conf;' /usr/local/nginx/conf/nginx.conf
}

cd $src_dir
mkdir -pv logs
ChooseDependentType
ChooseRunUser

InitInstall 2>&1 | tee -a logs/InitInstall-`date +%Y%m%d`.log
DownloadBasic 2>&1 | tee -a logs/DownloadBasic-`date +%Y%m%d`.log
if [[ "$LNMP_DTYPE" = "1" ]]; then
    InstallDependentByYum 2>&1 | tee -a logs/InstallDependentByYum-`date +%Y%m%d`.log
else
    DownloadDependent 2>&1 | tee -a logs/DownloadDependent-`date +%Y%m%d`.log
    InstallDependentByCompile 2>&1 | tee -a logs/InstallDependentByCompile-`date +%Y%m%d`.log
fi
InstallMYSQL5_5 2>&1 | tee -a logs/InstallMYSQL5_5-`date +%Y%m%d`.log
InstallNginx_1_4 2>&1 | tee -a logs/InstallNginx_1_4-`date +%Y%m%d`.log
InstallPHP5_3 2>&1 | tee -a logs/InstallPHP5_3-`date +%Y%m%d`.log