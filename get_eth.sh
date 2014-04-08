#!/bin/bash
#update:2014-04-08
#author:boxcore
#version 0.1

cdate=$(date '+%Y%m%d')
num=$(ifconfig -a | grep eth | wc -l)
echo "ethX=" $num >> ethX

for ((n=1;n<${num};n++))
    do
 
       if [ -e /etc/sysconfig/network-scripts/ifcfg-eth${n} ] ; then
       
           sed -i '/HWADDR/d' /etc/sysconfig/network-scripts/ifcfg-eth${n}
           ifconfig -a | grep "eth${n}" | awk '{print "HWADDR=\""$5"\""}' >> /etc/sysconfig/network-scripts/ifcfg-eth${n}    
             
      else

           touch /etc/sysconfig/network-scripts/ifcfg-eth${n}
           ifconfig -a | grep "eth${n}" | awk '{print "HWADDR=\""$5"\""}' >> /etc/sysconfig/network-scripts/ifcfg-eth${n}
           echo NM_CONTROLLED="\"yes\"" >> /etc/sysconfig/network-scripts/ifcfg-eth${n}
           echo ONBOOT="\"yes\"" >> /etc/sysconfig/network-scripts/ifcfg-eth${n}
           echo TYPE="\"Ethernet\"" >> /etc/sysconfig/network-scripts/ifcfg-eth${n}
           echo BOOTPROTO="\"dhcp\"" >> /etc/sysconfig/network-scripts/ifcfg-eth${n}
           echo UUID="\"2460e474-fad8-4b46-baba-da6f45ae158"${n}"\"" >> /etc/sysconfig/network-scripts/ifcfg-eth${n}
           echo DEVICE="\"eth"${n}"\"" >> /etc/sysconfig/network-scripts/ifcfg-eth${n}
           
           continue
       fi
    done
 
