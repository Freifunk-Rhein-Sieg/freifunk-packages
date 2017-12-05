#!/bin/ash

#
# credits go to http://kbu.freifunk.net/wiki/ for original cronjob template
#
# HowTO:
# set uci node role to mesh
# set uci config values in rsk.@checkmesh[0]
# 
#


# ENABLED ?
DISABLED=`uci get rsk.@checkmesh[0].disabled`

if [ $DISABLED  -eq 0 ]; then

ROLE=`uci get gluon-node-info.@system[0].role`
FAILCOUNTFILE=/var/run/clients_mesh0_failcount
# wie viele Fehlversuche vor dem Reboot (min)
MAXFAILCOUNT=`uci get rsk.@checkmesh[0].maxfail`
# minimale Anzahl der verbundenen wifi meshes
MINCLIENTS=`uci get rsk.@checkmesh[0].minclients`

  if [ $ROLE == mesh ]; then

  # check mesh connections with gateway and reboot if not present:

   #count=`batctl o | grep mesh0 | wc -l` # alt
   count=`iw mesh0 station dump | grep ESTAB | wc -l`

    if [ -f $FAILCOUNTFILE ]; then
        read failcount < $FAILCOUNTFILE
        if [ $count -gt $MINCLIENTS ]; then
                if [ $failcount -gt 0 ]; then
                        echo 0 > $FAILCOUNTFILE
                        exit
                fi
        else
        failcount=$(($failcount+1))
        if [ $failcount -ge $MAXFAILCOUNT ]; then
                echo 0 > $FAILCOUNTFILE
                        # do not activate logread
                        #     logread >/etc/clints_mesh0_failcount_lastwords_`date +"%Y-%m-%d_%H%M"`
                # debug
                # echo "maximale Fehler erreicht - rebooting ..."
                sync
                reboot
        fi
        echo $failcount > $FAILCOUNTFILE
        # debug
        # echo "Bisher $failcount Fehler\n"
        fi
    else
        echo 0 > $FAILCOUNTFILE
        # debug
        # echo "Bisher keine Fehler\n"

    fi

    # echo "$count Mesh-Links-Links."
  fi
fi
