#/bin/bash
chmod +x shadowsocks-go.sh
./shadowsocks-go.sh 2>&1 | tee shadowsocks-go.log
service shadowsocks restart
chkconfig shadowsocks on
