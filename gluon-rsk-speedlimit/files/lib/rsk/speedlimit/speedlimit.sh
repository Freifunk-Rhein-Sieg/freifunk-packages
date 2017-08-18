#!/bin/sh

/usr/sbin/ntpd -q -p 2.openwrt.pool.ntp.org             #Check Time before Run
# nice try, but most often, time is not in sync - check manually ! 

#
# need to check node role?
#
#ROLE=`uci get gluon-node-info.@system[0].role`
#
# times to switch mesh vpn bandwith
#
HOUR_LIMIT=`uci get rsk.@speedlimit[0].hour_limit`
HOUR_STANDARD=`uci get rsk.@speedlimit[0].hour_normal`
#
# mesh vpn bandwith ratings
#
# current
INGRESS_NOW=`uci get simple-tc.mesh_vpn.limit_ingress`
EGRESS_NOW=`uci get simple-tc.mesh_vpn.limit_egress`
# default
INGRESS_DEFAULT=`uci get rsk.@speedlimit[0].default_ingress`
EGRESS_DEFAULT=`uci get rsk.@speedlimit[0].default_egress`
# limited
INGRESS_LIMIT=`uci get rsk.@speedlimit[0].default_ingress`
EGRESS_LIMIT=`uci get rsk.@speedlimit[0].default_egress`
DISABLED=`uci get rsk.@speedlimit[0].disabled`
#


HOUR=`date +"%H"`
if [ $DISABLED -eq 0 ]; then

if [ $HOUR -ge $HOUR_LIMIT ] || [ $HOUR -lt $HOUR_STANDARD ]; then
                LIMIT_OFF=1
        else
                LIMIT_OFF=0
fi

    if [ $LIMIT_OFF -eq 0 ]; then
                        # Limited mesh-vpn
                        # Makes only sense if mesh-vpn is on
                        uci set simple-tc.mesh_vpn.enabled='1'
                        # Set uci ingress and egress to limited values and commit
                        uci set simple-tc.mesh_vpn.limit_ingress=$INGRESS_LIMIT                            # Set limited ingress
                        uci set simple-tc.mesh_vpn.limit_egress=$EGRESS_LIMIT                             # Set limited egress
                        uci commit simple-tc                                                         # commit values
                        
                        if [ $INGRESS_NOW -eq $INGRESS_LIMIT ];then
                          /etc/init.d/tunneldigger restart
                        fi
        else                                                  
                        # Makes only sense if mesh-vpn is on
                        uci set simple-tc.mesh_vpn.enabled='1'
                        # Set uci ingress and egress to default values and commit
                        uci set simple-tc.mesh_vpn.limit_ingress=$INGRESS_DEFAULT                             # Set standard ingress
                        uci set simple-tc.mesh_vpn.limit_egress=$EGRESS_DEFAULT                             # Set standard egress
                        uci commit simple-tc                                                           # commit values    

                        if [ $INGRESS_NOW -eq $INGRESS_DEFAULT ];then
                          /etc/init.d/tunneldigger restart
                        fi
fi
  
else
    # is DISABLED
    exit 0
    
fi 
