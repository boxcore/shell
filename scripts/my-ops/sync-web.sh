#!/bin/bash


SYNC_DIR='/www/37'
REMOTE_DIR='/www/37test'

REMOTE_IP=$1
if [ ! -n "$REMOTE_IP" ]; then
    echo "REMOTE_IP unset!"
    exit
else
    echo "your REMOTE IP is: $REMOTE_IP"
fi

if [ ! -n "$2" ]; then
    REMOTE_PORT=22
    echo "you using default REMOTE_PORT: $REMOTE_PORT"
else
    REMOTE_PORT=$2
    echo "you using setting REMOTE_PORT: $REMOTE_PORT"
fi

exit

CUR_DIR=`dirname $0`
CONF_FILE=$CUR_DIR'/sync-web.ini'

if [ ! -f "$CONF_FILE" ]; then
    echo " File '$CONF_FILE' don't exist!"
    exit
fi

cat $CONF_FILE | while read line
do

LOCAL_DIR_NAME="${SYNC_DIR}/${line}"
REMOTE_DIR_NAME="${REMOTE_DIR}/${line}"


if [ -d "LOCAL_DIR_NAME" ]; then
    echo "DIR : ${LOCAL_DIR_NAME}  exist!"

/usr/bin/rsync "-e ssh -p ${REMOTE_PORT}" --compress --recursive --times --perms --owner --group --links  ${LOCAL_DIR_NAME}/ www@${REMOTE_IP}:${LOCAL_DIR_NAME}/
echo "sync ok"

else
    echo "DIR : ${LOCAL_DIR_NAME}  不存在，跳过操作!"
fi

done
