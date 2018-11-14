#!/bin/ash

#
# credits go to http://kbu.freifunk.net/wiki/ for original cronjob template
#
# HowTO:
# set uci node role to meshanduplink
# set uci values in rsk.@checkgw[0]
# 
#

# ENABLED ?
DISABLED=`uci get rsk.@checkgw[0].disabled`

if [ $DISABLED  -eq 0 ]; then

ROLE=`uci get gluon-node-info.@system[0].role`

FAILCOUNTFILE=/var/run/mesh0_failcount
# wie viele Fehlversuche vor dem Reboot (min)
MAXFAILCOUNT=`uci get rsk.@checkgw[0].maxfail`
# letzte 3 Bytes der wifi MAC des gateways
MAC3GW=`uci get rsk.@checkgw[0].mac3gw`

  if [ $ROLE == meshanduplink ]; then

  # check mesh connections with gateway and reboot if not present:

  count=`batctl gwl | grep $MAC3GW | wc -l`

    if [ -f $FAILCOUNTFILE ]; then
        read failcount < $FAILCOUNTFILE
        if [ $count -gt 0 ]; then
                if [ $failcount -gt 0 ]; then
                        echo 0 > $FAILCOUNTFILE
                        exit
                fi
        else
        failcount=$(($failcount+1))
        if [ $failcount -ge $MAXFAILCOUNT ]; then
                echo 0 > $FAILCOUNTFILE
                        # do not activate logread
                        #     logread >/etc/mesh0_failcount_lastwords_`date +"%Y-%m-%d_%H%M"`
                # debug
                # echo "maximale Fehler erreicht - rebooting ..."
                sync
                reboot
        fi
        echo $failcount > $FAILCOUNTFILE
        # debug
        # echo "Bisher $failcount Fehler\n"
        # enable wifi in case someone pressed false button
        uci set wireless.mesh_radio0.disabled='0'
        uci commit wireless
        wifi
        # end in case false button
        fi
    else
        echo 0 > $FAILCOUNTFILE
        # debug
        # echo "Bisher keine Fehler\n"

    fi

    # echo "$count Mesh-Gateway-Links."
  fi

fi
