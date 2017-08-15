#!/bin/sh

/usr/sbin/ntpd -q -p 2.openwrt.pool.ntp.org             #Check Time before Run
# nice try, but most often, time is not in sync - check manually ! 

ROLE=`uci get gluon-node-info.@system[0].role`

OFF_HOUR=`uci get rsk.@speedlimit[0].houroff`
ON_HOUR=`uci get rsk.@speedlimit[0].houron`
DISABLED=`uci get rsk.@speedlimit[0].disabled`

HOUR=`date +"%H"`
if [ $DISABLED -eq 0 ]; then

if [ $HOUR -ge $OFF_HOUR ] || [ $HOUR -lt $ON_HOUR ]; then
                LIMIT_OFF=1
        else
                LIMIT_OFF=0
fi
