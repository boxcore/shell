#!/bin/bash
# usage: /bin/bash ./sync-web.sh HOST {PORT} {1}
# param 0: remote ip
# param 1: PORT, defaul value = 22
# param 2: if force create remote dir, defalut false

SYNC_DIR='/home/wwwroot'
REMOTE_DIR='/home/wwwroot'
REMOTE_IP=$1
if [ ! -n "$REMOTE_IP" ]; then echo "REMOTE_IP unset!"; exit; else echo "your REMOTE IP is: $REMOTE_IP"; fi
if [ ! -n "$2" ]; then REMOTE_PORT=22; echo "you using default REMOTE_PORT: $REMOTE_PORT"; else REMOTE_PORT=$2; echo "you using setting REMOTE_PORT: $REMOTE_PORT"; fi
if [ -n "$3" ]; then REMOTE_FORCE_RUN=$3;echo "REMOTE_FORCE_RUN setting : $REMOTE_FORCE_RUN" ;   fi

ssh -p ${REMOTE_PORT} www@${REMOTE_IP} "exit"  
if [ $? -eq 0 ];then echo "SSH Login Success!" ;else echo "SSH Login Fail!"; exit; fi

CUR_DIR=`dirname $0`
CONF_FILE=$CUR_DIR'/sync-web.ini'
if [ ! -f "$CONF_FILE" ]; then echo " File '$CONF_FILE' don't exist!";exit;fi


# cat $CONF_FILE | while read line
for line in `cat ${CONF_FILE}`; do

    LOCAL_DIR_NAME="${SYNC_DIR}/${line}"
    REMOTE_DIR_NAME="${REMOTE_DIR}/${line}"

    echo "----------------------------------"

    if [ -d "${LOCAL_DIR_NAME}" ]; then
        echo "LOCAL DIR : ${LOCAL_DIR_NAME}  exist!"

        # check remote dir if exist
        ssh -p ${REMOTE_PORT} www@${REMOTE_IP} "du -sh ${REMOTE_DIR_NAME} && exit" 
        if [ $? -eq 0 ];then 
            echo "Remote DIR check ok: ${REMOTE_DIR_NAME}" ;
            /usr/bin/rsync "-e ssh -p ${REMOTE_PORT}" --compress --recursive --times --perms --owner --group --links  ${LOCAL_DIR_NAME}/ www@${REMOTE_IP}:${REMOTE_DIR_NAME}/
    echo "sync ok"
        else 
            if [ -n $REMOTE_FORCE_RUN ]; then 
                ssh -p ${REMOTE_PORT} www@${REMOTE_IP} "mkdir -pv ${REMOTE_DIR_NAME} && exit"
                if [ $? -eq 0 ];then 
                    echo "Remote dir create success!";
                    /usr/bin/rsync "-e ssh -p ${REMOTE_PORT}" --compress --recursive --times --perms --owner --group --links  ${LOCAL_DIR_NAME}/ www@${REMOTE_IP}:${REMOTE_DIR_NAME}/
                    echo "sync ok" 
                else
                    echo "Remote dir create fail!"; 
                fi
            else
                echo "Remote DIR '${REMOTE_DIR_NAME}' don't exit, jumpped!";
            fi
        fi
    else
        echo "LOCAL DIR : ${LOCAL_DIR_NAME}  不存在，跳过操作!"
    fi

    echo ""
    echo "============================"
    echo ""

done


