#!/bin/bash

echo -n "input your hosts name(default: boxcore):"
read hostname
if [ $hostname eq '']; then
hostname='boxcore'
fi
echo "your hostname: $hostname"
