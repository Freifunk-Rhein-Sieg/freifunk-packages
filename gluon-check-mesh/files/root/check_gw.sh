#!/bin/ash

FAILCOUNTFILE=/var/run/mesh0_failcount
# wie viele Fehlversuche vor dem Reboot (min)
MAXFAILCOUNT=5
# letzte 3 Bytes der wifi MAC de gateways
MAC3GW='b0:49:5e'

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
        fi
else
        echo 0 > $FAILCOUNTFILE
        # debug
        # echo "Bisher keine Fehler\n"

fi

# echo "$count Mesh-Gateway-Links."

