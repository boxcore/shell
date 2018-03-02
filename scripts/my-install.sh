#!/bin/bash
#
####################################
#
# use: 
# curl -o 'init.sh' https://raw.githubusercontent.com/boxcore/shell/master/scripts/my-install.sh && chmod +x my-install.sh && ./my-install.sh
#-----------------------------------
# for centos 5+
# date:2018-03-01
####################################
#


# color.sh
echo=echo
for cmd in echo /bin/echo; do
  $cmd >/dev/null 2>&1 || continue
  if ! $cmd -e "" | grep -qE '^-e'; then
    echo=$cmd
    break
  fi
done
CSI=$($echo -e "\033[")
CEND="${CSI}0m"
CDGREEN="${CSI}32m"
CRED="${CSI}1;31m"
CGREEN="${CSI}1;32m"
CYELLOW="${CSI}1;33m"
CBLUE="${CSI}1;34m"
CMAGENTA="${CSI}1;35m"
CCYAN="${CSI}1;36m"
CSUCCESS="$CDGREEN"
CFAILURE="$CRED"
CQUESTION="$CMAGENTA"
CWARNING="$CYELLOW"
CMSG="$CCYAN"

# check char type
get_char() 
{ 
    SAVEDSTTY=`stty -g` 
    stty -echo 
    stty cbreak 
    dd if=/dev/tty bs=1 count=1 2> /dev/null 
    stty -raw 
    stty echo 
    stty $SAVEDSTTY 
} 


# # 选择多个数字 demo
# while :; do echo
#   echo "Please choose installation of the database:"
#   echo -e "\t${CMSG}1${CEND}. Install database from binary package."
#   echo -e "\t${CMSG}2${CEND}. Install database from source package."
#   read -p "Please input a number:(Default 1 press Enter) " dbInstallMethods
#   [ -z "$dbInstallMethods" ] && dbInstallMethods=1
#   if [[ ! $dbInstallMethods =~ ^[1-2]$ ]]; then
#     echo "${CWARNING}input error! Please only input number 1~2${CEND}"
#   else
#     break
#   fi
# done
# exit;

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install lnmp"
    exit 1
fi

# choice root path to install script
read -p "Plase set the root path(default:/root): " ROOT_PATH

if [ "${ROOT_PATH}" == "" ]; then
    ROOT_PATH='/root'
    echo "Use default Root path: $ROOT_PATH!"
elif [ -d "$ROOT_PATH" ];then
    echo "Root path exist! will install all package for : $ROOT_PATH!"
else
    echo "Root path don't exist! Please create it first!"
fi

CUR_DIR=$(pwd)
echo "now you in path: $CUR_DIR"

#############################################################################
# conf ask start
######################

# ask core
IS_INSTALL_CORE="y"
read -p "Do you want to install Core Script? (y/n, default yes):  " IS_INSTALL_CORE
case "${IS_INSTALL_CORE}" in
[yY][eE][sS]|[yY])
    echo "You will install Core Script."
    IS_INSTALL_CORE="y"
    ;;
[nN][oO]|[nN])
    echo "You will disable the Core Script!"
    IS_INSTALL_CORE="n"
    ;;
*)
    echo "No input,The Core Script will enable."
    IS_INSTALL_CORE="y"
esac;

# ask kde
IS_INSTALL_KDE="y"
read -p "Do you want to install KDE Plasma Workspaces? (y/n, default yes):" IS_INSTALL_KDE
case "${IS_INSTALL_KDE}" in
[yY][eE][sS]|[yY])
    echo "You will install KDE."
    IS_INSTALL_KDE="y"
    ;;
[nN][oO]|[nN])
    echo "You will disable the KDE!"
    IS_INSTALL_KDE="n"
    ;;
*)
    echo "No input,The KDE will enable."
    IS_INSTALL_KDE="y"
esac;
if [ "$IS_INSTALL_KDE" == 'y' ];then
    while :; do
        read -p "请设置VNC远程密码（至少5个字符）: " KDE_PASSWD
        [ -n "`echo $KDE_PASSWD | grep '[+|&]'`" ] && { echo "${CWARNING}input error,not contain a plus sign (+) and & ${CEND}"; continue; }
        if (( ${#KDE_PASSWD} >= 5 )); then
          echo "您设置的VNC密码是：${CBLUE} ${KDE_PASSWD} ${CEND}，请牢记！ "
          break
        else
          echo "${CWARNING}密码最少5个字符!请重新输入 ${CEND}"
        fi

    done
fi

# ask lnmp1.4
# IS_INSTALL_LNMP="y"
# read -p "Do you want to install LNMP 1.4? (y/n, default yes):" IS_INSTALL_LNMP
# case "${IS_INSTALL_LNMP}" in
# [yY][eE][sS]|[yY])
#     echo "You will install KDE."
#     IS_INSTALL_LNMP="y"
#     ;;
# [nN][oO]|[nN])
#     echo "You will disable the KDE!"
#     IS_INSTALL_LNMP="n"
#     ;;
# *)
#     echo "No input,The KDE will enable."
#     IS_INSTALL_LNMP="y"
# esac;
# if [ "$IS_INSTALL_LNMP" == 'y' ];then
#     while :; do
#         read -p "请设置VNC远程密码（至少5个字符）: " KDE_PASSWD
#         [ -n "`echo $KDE_PASSWD | grep '[+|&]'`" ] && { echo "${CWARNING}input error,not contain a plus sign (+) and & ${CEND}"; continue; }
#         if (( ${#KDE_PASSWD} >= 5 )); then
#           echo "您设置的VNC密码是：${CBLUE} ${KDE_PASSWD} ${CEND}，请牢记！ "
#           break
#         else
#           echo "${CWARNING}密码最少5个字符!请重新输入 ${CEND}"
#         fi

#     done
# fi


echo "Install List:"
echo "${CYELLOW}Basic Core: ${IS_INSTALL_CORE}${CEND}"
echo "${CYELLOW}KDE Plasma Workspaces: ${IS_INSTALL_KDE}${CEND}"
echo "Press any key to continue!" 
char=`get_char` 

######################
# conf ask end
#############################################################################



#############################################################################
# CORE start
######################
if [ "$IS_INSTALL_CORE" == 'y' ];then
    echo "Install basic script, just wait for done!"

    # yum install basic pakage
    yum install -y wget expect tar gzip tree net-tools telnet

    curl -o 'init.sh' https://raw.githubusercontent.com/boxcore/shell/master/init.sh && chmod +x init.sh && ./init.sh
fi
######################
# CORE end
#############################################################################



#############################################################################
# KDE start
###########

INSTALL_KDE()
{
yum grouplist
yum groupinstall -y "KDE Plasma Workspaces"
yum install -y tigervnc-server tigervn


expect<<- END 
spawn vncserver
expect "Password:" 
send "${KDE_PASSWD}\n" 
expect "Verify:" 
send "${KDE_PASSWD}\n" 
expect "Would you like to enter a view-only password (y/n)?" 
send "n\n"
expect eof
END

systemctl start vncserver@:1.service
systemctl enable vncserver@:1.service

firewall-cmd --permanent --add-port=5901/tcp 
service firewalld reload
}

if [ "$IS_INSTALL_KDE" == 'y' ];then
    INSTALL_KDE
fi

######################
# KDE end
#############################################################################
