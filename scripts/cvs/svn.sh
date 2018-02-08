#!/bin/bash

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

cur_dir=`pwd`

ADD_SVN()
{

while :
do
    echo
    read -p "Please input subversion name: " svn_name
    if [ "`echo $svn_name | grep '^[a-zA-Z]\w*'`" ]; then
        if [ -s "/opt/svn/$svn_name" ]; then
            echo $hr
            echo "SVN BUCKET alrady exist!"
            echo $hr
        else

            break
        fi
    else
        echo -e "\033[31minput error! \033[0m"
    fi
done

svn_dir="/opt/svn/$svn_name"


mkdir -pv $svn_dir
/usr/bin/svnadmin create $svn_dir

cat > $svn_dir/conf/svnserve.conf << EOF
[general]
anon-access = none
auth-access = write
password-db = passwd
authz-db    = authz
[sasl]
EOF


while :
do
    echo
    read -p "Please input svn user name: " svn_username
    if [ -z "`echo $svn_username | grep '[a-zA-Z]\w*'`" ]; then
        echo -e "\033[31minput error! \033[0m"
    else
        echo
        read -p "Please input password for $svn_username: " svn_password
        echo
        read -p "Please input password for $svn_username again: " svn_repassword
        if [[ $svn_password ]] && [[ $svn_password = $svn_repassword ]]; then
            echo "Your svn user password is: $svn_password"
            break
        else
            echo "Input wrong password! "
        fi
    fi
done


cat > $svn_dir/conf/authz << EOF
[aliases]
[groups]
[$svn_name:/]
$svn_username = rw
EOF

cat > $svn_dir/conf/passwd << EOF
[users]
$svn_username = $svn_password
EOF

# add more svn user
ADD_MORE_SVN_USER

/usr/bin/svnserve -d -r /opt/svn/
grep -q "^/usr/bin/svnserve\s*-d\s*-r\s*/opt/svn/" /etc/rc.d/rc.local || echo "/usr/bin/svnserve -d -r /opt/svn/">>/etc/rc.d/rc.local

#
SET_SVN_POST_COMMIT
}

ADD_MORE_SVN_USER()
{

while :
do
    echo ''
        read -p "Do you want to add more SVN user? [y/n]: " moresvnuser_yn 
        if [ "$moresvnuser_yn" != 'y' ] && [ "$moresvnuser_yn" != 'n' ];then
                echo -e "\033[31minput error! Please only input 'y' or 'n'\033[0m"
        else
                break 
        fi
done

if [ "$moresvnuser_yn" == 'y' ]; then
    while :
    do
        echo
        read -p "Type SVN name: " svn_more_username
        if [ -z "`echo $svn_more_username | grep '[a-zA-Z]\w*'`" ]; then
                echo -e "\033[31minput error\033[0m"
        else
        [ "$svn_more_username" == "$svn_username" ] && echo -e "\033[31msvn user name already exists! \033[0m" && continue
            echo
            read -p "Please input password for $svn_more_username: " svn_more_password
            echo
            read -p "Please input password for $svn_more_username again: " svn_more_repassword
            if [[ $svn_more_password ]] && [[ $svn_more_password = $svn_more_repassword ]]; then
                # sed -i "/[$svn_name:/]/a\ $svn_more_username = rw" $svn_dir/conf/authz
                # sed -i "/[users]/a\ $svn_more_username = $svn_more_password" $svn_dir/conf/passwd
                echo "$svn_more_username = rw" >> $svn_dir/conf/authz
                echo "$svn_more_username = $svn_more_password" >> $svn_dir/conf/passwd

                ADD_MORE_SVN_USER
                break
            else
                echo -e "\033[31minput svn_more_password error! \033[0m"
                
            fi
        fi
    done
fi
}

SET_SVN_POST_COMMIT()
{
    while :
    do
        echo ''
            read -p "Do you want to svn post-commit? [y/n]: " postcommit_yn 
            if [ "$postcommit_yn" != 'y' ] && [ "$postcommit_yn" != 'n' ];then
                    echo -e "\033[31minput error! Please only input 'y' or 'n'\033[0m"
            else
                    break 
            fi
    done

    if [ "$postcommit_yn" == 'y' ]; then
        while :
        do
            echo
            read -p "Type svn web dir: " svn_web_dir
            if [ "`echo $svn_web_dir | grep '^/home/www/\w*'`" ]; then
                if [ -s "$svn_web_dir" ]; then
                    #mv -rf $svn_web_dir $svn_web_dir-bak
                    CHECKOUT_WEB_DIR
                else
                    CHECKOUT_WEB_DIR
                fi
########################################
cat > $svn_dir/hooks/post-commit << EOF
#!/bin/sh
SVN=/usr/bin/svn
WEB=$svn_web_dir
\$SVN update \$WEB --username $svn_username --password $svn_password
chown -R www:www \$WEB
EOF
chmod 777 $svn_dir/hooks/post-commit
########################################
                break
            else
                echo -e "\033[31minput error\033[0m"
            fi
        done
    fi
}

CHECKOUT_WEB_DIR()
{
    mkdir -pv $svn_web_dir
    #ip=`/sbin/ifconfig -a|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`
    ip="127.0.0.1"
    /usr/bin/svn checkout svn://$ip/$svn_name $svn_web_dir --username $svn_username --password $svn_password
    chown -R www:www $svn_web_dir
}

ADD_SVN 2>&1 | tee -a addSVN-`date +%Y%m%d`.log
