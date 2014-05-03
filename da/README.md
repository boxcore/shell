da 面板安装说明
==============

da面板安装说明
-------------
1. 国内yum源有时候不稳定，建议先更新下源

	chmod 755 update_source.sh;./update_source.sh

2. 执行安装代码 - 

Chinese version

	chmod 755 da1443.sh;./da1443.sh 2>&1|tee directadmin_install.log

English version - One line command:

	chmod 755 da1443-en.sh;./da1443-en.sh 2>&1|tee directadmin_install.log

安装过程中需要填写:
用户ID（Client ID）: 随便填
授权ID（License ID）: 随便填
主机名： 比如 server.domain.com

安装好后密码：
vi /usr/local/directadmin/scripts/setup.txt 

安装完成后，最后显示的那段信息，包含了后台登录地址、帐号和密码。

默认皮肤为Capri，界面为 中文，如果要修改可以修改文件：
/usr/local/directadmin/data/users/admin/user.conf

如果你安装完成后改为使用 Nginx + php-fpm 需要修改文件：
/usr/local/directadmin/data/admin
将 httpd=ON 改成 nginx=ON

上面两步都需要重启DA:
service directadmin restart


DirectAdmin 换IP
--------------------------
授权更改IP
参考：http://help.directadmin.com/item.php?id=30
cd /usr/local/directadmin/scripts 
./getLicense.sh 123 1234 1.2.3.4
service directadmin restart 

123与1234分别是Client ID and License ID

3.在服务器上更新IP   /usr/local/directadmin/scripts/ipswap.sh 老IP  新IP
service directadmin restart  OK了