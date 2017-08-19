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
MAC_LIST=`uci get rsk.@blockmesh[0].maclist`
#
