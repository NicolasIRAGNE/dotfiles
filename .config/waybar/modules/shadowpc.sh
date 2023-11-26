#!/bin/bash
################################################################################
# File: shadowpc.sh
# Created Date: 02/08/2023
# Author: Nicolas Iragne (nicolas.iragne@shadow.tech)
# -----
# Outputs shadowPC status for use with waybar
# -----
################################################################################

# echo -e "{\"text\":\"\", \"tooltip\":\"Refreshing...\"}"

# if a python script called "tokenizator.py" is running, then we are refreshing
if [[ $(ps aux | grep -v grep | grep tokenizator.py) ]]
then
    # echo -e "{\"text\":\"<span color='#FFFF00'> [VM Refreshing]</span>\", \"tooltip\":\"$MSG\"}"
    # exit 0
    ICON=
else
    ICON=
fi

# {{\"text\": \"VM [{str}]\", \"tooltip\": \"{str} ({code})\"}}

OUT=`~/repos/tokenizator/tokenizator.py -q status --format "{str};{code}" $SHADOW_VM_MAIL`

if [[ $? != 0 ]]
then
    echo -e "{\"text\":\"$ICON [ERROR]\", \"tooltip\":\"$OUT\"}"
    exit 1
fi

MSG=$(echo $OUT | cut -f1 -d';')
CODE=$(echo $OUT | cut -f2 -d';')

if [[ $CODE == "200" ]]
then
    echo -e "{\"text\":\"<span color='#00FF00'>$ICON [VM STARTED]</span>\", \"tooltip\":\"$MSG\"}"
else
    echo -e "{\"text\":\"$ICON [$MSG]\", \"tooltip\":\"$MSG ($CODE)\"}"
fi
