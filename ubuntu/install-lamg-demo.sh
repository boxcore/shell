libfcgi-dev libfcgi0ldbl libjpeg62-dbg libmcrypt-dev libssl-dev libbz2-dev libjpeg-dev libfreetype6-dev libpng12-dev libxpm-dev libxml2-dev libpcre3-dev libbz2-dev libcurl4-openssl-dev libjpeg-dev libpng12-dev libxpm-dev libfreetype6-dev libmysqlclient-dev libt1-dev libgd2-xpm-dev libgmp-dev libsasl2-dev libmhash-dev unixodbc-dev freetds-dev libpspell-dev libsnmp-dev libtidy-dev libxslt1-dev libmcrypt-dev libdb5.3-dev


apt-get install autoconf automake libtool re2c flex make libxml2-dev libbz2-dev libcurl3-dev libdb5.1-dev libjpeg-dev libpng-dev libXpm-dev libfreetype6-dev libt1-dev libgmp3-dev libc-client-dev libldap2-dev libmhash-dev freetds-dev libz-dev libmysqlclient15-dev ncurses-dev libpcre3-dev unixODBC-dev libsqlite-dev libaspell-dev libreadline6-dev librecode-dev libsnmp-dev libtidy-dev libxslt-dev openssl libssl-dev libxml2 libpspell-dev libicu-dev libxml2 libxml2-dev libssl-dev pkg-config curl libcurl4-nss-dev enchant libenchant-dev libjpeg8 libjpeg8-dev libpng12-0 libpng12-dev libvpx1 libvpx-dev libfreetype6 libt1-5 libt1-dev libgmp10 libgmp-dev libicu-dev mcrypt libmcrypt4 libmcrypt-dev libpspell-dev libedit2 libedit-dev libxslt1.1 libxslt1-dev



libfcgi-dev libfcgi0ldbl libjpeg62-dbg libmcrypt-dev libssl-dev libbz2-dev libjpeg-dev libfreetype6-dev libpng12-dev libxpm-dev libxml2-dev libpcre3-dev libbz2-dev libcurl4-openssl-dev libjpeg-dev libpng12-dev libxpm-dev libfreetype6-dev libmysqlclient-dev libgd2-xpm-dev libgmp-dev libsasl2-dev libmhash-dev unixodbc-dev freetds-dev libpspell-dev libsnmp-dev libtidy-dev libxslt1-dev libmcrypt-dev libdb5.3-dev

OK:
libfcgi-dev


NO:
libt1-dev


./configure --prefix=/usr/local/php \
--with-apxs2=/usr/local/apache/bin/apxs \
--with-mysql=/usr/local/mysql \
--with-mysqli=/usr/local/mysql/bin/mysql_config \
--with-jpeg-dir=/usr/local \
--with-png-dir=/usr/local \
--with-zlib-dir=/usr/local \
--with-freetype-dir=/usr/local \
--with-iconv-dir=/usr/local \
--enable-gd-native-ttf \
--enable-gd-jis-conv \
--with-gd=/usr/local \
--with-libxml-dir=/usr/local \
--with-mhash=/usr/local \
--with-mcrypt=/usr/local \
--with-openssl=/usr/local \
--with-curl=/usr/local \
--with-curlwrappers \
--enable-bcmath \
--enable-wddx \
--enable-calendar \
--enable-mbstring \
--enable-ftp \
--enable-zip \
--enable-sockets
-----------------------------------------------------------

wget http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.13.1.tar.gz
tar -zxf libiconv-1.13.1.tar.gz 
cd libiconv-1.13.1/
./configure --prefix=/usr/local
make && make install

./configure --prefix=/usr/local/php \
--with-apxs2=/usr/local/apache/bin/apxs \
--with-mysql=/usr/local/mysql \
--with-mysqli=/usr/local/mysql/bin/mysql_config \
--with-jpeg \
--with-png \
--with-zlib \
--with-freetype \
--with-iconv-dir=/usr/local \
--enable-gd-native-ttf \
--enable-gd-jis-conv \
--with-gd \
--with-libxml \
--with-mhash \
--with-mcrypt \
--with-openssl \
--with-curl \
--with-curlwrappers \
--enable-bcmath \
--enable-wddx \
--enable-calendar \
--enable-mbstring \
--enable-ftp \
--enable-zip \
--enable-sockets