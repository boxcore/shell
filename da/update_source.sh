#!/bin/bash
#########################################
#Function:    update source
#Usage:       bash update_source.sh
#website:     www.mtimer.cn
#Version:     2.5
#########################################

check_os_release()
{
  while true
  do
    os_release=$(grep "Red Hat Enterprise Linux Server release" /etc/issue 2>/dev/null)
    os_release_2=$(grep "Red Hat Enterprise Linux Server release" /etc/redhat-release 2>/dev/null)
    if [ "$os_release" ] && [ "$os_release_2" ]
    then
      if echo "$os_release"|grep "release 5" >/dev/null 2>&1
      then
        os_release=redhat5
        echo "$os_release"
      elif echo "$os_release"|grep "release 6" >/dev/null 2>&1
      then
        os_release=redhat6
        echo "$os_release"
      else
        os_release=""
        echo "$os_release"
      fi
      break
    fi
    os_release=$(grep "CentOS release" /etc/issue 2>/dev/null)
    os_release_2=$(grep "CentOS release" /etc/*release 2>/dev/null)
    if [ "$os_release" ] && [ "$os_release_2" ]
    then
      if echo "$os_release"|grep "release 5" >/dev/null 2>&1
      then
        os_release=centos5
        echo "$os_release"
      elif echo "$os_release"|grep "release 6" >/dev/null 2>&1
      then
        os_release=centos6
        echo "$os_release"
      else
        os_release=""
        echo "$os_release"
      fi
      break
    fi
    os_release=$(grep -i "ubuntu" /etc/issue 2>/dev/null)
    os_release_2=$(grep -i "ubuntu" /etc/lsb-release 2>/dev/null)
    if [ "$os_release" ] && [ "$os_release_2" ]
    then
      if echo "$os_release"|grep "Ubuntu 10" >/dev/null 2>&1
      then
        os_release=ubuntu10
        echo "$os_release"
      elif echo "$os_release"|grep "Ubuntu 12" >/dev/null 2>&1
      then
        os_release=ubuntu12
        echo "$os_release"
      else
        os_release=""
        echo "$os_release"
      fi
      break
    fi
    os_release=$(grep -i "debian" /etc/issue 2>/dev/null)
    os_release_2=$(grep -i "debian" /proc/version 2>/dev/null)
    if [ "$os_release" ] && [ "$os_release_2" ]
    then
      if echo "$os_release"|grep "Linux 6" >/dev/null 2>&1
      then
        os_release=debian6
        echo "$os_release"
      else
        os_release=""
        echo "$os_release"
      fi
      break
    fi
    break
    done
}

modify_rhel5_yum()
{
  rpm --import http://mirrors.ustc.edu.cn/centos/RPM-GPG-KEY-CentOS-5
  cd /etc/yum.repos.d/
  mv -f CentOS-Base.repo CentOS-Base.repo.backup
  wget -O CentOS-Base.repo http://lug.ustc.edu.cn/wiki/_export/code/mirrors/help/centos?codeblock=1
  yum clean metadata
  yum makecache
  cd ~
}

modify_rhel6_yum()
{
  rpm --import http://mirrors.ustc.edu.cn/centos/RPM-GPG-KEY-CentOS-6
  cd /etc/yum.repos.d/
  mv -f CentOS-Base.repo CentOS-Base.repo.backup
  wget -O CentOS-Base.repo http://lug.ustc.edu.cn/wiki/_export/code/mirrors/help/centos?codeblock=2
  yum clean metadata
  yum makecache
  cd ~
}

update_ubuntu10_apt_source()
{
echo -e "\033[40;32mBackup the original configuration file,new name and path is /etc/apt/sources.list.back.\n\033[40;37m"
cp -fp /etc/apt/sources.list /etc/apt/sources.list.back
cat > /etc/apt/sources.list <<EOF
#ubuntu
deb http://cn.archive.ubuntu.com/ubuntu/ maverick main restricted universe multiverse
deb-src http://cn.archive.ubuntu.com/ubuntu/ maverick main restricted universe multiverse
#ustc.edu.cn
deb http://mirrors.ustc.edu.cn/ubuntu/ maverick main universe restricted multiverse
deb-src http://mirrors.ustc.edu.cn/ubuntu/ maverick main universe restricted multiverse
deb http://mirrors.ustc.edu.cn/ubuntu/ maverick-updates universe main multiverse restricted
deb-src http://mirrors.ustc.edu.cn/ubuntu/ maverick-updates universe main multiverse restricted
#lupaworld
deb http://mirror.lupaworld.com/ubuntu/ maverick main universe restricted multiverse
deb-src http://mirror.lupaworld.com/ubuntu/ maverick main universe restricted multiverse
deb http://mirror.lupaworld.com/ubuntu/ maverick-security universe main multiverse restricted
deb-src http://mirror.lupaworld.com/ubuntu/ maverick-security universe main multiverse restricted
deb http://mirror.lupaworld.com/ubuntu/ maverick-updates universe main multiverse restricted
deb http://mirror.lupaworld.com/ubuntu/ maverick-proposed universe main multiverse restricted
deb-src http://mirror.lupaworld.com/ubuntu/ maverick-proposed universe main multiverse restricted
deb http://mirror.lupaworld.com/ubuntu/ maverick-backports universe main multiverse restricted
deb-src http://mirror.lupaworld.com/ubuntu/ maverick-backports universe main multiverse restricted
deb-src http://mirror.lupaworld.com/ubuntu/ maverick-updates universe main multiverse restricted
EOF
apt-get update
}

update_ubuntu12_apt_source()
{
echo -e "\033[40;32mBackup the original configuration file,new name and path is /etc/apt/sources.list.back.\n\033[40;37m"
cp -fp /etc/apt/sources.list /etc/apt/sources.list.back
cat > /etc/apt/sources.list <<EOF
#ubuntu
deb http://cn.archive.ubuntu.com/ubuntu/ precise main restricted universe multiverse
deb http://cn.archive.ubuntu.com/ubuntu/ precise-security main restricted universe multiverse
deb http://cn.archive.ubuntu.com/ubuntu/ precise-updates main restricted universe multiverse
deb http://cn.archive.ubuntu.com/ubuntu/ precise-proposed main restricted universe multiverse
deb http://cn.archive.ubuntu.com/ubuntu/ precise-backports main restricted universe multiverse
deb-src http://cn.archive.ubuntu.com/ubuntu/ precise main restricted universe multiverse
deb-src http://cn.archive.ubuntu.com/ubuntu/ precise-security main restricted universe multiverse
deb-src http://cn.archive.ubuntu.com/ubuntu/ precise-updates main restricted universe multiverse
deb-src http://cn.archive.ubuntu.com/ubuntu/ precise-proposed main restricted universe multiverse
deb-src http://cn.archive.ubuntu.com/ubuntu/ precise-backports main restricted universe multiverse
#ustc.edu.cn
deb http://mirrors.ustc.edu.cn/ubuntu/ precise main restricted
deb-src http://mirrors.ustc.edu.cn/ubuntu/ precise main restricted
deb http://mirrors.ustc.edu.cn/ubuntu/ precise-updates main restricted
deb-src http://mirrors.ustc.edu.cn/ubuntu/ precise-updates main restricted
deb http://mirrors.ustc.edu.cn/ubuntu/ precise universe
deb-src http://mirrors.ustc.edu.cn/ubuntu/ precise universe
deb http://mirrors.ustc.edu.cn/ubuntu/ precise-updates universe
deb-src http://mirrors.ustc.edu.cn/ubuntu/ precise-updates universe
deb http://mirrors.ustc.edu.cn/ubuntu/ precise multiverse
deb-src http://mirrors.ustc.edu.cn/ubuntu/ precise multiverse
deb http://mirrors.ustc.edu.cn/ubuntu/ precise-updates multiverse
deb-src http://mirrors.ustc.edu.cn/ubuntu/ precise-updates multiverse
deb http://mirrors.ustc.edu.cn/ubuntu/ precise-backports main restricted universe multiverse
deb-src http://mirrors.ustc.edu.cn/ubuntu/ precise-backports main restricted universe multiverse
deb http://mirrors.ustc.edu.cn/ubuntu/ precise-security main restricted
deb-src http://mirrors.ustc.edu.cn/ubuntu/ precise-security main restricted
deb http://mirrors.ustc.edu.cn/ubuntu/ precise-security universe
deb-src http://mirrors.ustc.edu.cn/ubuntu/ precise-security universe
deb http://mirrors.ustc.edu.cn/ubuntu/ precise-security multiverse
deb-src http://mirrors.ustc.edu.cn/ubuntu/ precise-security multiverse
deb http://extras.ubuntu.com/ubuntu precise main
deb-src http://extras.ubuntu.com/ubuntu precise main
#sohu
deb http://mirrors.sohu.com/ubuntu/ precise main restricted
deb-src http://mirrors.sohu.com/ubuntu/ precise main restricted
deb http://mirrors.sohu.com/ubuntu/ precise-updates main restricted
deb-src http://mirrors.sohu.com/ubuntu/ precise-updates main restricted
deb http://mirrors.sohu.com/ubuntu/ precise universe
deb-src http://mirrors.sohu.com/ubuntu/ precise universe
deb http://mirrors.sohu.com/ubuntu/ precise-updates universe
deb-src http://mirrors.sohu.com/ubuntu/ precise-updates universe
deb http://mirrors.sohu.com/ubuntu/ precise multiverse
deb-src http://mirrors.sohu.com/ubuntu/ precise multiverse
deb http://mirrors.sohu.com/ubuntu/ precise-updates multiverse
deb-src http://mirrors.sohu.com/ubuntu/ precise-updates multiverse
deb http://mirrors.sohu.com/ubuntu/ precise-backports main restricted universe multiverse
deb-src http://mirrors.sohu.com/ubuntu/ precise-backports main restricted universe multiverse
deb http://mirrors.sohu.com/ubuntu/ precise-security main restricted
deb-src http://mirrors.sohu.com/ubuntu/ precise-security main restricted
deb http://mirrors.sohu.com/ubuntu/ precise-security universe
deb-src http://mirrors.sohu.com/ubuntu/ precise-security universe
deb http://mirrors.sohu.com/ubuntu/ precise-security multiverse
deb-src http://mirrors.sohu.com/ubuntu/ precise-security multiverse
deb http://extras.ubuntu.com/ubuntu precise main
deb-src http://extras.ubuntu.com/ubuntu precise main
#cn99
deb http://ubuntu.cn99.com/ubuntu/ precise main restricted universe multiverse
deb http://ubuntu.cn99.com/ubuntu/ precise-updates main restricted universe multiverse
deb http://ubuntu.cn99.com/ubuntu/ precise-security main restricted universe multiverse
deb http://ubuntu.cn99.com/ubuntu/ precise-backports main restricted universe multiverse
#uestc
deb http://ubuntu.uestc.edu.cn/ubuntu/ precise main restricted universe multiverse
deb http://ubuntu.uestc.edu.cn/ubuntu/ precise-backports main restricted universe multiverse
deb http://ubuntu.uestc.edu.cn/ubuntu/ precise-proposed main restricted universe multiverse
deb http://ubuntu.uestc.edu.cn/ubuntu/ precise-security main restricted universe multiverse
deb http://ubuntu.uestc.edu.cn/ubuntu/ precise-updates main restricted universe multiverse
deb-src http://ubuntu.uestc.edu.cn/ubuntu/ precise main restricted universe multiverse
deb-src http://ubuntu.uestc.edu.cn/ubuntu/ precise-backports main restricted universe multiverse
deb-src http://ubuntu.uestc.edu.cn/ubuntu/ precise-proposed main restricted universe multiverse
deb-src http://ubuntu.uestc.edu.cn/ubuntu/ precise-security main restricted universe multiverse
deb-src http://ubuntu.uestc.edu.cn/ubuntu/ precise-updates main restricted universe multiverse
#ustc
deb http://debian.ustc.edu.cn/ubuntu/ precise main restricted universe multiverse
deb http://debian.ustc.edu.cn/ubuntu/ precise-backports restricted universe multiverse
deb http://debian.ustc.edu.cn/ubuntu/ precise-proposed main restricted universe multiverse
deb http://debian.ustc.edu.cn/ubuntu/ precise-security main restricted universe multiverse
deb http://debian.ustc.edu.cn/ubuntu/ precise-updates main restricted universe multiverse
deb-src http://debian.ustc.edu.cn/ubuntu/ precise main restricted universe multiverse
deb-src http://debian.ustc.edu.cn/ubuntu/ precise-backports main restricted universe multiverse
deb-src http://debian.ustc.edu.cn/ubuntu/ precise-proposed main restricted universe multiverse
deb-src http://debian.ustc.edu.cn/ubuntu/ precise-security main restricted universe multiverse
deb-src http://debian.ustc.edu.cn/ubuntu/ precise-updates main restricted universe multiverse
#bjtu
deb http://mirror.bjtu.edu.cn/ubuntu/ precise main multiverse restricted universe
deb http://mirror.bjtu.edu.cn/ubuntu/ precise-backports main multiverse restricted universe
deb http://mirror.bjtu.edu.cn/ubuntu/ precise-proposed main multiverse restricted universe
deb http://mirror.bjtu.edu.cn/ubuntu/ precise-security main multiverse restricted universe
deb http://mirror.bjtu.edu.cn/ubuntu/ precise-updates main multiverse restricted universe
deb-src http://mirror.bjtu.edu.cn/ubuntu/ precise main multiverse restricted universe
deb-src http://mirror.bjtu.edu.cn/ubuntu/ precise-backports main multiverse restricted universe
deb-src http://mirror.bjtu.edu.cn/ubuntu/ precise-proposed main multiverse restricted universe
deb-src http://mirror.bjtu.edu.cn/ubuntu/ precise-security main multiverse restricted universe
deb-src http://mirror.bjtu.edu.cn/ubuntu/ precise-updates main multiverse restricted universe
#lupaworld
deb http://mirror.lupaworld.com/ubuntu/ precise main universe restricted multiverse
deb-src http://mirror.lupaworld.com/ubuntu/ precise main universe restricted multiverse
deb http://mirror.lupaworld.com/ubuntu/ precise-security universe main multiverse restricted
deb-src http://mirror.lupaworld.com/ubuntu/ precise-security universe main multiverse restricted
deb http://mirror.lupaworld.com/ubuntu/ precise-updates universe main multiverse restricted
deb http://mirror.lupaworld.com/ubuntu/ precise-proposed universe main multiverse restricted
deb-src http://mirror.lupaworld.com/ubuntu/ precise-proposed universe main multiverse restricted
deb http://mirror.lupaworld.com/ubuntu/ precise-backports universe main multiverse restricted
deb-src http://mirror.lupaworld.com/ubuntu/ precise-backports universe main multiverse restricted
deb-src http://mirror.lupaworld.com/ubuntu/ precise-updates universe main multiverse restricte
EOF
apt-get update
}


update_debian_apt_source()
{
echo -e "\033[40;32mBackup the original configuration file,new name and path is /etc/apt/sources.list.back.\n\033[40;37m"
cp -fp /etc/apt/sources.list /etc/apt/sources.list.back
cat > /etc/apt/sources.list <<EOF
#ustc.edu.cn
deb http://mirrors.ustc.edu.cn/debian squeeze main contrib non-free
deb-src http://mirrors.ustc.edu.cn/debian squeeze main contrib non-free
#debian
deb http://security.debian.org/ squeeze/updates main contrib
deb-src http://security.debian.org/ squeeze/updates main contrib
deb http://ftp.debian.org/debian/ squeeze-updates main contrib
deb-src http://ftp.debian.org/debian/ squeeze-updates main contrib
#cdn
deb http://cdn.debian.net/debian/ squeeze main
deb-src http://cdn.debian.net/debian/ squeeze main
deb http://cdn.debian.net/debian/ squeeze-updates main contrib
deb-src http://cdn.debian.net/debian/ squeeze-updates main contrib
#sohu
deb http://mirrors.sohu.com/debian squeeze main contrib non-free
deb-src http://mirrors.sohu.com/debian squeeze main contrib non-free
#ustc.edu.cn update
deb http://mirrors.ustc.edu.cn/debian squeeze-proposed-updates main contrib non-free
deb-src http://mirrors.ustc.edu.cn/debian squeeze-proposed-updates main contrib non-free
#queeze-backports
deb http://mirrors.ustc.edu.cn/debian-backports/ squeeze-backports main contrib non-free
deb-src http://mirrors.ustc.edu.cn/debian-backports/ squeeze-backports main contrib non-free
#sohu update
deb http://mirrors.sohu.com/debian squeeze-proposed-updates main contrib non-free
deb-src http://mirrors.sohu.com/debian squeeze-proposed-updates main contrib non-free
#sjtu
deb http://ftp.sjtu.edu.cn/debian/ squeeze main non-free contrib
deb http://ftp.sjtu.edu.cn/debian/ squeeze-proposed-updates main non-free contrib
deb http://ftp.sjtu.edu.cn/debian-security/ squeeze/updates main non-free contrib
EOF
apt-get update
}

####################Start###################
#check lock file ,one time only let the script run one time 
LOCKfile=/tmp/.$(basename $0)
if [ -f "$LOCKfile" ]
then
  echo -e "\033[1;40;31mThe script is already exist,please next time to run this script.\n\033[0m"
  exit
else
  echo -e "\033[40;32mStep 1.No lock file,begin to create lock file and continue.\n\033[40;37m"
  touch $LOCKfile
fi

#check user
if [ $(id -u) != "0" ]
then
  echo -e "\033[1;40;31mError: You must be root to run this script, please use root to install this script.\n\033[0m"
  rm -rf $LOCKfile
  exit 1
fi
echo -e "\033[40;32mStep 2.Begen to check the OS issue.\n\033[40;37m"
os_release=$(check_os_release)
if [ "X$os_release" == "X" ]
then
  echo -e "\033[1;40;31mThe OS does not identify,So this script is not executede.\n\033[0m"
  rm -rf $LOCKfile
  exit 0
else
  echo -e "\033[40;32mThis OS is $os_release.\n\033[40;37m"
fi

echo -e "\033[40;32mStep 3.Begen to modify the source configration file and update.\n\033[40;37m"
case "$os_release" in
redhat5|centos5)
  modify_rhel5_yum
  ;;
redhat6|centos6)
  modify_rhel6_yum
  ;;
ubuntu10)
  update_ubuntu10_apt_source
  ;;
ubuntu12)
  update_ubuntu12_apt_source
  ;;
debian6)
  update_debian_apt_source
  ;;
esac
echo -e "\033[40;32mSuccess,exit now!\n\033[40;37m"
rm -rf $LOCKfile