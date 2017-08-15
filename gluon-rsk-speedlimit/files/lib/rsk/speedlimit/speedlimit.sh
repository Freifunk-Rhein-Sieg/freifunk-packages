#!/bin/sh

/usr/sbin/ntpd -q -p 2.openwrt.pool.ntp.org             #Check Time before Run
# nice try, but most often, time is not in sync - check manually ! 

ROLE=`uci get gluon-node-info.@system[0].role`

LIMIT_HOUR=`uci get rsk.@speedlimit[0].hour_limit`
STANDADR_HOUR=`uci get rsk.@speedlimit[0].hour_normal`
DISABLED=`uci get rsk.@speedlimit[0].disabled`

HOUR=`date +"%H"`
if [ $DISABLED -eq 0 ]; then

if [ $HOUR -ge $LIMIT_HOUR ] || [ $HOUR -lt $STANDARD_HOUR ]; then
                LIMIT_OFF=1
        else
                LIMIT_OFF=0
fi

