#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#	System Required: CentOS/Debian/Ubuntu
#	Description: Aria2
#	Version: 1.1.4
#	Author: Toyo
#	Blog: https://doub.io/shell-jc4/
#=================================================
sh_ver="1.1.4"
file="/root/.aria2"
aria2_conf="/root/.aria2/aria2.conf"
aria2_log="/root/.aria2/aria2.log"
Folder="/usr/local/aria2"
aria2c="/usr/bin/aria2c"

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"

#检查系统
check_sys(){
	if [[ -f /etc/redhat-release ]]; then
		release="centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
    fi
	bit=`uname -m`
}
check_installed_status(){
	[[ ! -e ${aria2c} ]] && echo -e "${Error} Aria2 没有安装，请检查 !" && exit 1
	[[ ! -e ${aria2_conf} ]] && echo -e "${Error} Aria2 配置文件不存在，请检查 !" && [[ $1 != "un" ]] && exit 1
}
check_pid(){
	PID=`ps -ef| grep "aria2c"| grep -v grep| grep -v ".sh"| grep -v "init.d"| grep -v "service"| awk '{print $2}'`
}
check_new_ver(){
	aria2_new_ver=$(wget -qO- "https://github.com/q3aql/aria2-static-builds/tags"| grep "/q3aql/aria2-static-builds/releases/tag/"| head -n 1| awk -F "/tag/v" '{print $2}'| sed 's/\">//')
	if [[ -z ${aria2_new_ver} ]]; then
		echo -e "${Error} Aria2 最新版本获取失败，请手动获取最新版本号[ https://github.com/q3aql/aria2-static-builds/releases ]"
		stty erase '^H' && read -p "请输入版本号 [ 格式如 1.33.1 ] :" aria2_new_ver
		[[ -z "${aria2_new_ver}" ]] && echo "取消..." && exit 1
	else
		echo -e "${Info} 检测到 Aria2 最新版本为 [ ${aria2_new_ver} ]"
	fi
}
Download_aria2(){
	cd "/usr/local"
	if [[ ${bit} == "x86_64" ]]; then
		wget -N --no-check-certificate "https://github.com/q3aql/aria2-static-builds/releases/download/v${aria2_new_ver}/aria2-${aria2_new_ver}-linux-gnu-64bit-build1.tar.bz2"
		Aria2_Name="aria2-${aria2_new_ver}-linux-gnu-64bit-build1"
	else
		wget -N --no-check-certificate "https://github.com/q3aql/aria2-static-builds/releases/download/v${aria2_new_ver}/aria2-${aria2_new_ver}-linux-gnu-32bit-build1.tar.bz2"
		Aria2_Name="aria2-${aria2_new_ver}-linux-gnu-32bit-build1"
	fi
	[[ ! -e "${Aria2_Name}.tar.bz2" ]] && echo -e "${Error} Aria2 压缩包下载失败 !" && exit 1
	tar jxvf "${Aria2_Name}.tar.bz2"
	[[ ! -e "/usr/local/${Aria2_Name}" ]] && echo -e "${Error} Aria2 解压失败 !" && rm -rf "${Aria2_Name}.tar.bz2" && exit 1
	mv "/usr/local/${Aria2_Name}" "${Folder}"
	[[ ! -e "${Folder}" ]] && echo -e "${Error} Aria2 文件夹重命名失败 !" && rm -rf "${Aria2_Name}.tar.bz2" && rm -rf "/usr/local/${Aria2_Name}" && exit 1
	rm -rf "${Aria2_Name}.tar.bz2"
	cd "${Folder}"
	make install
	[[ ! -e ${aria2c} ]] && echo -e "${Error} Aria2 主程序安装失败！" && rm -rf "${Folder}" && exit 1
	chmod +x aria2c
	echo -e "${Info} Aria2 主程序安装完毕！开始下载配置文件..."
}
Download_aria2_conf(){
	mkdir "${file}" && cd "${file}"
	wget --no-check-certificate -N "https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/other/Aria2/aria2.conf"
	[[ ! -s "aria2.conf" ]] && echo -e "${Error} Aria2 配置文件下载失败 !" && rm -rf "${file}" && exit 1
	wget --no-check-certificate -N "https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/other/Aria2/dht.dat"
	[[ ! -s "dht.dat" ]] && echo -e "${Error} Aria2 DHT文件下载失败 !" && rm -rf "${file}" && exit 1
	echo '' > aria2.session
}
Service_aria2(){
	if [[ ${release} = "centos" ]]; then
		if ! wget --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/other/aria2_centos -O /etc/init.d/aria2; then
			echo -e "${Error} Aria2服务 管理脚本下载失败 !" && exit 1
		fi
		chmod +x /etc/init.d/aria2
		chkconfig --add aria2
		chkconfig aria2 on
	else
		if ! wget --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/other/aria2_debian -O /etc/init.d/aria2; then
			echo -e "${Error} Aria2服务 管理脚本下载失败 !" && exit 1
		fi
		chmod +x /etc/init.d/aria2
		update-rc.d -f aria2 defaults
	fi
	echo -e "${Info} Aria2服务 管理脚本下载完成 !"
}
Installation_dependency(){
	if [[ ${release} = "centos" ]]; then
		yum update
		yum -y groupinstall "Development Tools"
		yum install vim -y
	else
		apt-get update
		apt-get install vim build-essential -y
	fi
}
Install_aria2(){
	[[ -e ${aria2c} ]] && echo -e "${Error} Aria2 已安装，请检查 !" && exit 1
	check_sys
	echo -e "${Info} 开始安装/配置 依赖..."
	Installation_dependency
	echo -e "${Info} 开始下载/安装 主程序..."
	check_new_ver
	Download_aria2
	echo -e "${Info} 开始下载/安装 配置文件..."
	Download_aria2_conf
	echo -e "${Info} 开始下载/安装 服务脚本(init)..."
	Service_aria2
	Read_config
	aria2_RPC_port=${aria2_port}
	echo -e "${Info} 开始设置 iptables防火墙..."
	Set_iptables
	echo -e "${Info} 开始添加 iptables防火墙规则..."
	Add_iptables
	echo -e "${Info} 开始保存 iptables防火墙规则..."
	Save_iptables
	echo -e "${Info} 所有步骤 安装完毕，开始启动..."
	Start_aria2
}
Start_aria2(){
	check_installed_status
	check_pid
	[[ ! -z ${PID} ]] && echo -e "${Error} Aria2 正在运行，请检查 !" && exit 1
	/etc/init.d/aria2 start
}
Stop_aria2(){
	check_installed_status
	check_pid
	[[ -z ${PID} ]] && echo -e "${Error} Aria2 没有运行，请检查 !" && exit 1
	/etc/init.d/aria2 stop
}
Restart_aria2(){
	check_installed_status
	check_pid
	[[ ! -z ${PID} ]] && /etc/init.d/aria2 stop
	/etc/init.d/aria2 start
}
Set_aria2(){
	check_installed_status
	echo && echo -e "你要做什么？
 ${Green_font_prefix}1.${Font_color_suffix}  修改 Aria2 RPC密码
 ${Green_font_prefix}2.${Font_color_suffix}  修改 Aria2 RPC端口
 ${Green_font_prefix}3.${Font_color_suffix}  修改 Aria2 文件下载位置
 ${Green_font_prefix}4.${Font_color_suffix}  修改 Aria2 密码+端口+文件下载位置
 ${Green_font_prefix}5.${Font_color_suffix}  手动 打开配置文件修改" && echo
	stty erase '^H' && read -p "(默认: 取消):" aria2_modify
	[[ -z "${aria2_modify}" ]] && echo "已取消..." && exit 1
	if [[ ${aria2_modify} == "1" ]]; then
		Set_aria2_RPC_passwd
	elif [[ ${aria2_modify} == "2" ]]; then
		Set_aria2_RPC_port
	elif [[ ${aria2_modify} == "3" ]]; then
		Set_aria2_RPC_dir
	elif [[ ${aria2_modify} == "4" ]]; then
		Set_aria2_RPC_passwd_port_dir
	elif [[ ${aria2_modify} == "5" ]]; then
		Set_aria2_vim_conf
	else
		echo -e "${Error} 请输入正确的数字(1-5)" && exit 1
	fi
}
Set_aria2_RPC_passwd(){
	read_123=$1
	if [[ ${read_123} != "1" ]]; then
		Read_config
	fi
	if [[ -z "${aria2_passwd}" ]]; then
		aria2_passwd_1="空(没有检测到配置，可能手动删除或注释了)"
	else
		aria2_passwd_1=${aria2_passwd}
	fi
	echo -e "请输入要设置的 Aria2 RPC密码(旧密码为：${Green_font_prefix}${aria2_passwd_1}${Font_color_suffix})"
	stty erase '^H' && read -p "(默认密码: doub.io 密码请不要包含等号 = 和井号 #):" aria2_RPC_passwd
	echo
	[[ -z "${aria2_RPC_passwd}" ]] && aria2_RPC_passwd="doub.io"
	if [[ "${aria2_passwd}" != "${aria2_RPC_passwd}" ]]; then
		if [[ -z "${aria2_passwd}" ]]; then
			echo -e "\nrpc-secret=${aria2_RPC_passwd}" >> ${aria2_conf}
			if [[ $? -eq 0 ]];then
				echo -e "${Info} 密码修改成功！新密码为：${Green_font_prefix}${aria2_RPC_passwd}${Font_color_suffix}(因为找不到旧配置参数，所以自动加入配置文件底部)"
				if [[ ${read_123} != "1" ]]; then
					Restart_aria2
				fi
			else 
				echo -e "${Error} 密码修改失败！旧密码为：${Green_font_prefix}${aria2_passwd}${Font_color_suffix}"
			fi
		else
			sed -i 's/^rpc-secret='${aria2_passwd}'/rpc-secret='${aria2_RPC_passwd}'/g' ${aria2_conf}
			if [[ $? -eq 0 ]];then
				echo -e "${Info} 密码修改成功！新密码为：${Green_font_prefix}${aria2_RPC_passwd}${Font_color_suffix}"
				if [[ ${read_123} != "1" ]]; then
					Restart_aria2
				fi
			else 
				echo -e "${Error} 密码修改失败！旧密码为：${Green_font_prefix}${aria2_passwd}${Font_color_suffix}"
			fi
		fi
	else
		echo -e "${Error} 新密码与旧密码一致，取消..."
	fi
}
Set_aria2_RPC_port(){
	read_123=$1
	if [[ ${read_123} != "1" ]]; then
		Read_config
	fi
	if [[ -z "${aria2_port}" ]]; then
		aria2_port_1="空(没有检测到配置，可能手动删除或注释了)"
	else
		aria2_port_1=${aria2_port}
	fi
	echo -e "请输入要设置的 Aria2 RPC端口(旧端口为：${Green_font_prefix}${aria2_port_1}${Font_color_suffix})"
	stty erase '^H' && read -p "(默认端口: 6800):" aria2_RPC_port
	echo
	[[ -z "${aria2_RPC_port}" ]] && aria2_RPC_port="6800"
	if [[ "${aria2_port}" != "${aria2_RPC_port}" ]]; then
		if [[ -z "${aria2_port}" ]]; then
			echo -e "\nrpc-listen-port=${aria2_RPC_port}" >> ${aria2_conf}
			if [[ $? -eq 0 ]];then
				echo -e "${Info} 端口修改成功！新端口为：${Green_font_prefix}${aria2_RPC_port}${Font_color_suffix}(因为找不到旧配置参数，所以自动加入配置文件底部)"
				Del_iptables
				Add_iptables
				Save_iptables
				if [[ ${read_123} != "1" ]]; then
					Restart_aria2
				fi
			else 
				echo -e "${Error} 端口修改失败！旧端口为：${Green_font_prefix}${aria2_port}${Font_color_suffix}"
			fi
		else
			sed -i 's/^rpc-listen-port='${aria2_port}'/rpc-listen-port='${aria2_RPC_port}'/g' ${aria2_conf}
			if [[ $? -eq 0 ]];then
				echo -e "${Info} 端口修改成功！新密码为：${Green_font_prefix}${aria2_RPC_port}${Font_color_suffix}"
				Del_iptables
				Add_iptables
				Save_iptables
				if [[ ${read_123} != "1" ]]; then
					Restart_aria2
				fi
			else 
				echo -e "${Error} 端口修改失败！旧密码为：${Green_font_prefix}${aria2_port}${Font_color_suffix}"
			fi
		fi
	else
		echo -e "${Error} 新端口与旧端口一致，取消..."
	fi
}
Set_aria2_RPC_dir(){
	read_123=$1
	if [[ ${read_123} != "1" ]]; then
		Read_config
	fi
	if [[ -z "${aria2_dir}" ]]; then
		aria2_dir_1="空(没有检测到配置，可能手动删除或注释了)"
	else
		aria2_dir_1=${aria2_dir}
	fi
	echo -e "请输入要设置的 Aria2 文件下载位置(旧位置为：${Green_font_prefix}${aria2_dir_1}${Font_color_suffix})"
	stty erase '^H' && read -p "(默认位置: /usr/local/caddy/www/aria2/Download):" aria2_RPC_dir
	[[ -z "${aria2_RPC_dir}" ]] && aria2_RPC_dir="/usr/local/caddy/www/aria2/Download"
	echo
	if [[ -d "${aria2_RPC_dir}" ]]; then
		if [[ "${aria2_dir}" != "${aria2_RPC_dir}" ]]; then
			if [[ -z "${aria2_dir}" ]]; then
				echo -e "\ndir=${aria2_RPC_dir}" >> ${aria2_conf}
				if [[ $? -eq 0 ]];then
					echo -e "${Info} 位置修改成功！新位置为：${Green_font_prefix}${aria2_RPC_dir}${Font_color_suffix}(因为找不到旧配置参数，所以自动加入配置文件底部)"
					if [[ ${read_123} != "1" ]]; then
						Restart_aria2
					fi
				else 
					echo -e "${Error} 位置修改失败！旧位置为：${Green_font_prefix}${aria2_dir}${Font_color_suffix}"
				fi
			else
				aria2_dir_2=$(echo "${aria2_dir}"|sed 's/\//\\\//g')
				aria2_RPC_dir_2=$(echo "${aria2_RPC_dir}"|sed 's/\//\\\//g')
				sed -i 's/^dir='${aria2_dir_2}'/dir='${aria2_RPC_dir_2}'/g' ${aria2_conf}
				if [[ $? -eq 0 ]];then
					echo -e "${Info} 位置修改成功！新位置为：${Green_font_prefix}${aria2_RPC_dir}${Font_color_suffix}"
					if [[ ${read_123} != "1" ]]; then
						Restart_aria2
					fi
				else 
					echo -e "${Error} 位置修改失败！旧位置为：${Green_font_prefix}${aria2_dir}${Font_color_suffix}"
				fi
			fi
		else
			echo -e "${Error} 新位置与旧位置一致，取消..."
		fi
	else
		echo -e "${Error} 新位置文件夹不存在，请检查！新位置为：${Green_font_prefix}${aria2_RPC_dir}${Font_color_suffix}"
	fi
}
Set_aria2_RPC_passwd_port_dir(){
	Read_config
	Set_aria2_RPC_passwd "1"
	Set_aria2_RPC_port "1"
	Set_aria2_RPC_dir "1"
	Restart_aria2
}
Set_aria2_vim_conf(){
	Read_config
	aria2_port_old=${aria2_port}
	echo -e "${Tip} 手动修改配置文件须知（VIM 编辑器）：
${Green_font_prefix}1.${Font_color_suffix} 配置文件中含有中文注释，如果你的服务器或SSH工具不支持中文现在，将会乱码(请本地编辑)。
${Green_font_prefix}2.${Font_color_suffix} 打开配置文件后，按 ${Green_font_prefix}I键${Font_color_suffix} 进入编辑模式(左下角显示 ${Green_font_prefix}-- INSERT --${Font_color_suffix})，然后就可以编辑文件了，
   编辑文件完成后，按 ${Green_font_prefix}Esc键${Font_color_suffix} 退出编辑模式，然后输入 ${Green_font_prefix}:wq${Font_color_suffix} (半角 小写)回车，即保存并退出。
${Green_font_prefix}3.${Font_color_suffix} 如果你不想要保存，那么按 ${Green_font_prefix}Esc键${Font_color_suffix} 退出编辑模式，然后输入 ${Green_font_prefix}:q!${Font_color_suffix} (半角 小写)回车，即不保存退出。
${Green_font_prefix}4.${Font_color_suffix} 如果你打算在本地编辑配置文件，那么配置文件位置： ${Green_font_prefix}/root/.aria2/aria2.conf${Font_color_suffix} (注意是隐藏目录) 。" && echo
	stty erase '^H' && read -p "如果理解 VIM 使用方法，请按任意键继续，如要取消请使用 Ctrl+C 。" var
	vim ${aria2_conf}
	Read_config
	if [[ ${aria2_port_old} != ${aria2_port} ]]; then
		aria2_RPC_port=${aria2_port}
		aria2_port=${aria2_port_old}
		Del_iptables
		Add_iptables
		Save_iptables
	fi
	Restart_aria2
}
Read_config(){
	status_type=$1
	if [[ ! -e ${aria2_conf} ]]; then
		if [[ ${status_type} != "un" ]]; then
			echo -e "${Error} Aria2 配置文件不存在 !" && exit 1
		fi
	else
		conf_text=$(cat ${aria2_conf}|grep -v '#')
		aria2_dir=$(echo -e "${conf_text}"|grep "dir="|awk -F "=" '{print $NF}')
		aria2_port=$(echo -e "${conf_text}"|grep "rpc-listen-port="|awk -F "=" '{print $NF}')
		aria2_passwd=$(echo -e "${conf_text}"|grep "rpc-secret="|awk -F "=" '{print $NF}')
	fi
	
}
View_Aria2(){
	check_installed_status
	Read_config
	ip=$(wget -qO- -t1 -T2 ipinfo.io/ip)
	if [[ -z "${ip}" ]]; then
		ip=$(wget -qO- -t1 -T2 api.ip.sb/ip)
		if [[ -z "${ip}" ]]; then
			ip=$(wget -qO- -t1 -T2 members.3322.org/dyndns/getip)
			if [[ -z "${ip}" ]]; then
				ip="VPS_IP(外网IP检测失败)"
			fi
		fi
	fi
	[[ -z "${aria2_dir}" ]] && aria2_dir="找不到配置参数"
	[[ -z "${aria2_port}" ]] && aria2_port="找不到配置参数"
	[[ -z "${aria2_passwd}" ]] && aria2_passwd="找不到配置参数(或无密码)"
	clear
	echo -e "\nAria2 简单配置信息：\n
 地址\t: ${Green_font_prefix}${ip}${Font_color_suffix}
 端口\t: ${Green_font_prefix}${aria2_port}${Font_color_suffix}
 密码\t: ${Green_font_prefix}${aria2_passwd}${Font_color_suffix}
 目录\t: ${Green_font_prefix}${aria2_dir}${Font_color_suffix}\n"
}
View_Log(){
	[[ ! -e ${aria2_log} ]] && echo -e "${Error} Aria2 日志文件不存在 !" && exit 1
	echo && echo -e "${Tip} 按 ${Red_font_prefix}Ctrl+C${Font_color_suffix} 终止查看日志" && echo
	tail -f ${aria2_log}
}
Uninstall_aria2(){
	check_installed_status "un"
	echo "确定要卸载 Aria2 ? (y/N)"
	echo
	stty erase '^H' && read -p "(默认: n):" unyn
	[[ -z ${unyn} ]] && unyn="n"
	if [[ ${unyn} == [Yy] ]]; then
		check_pid
		[[ ! -z $PID ]] && kill -9 ${PID}
		Read_config "un"
		Del_iptables
		Save_iptables
		cd "${Folder}"
		make uninstall
		cd ..
		rm -rf "${aria2c}"
		rm -rf "${Folder}"
		rm -rf "${file}"
		if [[ ${release} = "centos" ]]; then
			chkconfig --del aria2
		else
			update-rc.d -f aria2 remove
		fi
		rm -rf "/etc/init.d/aria2"
		echo && echo "Aria2 卸载完成 !" && echo
	else
		echo && echo "卸载已取消..." && echo
	fi
}
Add_iptables(){
	iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport ${aria2_RPC_port} -j ACCEPT
	iptables -I INPUT -m state --state NEW -m udp -p udp --dport ${aria2_RPC_port} -j ACCEPT
}
Del_iptables(){
	iptables -D INPUT -m state --state NEW -m tcp -p tcp --dport ${aria2_port} -j ACCEPT
	iptables -D INPUT -m state --state NEW -m udp -p udp --dport ${aria2_port} -j ACCEPT
}
Save_iptables(){
	if [[ ${release} == "centos" ]]; then
		service iptables save
	else
		iptables-save > /etc/iptables.up.rules
	fi
}
Set_iptables(){
	if [[ ${release} == "centos" ]]; then
		service iptables save
		chkconfig --level 2345 iptables on
	else
		iptables-save > /etc/iptables.up.rules
		echo -e '#!/bin/bash\n/sbin/iptables-restore < /etc/iptables.up.rules' > /etc/network/if-pre-up.d/iptables
		chmod +x /etc/network/if-pre-up.d/iptables
	fi
}
Update_Shell(){
	echo -e "当前版本为 [ ${sh_ver} ]，开始检测最新版本..."
	sh_new_ver=$(wget --no-check-certificate -qO- "https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/aria2.sh"|grep 'sh_ver="'|awk -F "=" '{print $NF}'|sed 's/\"//g'|head -1)
	[[ -z ${sh_new_ver} ]] && echo -e "${Error} 检测最新版本失败 !" && exit 0
	if [[ ${sh_new_ver} != ${sh_ver} ]]; then
		echo -e "发现新版本[ ${sh_new_ver} ]，是否更新？[Y/n]"
		stty erase '^H' && read -p "(默认: y):" yn
		[[ -z "${yn}" ]] && yn="y"
		if [[ ${yn} == [Yy] ]]; then
			wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/aria2.sh && chmod +x aria2.sh
			echo -e "脚本已更新为最新版本[ ${sh_new_ver} ] !"
		else
			echo && echo "	已取消..." && echo
		fi
	else
		echo -e "当前已是最新版本[ ${sh_new_ver} ] !"
	fi
}
echo && echo -e " Aria2 一键安装管理脚本 ${Red_font_prefix}[v${sh_ver}]${Font_color_suffix}
  -- Toyo | doub.io/shell-jc4 --
  
 ${Green_font_prefix}0.${Font_color_suffix} 升级脚本
