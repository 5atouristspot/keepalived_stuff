#!/bin/bash


############################################################
# Effect : check moosefs master alive or not , if not , take some action to excute it 
# OS environment: For Ubuntu 14.04 LTS Trusty and above
#
# author: zhihao0905
# creat_time: 2017-8-21
# modify time:
############################################################


#virtual_ipaddress of keepalived config 
ipaddr="192.168.71.11"


function check_mfsmaster()
{
    vip=`ip addr | grep "$ipaddr" | awk -F '[ /]++' '{print $3}'`
    mfsmasterpid=`ps -C mfsmaster --no-header | wc -l`

    if [[ "$vip" == "$ipaddr" ]];then
        if [ $mfsmasterpid -eq 0 ];then
            #/usr/sbin/mfsmaster -a
            /etc/keepalived/moosefsha.sh -asm
            sleep 3
            mfsmasterpid_after=`ps -C mfsmaster --no-header | wc -l`
            if [ $mfsmasterpid_after -eq 0 ]; then
                #service keepalived stop
                /etc/keepalived/keepalivedha.sh -p
            fi
        fi
    else
        #/usr/sbin/mfsmaster stop
        /etc/keepalived/moosefsha.sh -pm
    fi
}

check_mfsmaster

