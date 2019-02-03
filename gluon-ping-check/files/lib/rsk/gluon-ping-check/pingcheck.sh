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
FAILCOUNTFILE=/var/run/ping_failcount
# wie viele Fehlversuche vor dem Reboot (min)
MAXFAILCOUNT=`uci get rsk.@pingcheck[0].maxfail`
#
#
#
if [ $DISABLED -eq 0 ]; then
 if [ -f $FAILCOUNTFILE ]; then
      read failcount < $FAILCOUNTFILE
      # debug
      echo 'failcount steht auf '$failcount
      PINGSUCCESS=0
      LIST=$(echo $IP_LIST | tr "\s" "\n")
            # loop for every entry in iplist
               # debug
               echo 'IP-Adressen: '$LIST
               for IPADDR in $LIST
                 do

                   # debug
                   echo 'ping auf '$IPADDR
                   PING_DROP=`ping -c 1 -6 -q $IPADDR | grep received | cut -d ',' -f 3 | cut -d '%' -f 1 | cut -d ' ' -f 2`
                   if [ $PING_DROP -eq 0 ]; then

                        #debug
                        echo 'ping war fehlerhaft auf '$IPADDR
                    else
                        # debug
                        echo 'ping war O.K.  bei '$IPADDR
                        PINGSUCCESS=1
                        echo 'breche check ab.'
                        break
                   fi
                 done

                   # if ! PINGSUCCESS
                   if [ $PINGSUCCESS -eq 1 ]; then

                       # we have drops - lets increase error count
                        failcount=$(($failcount+1))
                        if [ $failcount -ge $MAXFAILCOUNT ]; then
                          echo 0 > $FAILCOUNTFILE
                          # debug
                          echo "maximale Fehler erreicht - restart wifi ..."
                          wifi

                        fi
                   fi
    else
        # debug
        echo 'noch kein failcounter - erzeuge Datei'

        echo 0 > $FAILCOUNTFILE

    fi

else
        echo "pingcheck uci setting shows DISABLED=true"

fi
