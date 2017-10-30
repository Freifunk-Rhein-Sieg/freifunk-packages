#!/bin/sh

/usr/sbin/ntpd -q -p 2.openwrt.pool.ntp.org             #Check Time before Run
# nice try, but most often, time is not in sync - check manually ! 



DISABLED=`uci get rsk.@robinson[0].disabled`
FRIDAY=`uci get rsk.@robinson[0].friday`

# check if enabled
if [ $DISABLED -eq 0 ]; then

  # check for connected clients
   CLIENTS=`batctl tl |grep W |wc -l`
   # if we have clients, no need to restart
   if [ $CLIENTS -eq 0 ]; then
    
    # check for uptime 
    UPTIME=`awk '{print int($1/86400)}' /proc/uptime`
      # if uptime is > friday days
      if [ $UPTIME -gt $FRIDAY ]; then
      
        reboot
      
      fi

   fi
fi
