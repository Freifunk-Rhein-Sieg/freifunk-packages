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
    # from iw --help:
    #  dev <devname> station dump
    #            List all stations known, e.g. the AP on managed interfaces
    #    dev <devname> station set <MAC address> mesh_power_mode <active|light|deep>
    #            Set link-specific mesh power mode for this station
    #   dev <devname> station set <MAC address> vlan <ifindex>
    #            Set an AP VLAN for this station.
    #   dev <devname> station set <MAC address> plink_action <open|block>
    #            Set mesh peer link action for this station (peer).
    #   dev <devname> station del <MAC address>
    #            Remove the given station entry (use with caution!)
    #   dev <devname> station get <MAC address>
    #            Get information for a specific station.
  
    # 11s interface: mesh0
           LIST=$(echo $MAC_LIST | tr "\s" "\n")
            # loop for every entry in maclist
              # echo $LIST
                for MAC in $LIST
                  do
                        #iw dev mesh0 station set $MAC plink_action block
                        # fallback to iptables - iw does not work - to be checked later
                        # convert $MAC to upper strings to match iptables output
                        # CHECK=$(echo $MAC|tr "[a-z]" "[A-Z") # only iptables needs upper-case MAC
                        #
                        
                        #
                        # check, ob mesh link zum sperren vorhanden
                        # iw dev mesh0 station get  | grep Station | wc -l ->1
                        MAC_LINK=`iw dev mesh0 station get $MAC | grep Station | wc -l`
                        if [ $MAC_LINK -eq 1 ]; then
                            #
                            # check, ob station bereits gesperrt ist
                            # iw dev mesh0 station get $MAC | grep BLOCKED | wc -l ->1
                            MAC_BLOCKED=`iw dev mesh0 station get $MAC | grep BLOCKED | wc -l`
                            if [ $MAC_BLOCKED -eq 0 ]; then
                                # wenn noch nicht gesperrt, dann
                                #
                                echo "blocking $MAC"
                                iw dev mesh0 station set $MAC plink_action block
                            else
                                echo "$MAC is already blocked."
                            fi
                        else
                            echo "$MAC has no active link."
                        fi
                 done

            # end loop
else
        echo "blockmesh uci setting shows DISABLED=true"

fi
