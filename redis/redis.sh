#!/bin/bash
#########################################
#Function:    install redis
#website:     www.boxcore.org
#Version:     1.0
#########################################
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install redis"
    exit 1
fi

clear
hr="========================================================================="
echo $hr
echo "Install Redis"
echo $hr
# close var cur_dir now
cur_dir=$(pwd)


function ChooseInstallRedisTpye()
{
    echo $hr
    echo "You now have 2 options for your dependent setup."
    echo ""
    echo "1: Install Dependent By Yum"
    echo "2: Install Dependent By Compiled Resource"
    echo $hr
    echo -n "Enter your choice (1 or 2): ";
    read dependent_type

    if [ "$dependent_type" = "1" ]; then
        export LNMP_DTYPE="1"
    elif [ "$dependent_type" = "2" ]; then
        export LNMP_DTYPE="2"
    else
        echo "You input a wrong number, please choose again!"
        ChooseDependentType
    fi
}

#set mysql root password
	echo $hr
	mysqlrootpwd="root"
	echo "Please input the root password of mysql:"
	read -p "(Default password: root):" mysqlrootpwd
	if [ "$mysqlrootpwd" = "" ]; then
		mysqlrootpwd="root"
	fi
	echo "==========================="
	echo "MySQL root password:$mysqlrootpwd"
	echo "==========================="

# install redis server
function InstallRedis()
{
# reffer: http://cuimk.blog.51cto.com/6649029/1317130
wget http://download.redis.io/redis-stable.tar.gz

tar zxf redis-stable.tar.gz
cd redis-stable
make
make install

#set redis conf
mkdir -p /etc/redis
cp redis.conf /etc/redis
sed -i "s:^daemonize no:daemonize yes:g" /etc/redis/redis.conf
# /usr/local/bin/redis-server /etc/redis/redis.conf
cd ../
cp -rf conf/redis-server /etc/init.d/redis-server
chmod 755 /etc/init.d/redis-server
chkconfig redis-server on
}

function InstallRedis_PHP()
{
wget --no-check-certificate http://github.com/owlient/phpredis/tarball/master
tar zxf master
cd owlient-phpredis-90ecd17/
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config
make && make install

cat >> /usr/local/php/etc/php.ini<<eof
[redis]
extension="redis.so"
eof

#/usr/local/php/lib/php/extensions/no-debug-non-zts-20090626/

}
cd $cur_dir
InstallPHP5_3 2>&1 | tee -a InstallPHP5_3-`date +%Y%m%d`.log