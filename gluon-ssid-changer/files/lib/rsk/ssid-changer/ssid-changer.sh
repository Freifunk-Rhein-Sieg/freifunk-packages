#!/bin/sh

# Enabled?
DISABLED=`uci get rsk.@ssidchanger[0].disabled`

FAILCOUNTFILE=/var/run/ssidchanger_failcount
# wie viele Fehlversuche vor dem Reboot (min)

#MAXFAILCOUNT=`uci get rsk.@ssidchanger[0].maxfail` # nicht kompatibel, solange rsk-config den Wert nicht gesetzt hat
# lets do it the static way
MAXFAILCOUNT=5
#

# debug
#echo "max $MAXFAILCOUNT Fehler"


if [ $DISABLED -eq 0 ]; then

# At first some Definitions:

ONLINE_SSID='Freifunk'
OFFLINE_PREFIX='FF_OFFLINE_' # Use something short to leave space for the nodename

#Above this limit the online SSID will be used
UPPER_LIMIT=`uci get rsk.@ssidchanger[0].limithigh` 
#Below this limit the offline SSID will be used
LOWER_LIMIT=`uci get rsk.@ssidchanger[0].limitlow`
# In-between these two values the SSID will never be changed to preven it from toggeling every Minute.

# Generate an Offline SSID with the first and last Part of the nodename to allow owner to recognise wich node is down
NODENAME=`uname -n`
if [ ${#NODENAME} -gt $((30 - ${#OFFLINE_PREFIX})) ] ; then #32 would be possible as well
        HALF=$(( (28 - ${#OFFLINE_PREFIX} ) / 2 )) #calculate the length of the first part of the node identifier in the offline-ssid
        SKIP=$(( ${#NODENAME} - $HALF )) #jump to this charakter for the last part of the name
        OFFLINE_SSID=$OFFLINE_PREFIX${NODENAME:0:$HALF}...${NODENAME:$SKIP:${#NODENAME}} # use the first and last part of the nodename for nodes with long name
else
        OFFLINE_SSID="$OFFLINE_PREFIX$NODENAME" #greate we are able to use the full nodename in the offline ssid
fi

#Is there an active Gateway?
# lets check old gluon default
GATEWAY_TQ=`batctl gwl -H | grep "^=>" | awk -F'[()]' '{print $2}'| tr -d " "` #Grep the Connection Quality of the Gateway which is currently used

if [ ! $GATEWAY_TQ ]; #If there is no gateway there will be errors in the following if clauses
then
        # lets try to get TQ from new lede based gluon
        GATEWAY_TQ=`batctl gwl -H | grep "^*" | awk -F'[()]' '{print $2}'| tr -d " "` #Grep the Connection Quality of the Gateway which is current
        # dow we have a TQ value now?
        if [ ! $GATEWAY_TQ ];
        then
                

                if [ -f $FAILCOUNTFILE ]; then
                      read failcount < $FAILCOUNTFILE
                       # we have drops - lets increase error count
                        failcount=$(($failcount+1))
                        echo "schreibe $failcount failcounter ins file"
                        echo $failcount > $FAILCOUNTFILE
                        if [ $failcount -ge $MAXFAILCOUNT ]; then
                          echo 0 > $FAILCOUNTFILE
                          # ok - really no TQ available :(
                          GATEWAY_TQ=0 #Just an easy way to get an valid value if there is no gatway
                        else
                                # we have no values and maxcounter not reached - lets finish job
                                exit 0
                        fi
                        
                 else
                    # debug
                    # echo "noch kein failcounter - erzeuge Datei"
                    echo 0 > $FAILCOUNTFILE
               fi
        else
                echo 0 > $FAILCOUNTFILE
        fi
else
                echo 0 > $FAILCOUNTFILE
fi

if [ $GATEWAY_TQ -gt $UPPER_LIMIT ];
then
        echo "Gateway TQ is $GATEWAY_TQ node is online"
        for HOSTAPD in $(ls /var/run/hostapd-phy*); do #Check status for all physical devices
                CURRENT_SSID=`grep "^ssid=$ONLINE_SSID" $HOSTAPD | cut -d"=" -f2`
                if [ $CURRENT_SSID == $ONLINE_SSID ]
                then
                        echo "SSID $CURRENT_SSID is correct, nothing to do"
                        HUP_NEEDED=0
                        break
                fi
                CURRENT_SSID=`grep "^ssid=$OFFLINE_SSID" $HOSTAPD | cut -d"=" -f2`
                if [ $CURRENT_SSID == $OFFLINE_SSID ]
                then
                        logger -s -t "gluon-offline-ssid" -p 5 "TQ is $GATEWAY_TQ, SSID is $CURRENT_SSID, change to $ONLINE_SSID" #Write Info to Syslog
                        sed -i s/^ssid=$CURRENT_SSID/ssid=$ONLINE_SSID/ $HOSTAPD
                        HUP_NEEDED=1 # HUP here would be to early for dualband devices
                else
                        echo "There is something wrong, did not find SSID $ONLINE_SSID or $OFFLINE_SSID"
                fi
        done
fi

if [ $GATEWAY_TQ -lt $LOWER_LIMIT ];
then
        echo "Gateway TQ is $GATEWAY_TQ node is considered offline"
        for HOSTAPD in $(ls /var/run/hostapd-phy*); do #Check status for all physical devices
                CURRENT_SSID=`grep "^ssid=$OFFLINE_SSID" $HOSTAPD | cut -d"=" -f2`
                if [ $CURRENT_SSID == $OFFLINE_SSID ]
                then
                        echo "SSID $CURRENT_SSID is correct, nothing to do"
                        HUP_NEEDED=0
                        break
                fi
                CURRENT_SSID=`grep "^ssid=$ONLINE_SSID" $HOSTAPD | cut -d"=" -f2`
                if [ $CURRENT_SSID == $ONLINE_SSID ]
                then
                        logger -s -t "gluon-offline-ssid" -p 5 "TQ is $GATEWAY_TQ, SSID is $CURRENT_SSID, change to $OFFLINE_SSID" #Write Info to Syslog
                        sed -i s/^ssid=$ONLINE_SSID/ssid=$OFFLINE_SSID/ $HOSTAPD
                        HUP_NEEDED=1 # HUP here would be to early for dualband devices
                else
                        echo "There is something wrong, did not find SSID $ONLINE_SSID or $OFFLINE_SSID"
                fi
        done
fi

if [ $GATEWAY_TQ -ge $LOWER_LIMIT -a $GATEWAY_TQ -le $UPPER_LIMIT ]; #This is just get a clean run if we are in-between the grace periode
then
        echo "TQ is $GATEWAY_TQ, do nothing"
        HUP_NEEDED=0
fi

if [ $HUP_NEEDED == 1 ]; then
        killall -HUP hostapd # Send HUP to all hostapd um die neue SSID zu laden
        HUP_NEEDED=0
        echo "HUP!"
fi

fi
