#!/bin/bash

############################################################
# Effect : keepalived high avilable
# OS environment: For Ubuntu 14.04 LTS Trusty and above
#
# author: zhihao0905
# creat_time: 2017-8-23
# modify time:
############################################################

help(){
       cat << EOF
Usage:
Options:
    --start|-s         start keepalived
    --stop|-p          stop keepalived
    --restart|-ps      restart keepalived
EOF
}

init=0


while test $# -gt 0
do
    case $1 in
        --start|-s)
        init=1
        shift
        ;;
        --stop|-p)
        init=2
        shift
        ;;
        --restart|-ps)
        init=3
        shift
        ;;
        --help)
        help
        exit 0
        ;;
        *)
        echo >&2 "Invalid argument: $1"
        exit 0
        ;;
    esac
     shift
done



ha_log='./keepalived_ha.log'

function mk_log()
{

    touch $ha_log

    if [ -f $ha_log ]; then
        echo -e "step.1 ====> $ha_log make \033[32m succ \033[0m \n"
        echo "step.1 ====> $ha_log make succ" >> $ha_log
    else
        echo -e "step.1 ====> $ha_log make \033[31m fail \033[0m \n"
        echo "step.1 ====> $ha_log make fail" >> $ha_log
        exit 0
    fi
}


function print_date()
{
    echo '-------------------'`date`'---------------------' >> $ha_log
}



function start_keepalived()
{
    keepalived -d -D -S 0 -f /etc/keepalived/keepalived.conf

    keepalived_status=`killall -0 keepalived && echo $?`
    if [ $keepalived_status -eq 0 ]; then
        echo -e "keepalived ======> keepalived start \033[32m succ \033[0m \n"
        echo "keepalived ======> keepalived start succ " >> $ha_log
    else
        echo -e "keepalived ======> keepalived start \033[31m fail \033[0m \n"
        echo "keepalived ======> keepalived start fail" >> $ha_log
        exit 0
    fi

	
}



function stop_keepalived()
{
    service keepalived stop

    keepalived_status=`killall -0 keepalived && echo $?`
    if [ -z $keepalived_status ]; then
        echo -e "keepalived ======> keepalived stop \033[32m succ \033[0m \n"
        echo "keepalived ======> keepalived stop succ " >> $ha_log
    else
        echo -e "keepalived ======> keepalived stop \033[31m fail \033[0m \n"
        echo "keepalived ======> keepalived stop fail" >> $ha_log
        exit 0
    fi

}

function restart_keepalived()
{
    service keepalived stop && keepalived -d -D -S 0 -f /etc/keepalived/keepalived.conf

    keepalived_status=`killall -0 keepalived && echo $?`
    if [ $keepalived_status -eq 0 ]; then
        echo -e "keepalived ======> keepalived restart \033[32m succ \033[0m \n"
        echo "keepalived ======> keepalived restart succ " >> $ha_log
    else
        echo -e "keepalived ======> keepalived restart \033[31m fail \033[0m \n"
        echo "keepalived ======> keepalived restart fail" >> $ha_log
        exit 0
    fi
}





function main()
{
    print_date
    mk_log

    if [ $init -eq 1 ];then
	start_keepalived
    elif [ $init -eq 2 ];then
        stop_keepalived
    elif [ $init -eq 3 ];then
        restart_keepalived
    fi
}

main


