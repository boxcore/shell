BOXCORE - LAMP 自动安装包
===================

*说明：编译zlib时候最好不指定目录，否则每次编译一个依赖包都会要求输入“--with-zlib-dir=/usr/local/zlib”*

概述
-----------
BOXCORE-LAMP是在CentOS下自动安装apache、mysql和php的脚本，目前最新版本是v0.1版，此版本中使用服务包的版本分别为：

- 	Apache v2.2.9
- 	PHP v5.2.6
- 	MySQL v5.1.59
- 	Memcached v1.4.10

 目前只在CentOS 6.5 minimal 版本上测试过，其他版本是适用行未知。后期将添加更高版本的php和apache自动安装程序，和添加各种优化配置的版本。

使用方法
-------------------

###  方法一：通过Git下载（推荐） ###

	yum -y install git
	git clone https://github.com/boxcore/boxcore-lamp.git lamp
	cd lamp && chmod 755 install.sh && ./install.sh

###  方法二：直接下载安装 ###

	wget http://mirrors.boxcore.org/lamp/install.sh
	chmod 755 install.sh
	./install.sh

联系方式
--------

> Email: [boxcore#live.com](boxcore#live.com) （推荐）   
> Blog: [BoxCore Blog](http://blog.boxcore.org/)  

后期扩展版本计划
----------------

- **lamp-bro.sh：** LAMPBRODER（兄弟连）lamp安装版
- **lamp-stabe.sh：** Apache2.2 + MySQL5.5 + PHP5.3

TODO
-----------------
- MySQL运行权限问题未解决
