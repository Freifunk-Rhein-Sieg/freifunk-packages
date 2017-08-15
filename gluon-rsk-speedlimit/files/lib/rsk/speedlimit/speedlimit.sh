#!/bin/sh

/usr/sbin/ntpd -q -p 2.openwrt.pool.ntp.org             #Check Time before Run
# nice try, but most often, time is not in sync - check manually ! 

#
# need to check node role?
#
#ROLE=`uci get gluon-node-info.@system[0].role`
#
# times to switch mesh vpn bandwith
#
HOUR_LIMIT=`uci get rsk.@speedlimit[0].hour_limit`
HOUR_STANDARD=`uci get rsk.@speedlimit[0].hour_normal`
#
# mesh vpn bandwith ratings
#
# default
INGRESS_DEFAULT=`uci get rsk.@speedlimit[0].default_ingress`
EGRESS_DEFAULT=`uci get rsk.@speedlimit[0].default_egress`
# limited
INGRESS_LIMIT=`uci get rsk.@speedlimit[0].default_ingress`
EGRESS_LIMIT=`uci get rsk.@speedlimit[0].default_egress`
DISABLED=`uci get rsk.@speedlimit[0].disabled`
#


HOUR=`date +"%H"`
if [ $DISABLED -eq 0 ]; then

if [ $HOUR -ge $HOUR_LIMIT ] || [ $HOUR -lt $HOUR_STANDARD ]; then
                LIMIT_OFF=1
        else
                LIMIT_OFF=0
fi

