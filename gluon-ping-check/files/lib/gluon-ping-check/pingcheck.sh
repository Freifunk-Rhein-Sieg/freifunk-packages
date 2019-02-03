#!/bin/sh

/usr/sbin/ntpd -q -p 2.openwrt.pool.ntp.org             #Check Time before Run
# nice try, but most often, time is not in sync - check manually ! 

#
# need to check node role?
#
#ROLE=`uci get gluon-node-info.@system[0].role`
#
#
# get uci values to block wifi meshing with them
#
IP_LIST=`uci get rsk.@pingcheck[0].iplist`
DISABLED=`uci get rsk.@pingcheck[0].disabled`
#
#
#
if [ $DISABLED -eq 0 ]; then




else
        echo "pingcheck uci setting shows DISABLED=true"

fi