————————————
 ${Green_font_prefix}1.${Font_color_suffix} 安装 Aria2
 ${Green_font_prefix}2.${Font_color_suffix} 卸载 Aria2
————————————
 ${Green_font_prefix}3.${Font_color_suffix} 启动 Aria2
 ${Green_font_prefix}4.${Font_color_suffix} 停止 Aria2
 ${Green_font_prefix}5.${Font_color_suffix} 重启 Aria2
————————————
 ${Green_font_prefix}6.${Font_color_suffix} 修改 配置文件
 ${Green_font_prefix}7.${Font_color_suffix} 查看 配置信息
 ${Green_font_prefix}8.${Font_color_suffix} 查看 日志信息
————————————" && echo
if [[ -e ${aria2c} ]]; then
	check_pid
	if [[ ! -z "${PID}" ]]; then
		echo -e " 当前状态: ${Green_font_prefix}已安装${Font_color_suffix} 并 ${Green_font_prefix}已启动${Font_color_suffix}"
	else
		echo -e " 当前状态: ${Green_font_prefix}已安装${Font_color_suffix} 但 ${Red_font_prefix}未启动${Font_color_suffix}"
	fi
else
	echo -e " 当前状态: ${Red_font_prefix}未安装${Font_color_suffix}"
fi
echo
stty erase '^H' && read -p " 请输入数字 [0-8]:" num
case "$num" in
	0)
	Update_Shell
	;;
	1)
	Install_aria2
	;;
	2)
	Uninstall_aria2
	;;
	3)
	Start_aria2
	;;
	4)
	Stop_aria2
	;;
	5)
	Restart_aria2
	;;
	6)
	Set_aria2
	;;
	7)
	View_Aria2
	;;
	8)
	View_Log
	;;
	*)
	echo "请输入正确数字 [0-8]"
	;;
esac