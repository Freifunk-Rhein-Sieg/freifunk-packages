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
DISABLED=`uci get rsk.@blockmesh[0].disabled`
#
#
#


if [ $DISABLED -eq 0 ]; then

    # command:  iw dev $MESH_IFACE station set $HW_ADDR plink_action [open|block]
    # see: https://forum.freifunk.net/t/unnoetige-mesh-verbindungen-mit-mac-filter-verhindern/13244/10
    #
    # 11s interface: mesh0
       # if $MAC_LIST not empty
       if [ $MAC_LIST -ne '' ]; then
            # loop for every entry in maclist
            for $MAC in $MAC_LIST do
                iw dev mesh0 set $MAC plink_action block
            done
            # end loop
        fi
fi
