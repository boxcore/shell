# install 3rd software

## 1. install php5.2 for lnmp
```bash
#in lnmp1.4 
cp -rp ~/shell/install-3rd/enable-php5.2.17.conf /usr/local/nginx/conf/

cp -rp ~/shell/install-3rd/php5.2.17.sh ~/lnmp1.4/
```

then you need to setting nginx vhost conf!


## 2. lnmp.org

### lnmp 1.4 install

```bash
screen -S lnmp

wget -c http://soft.vpser.net/lnmp/lnmp1.4.tar.gz && tar zxf lnmp1.4.tar.gz && cd lnmp1.4 && ./install.sh lnmp
```