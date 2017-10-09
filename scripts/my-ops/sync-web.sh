#!/bin/bash

CONF_FILE='sync-web.ini'

if [ ! -f "$CONF_FILE" ]; then
    echo " File '$CONF_FILE' don't exist!"
    exit
fi

