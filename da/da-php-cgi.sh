#!/bin/sh
# from http://www.zrblog.net/10237.html
cd /usr/local/directadmin/custombuild
./build update
./build clean
sed -i 's/php5_cli=yes/php5_cli=no/g' options.conf
sed -i 's/php5_cgi=no/php5_cgi=yes/g' options.conf
./build php n
