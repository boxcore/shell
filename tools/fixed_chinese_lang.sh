#!/bin/bash
# 
# 

locale # 查看当前系统默认采用的字符集

yum -y groupinstall chinese-support # 安装中文支持

vi /etc/sysconfig/i18n #
```bash
LANG=C
SYSFONT=latarcyrheb-sun16
```

## 临时生效
# export LANG="zh_CN.UTF-8"    # 设置为中文
# export LANG="en_US.UTF-8"    # 设置为英文，我比较喜欢这样 export LANG=C

```bash
LANG=en_US.UTF-8
LANG=C
SYSFONT=latarcyrheb-sun16
```

# 重新载入
. /etc/profile