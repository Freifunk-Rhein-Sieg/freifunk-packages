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
# wie viele Fehlversuche vor dem wifi restart (min)
MAXFAILCOUNT=`uci get rsk.@pingcheck[0].maxfail`
#
#
#
if [ $DISABLED -eq 0 ]; then
 if [ -f $FAILCOUNTFILE ]; then
      read failcount < $FAILCOUNTFILE
      LIST=$(echo $IP_LIST | tr "\s" "\n")
            # loop for every entry in iplist
              # echo $LIST
                for IP in $LIST
                 do
                   PING_DROP = `ping -c 1 -6 -q $IP | grep received | cut -d ',' -f 3 | cut -d '%' -f 1 | cut -d ' ' -f 2`
                   if [ $PING_DROP -eq 0 ]; then
                        
                        PING_ERROR=1
                   fi
                 done

                   # if PING ERROR
                   if [ $PING_ERROR eq 1 ]; then
                   
                       # we have drops - lets increase error count
                        failcount=$(($failcount+1))
                        if [ $failcount -ge $MAXFAILCOUNT ]; then
                          echo 0 > $FAILCOUNTFILE
                          # debug
                          # echo "maximale Fehler erreicht - restart wifi ..."
                          wifi
                          
                        fi
                   fi
    else
        echo 0 > $FAILCOUNTFILE
        # debug
        # echo "Bisher keine Fehler\n"

    fi

else
        echo "pingcheck uci setting shows DISABLED=true"

fi
