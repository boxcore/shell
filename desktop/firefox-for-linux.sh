#!/bin/bash
#
# http://blog.csdn.net/u012923403/article/details/78617131

wget https://download-installer.cdn.mozilla.net/pub/firefox/releases/57.0.3/linux-x86_64/en-US/firefox-57.0.3.tar.bz2
tar jxvf firefox-57.0.3.tar.bz2 -C /opt/

cd /usr/share/applications/
sudo cp firefox.desktop firefox-quantum.desktop 
sudo vi firefox-quantum.desktop

## vim 编辑配置 添加下面内容
Exec=/opt/firefox/firefox %u
Exec=/opt/firefox/firefox -new-window
Exec=/opt/firefox/firefox -private-window
Icon=/opt/firefox/browser/icons/mozicon128.png
