BxCore Shell 工具说明
=====

boxcore个人linux工具箱, 用于便捷管理linux服务器. 本工具均在centos6环境下测试,如果您使用的其他linux发行版,可能出差, 遇到问题发wiki单询问即可. 

文件说明:

- base.sh 基础命令安装, 安装命令有 `wget git-svn screen vim make unzip gcc gcc-c++`
- clean.sh 精简centos系统, 把centos精简成纯命令端且去掉无用应用软件(游戏,应用软件等)
- get_eth.sh 动态获取所有网卡IP
- lnmp.sh 自动化安装lnmp
- nodejs.sh 安装nodejs
- redis/ 安装redis
- svn.sh 添加svn仓库, 可选择是否添加钩子
- update_resource.sh 修改yum原
- vhost.sh lnmp添加虚拟主机

Modify History
------------------
- 2015-08-16 remove x
