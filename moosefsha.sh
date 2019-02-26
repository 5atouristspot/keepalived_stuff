#!/bin/bash

############################################################
# Effect : moosefs high avilable
# OS environment: For Ubuntu 14.04 LTS Trusty and above
#
# author: zhihao0905
# creat_time: 2017-8-18
# modify time:
############################################################

help(){
       cat << EOF
Usage:
Options:
    --startmaster|-sm         start master
    --stopmaster|-pm          stop master
    --restartmaster|-psm      restart master
    --restoremaster|-asm      restore master
EOF
}

init=0


while test $# -gt 0
do
    case $1 in
        --startmaster|-sm)
        init=1
        shift
        ;;
        --stopmaster|-pm)
        init=2
        shift
        ;;
        --restartmaster|-psm)
        init=3
        shift
        ;;
        --restoremaster|-asm)
        init=4
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



ha_log='./mfs_ha.log'

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



function start_master()
{
    mfsmaster start

    mfsmaster_status=`killall -0 mfsmaster && echo $?`
    if [ $mfsmaster_status -eq 0 ]; then
        echo -e "master ======> mfsmaster start \033[32m succ \033[0m \n"
        echo "master ======> mfsmaster start succ " >> $ha_log
    else
        echo -e "master ======> mfsmaster start \033[31m fail \033[0m \n"
        echo "master ======> mfsmaster start fail" >> $ha_log
        exit 0
    fi

	
}

function restore_master()
{
    mfsmaster -a

    mfsmaster_status=`killall -0 mfsmaster && echo $?`
    if [ $mfsmaster_status -eq 0 ]; then
        echo -e "master ======> mfsmaster restore start \033[32m succ \033[0m \n"
        echo "master ======> mfsmaster restore start succ " >> $ha_log
    else
        echo -e "master ======> mfsmaster restore start \033[31m fail \033[0m \n"
        echo "master ======> mfsmaster restore start fail" >> $ha_log
        exit 0
    fi


}



function stop_master()
{
    mfsmaster stop

    mfsmaster_status=`killall -0 mfsmaster && echo $?`
    if [ -z $mfsmaster_status ]; then
        echo -e "master ======> mfsmaster stop \033[32m succ \033[0m \n"
        echo "master ======> mfsmaster stop succ " >> $ha_log
    else
        echo -e "master ======> mfsmaster stop \033[31m fail \033[0m \n"
        echo "master ======> mfsmaster stop fail" >> $ha_log
        exit 0
    fi

}

function restart_master()
{
    mfsmaster restart

    mfsmaster_status=`killall -0 mfsmaster && echo $?`
    if [ $mfsmaster_status -eq 0 ]; then
        echo -e "master ======> mfsmaster restart \033[32m succ \033[0m \n"
        echo "master ======> mfsmaster restart succ " >> $ha_log
    else
        echo -e "master ======> mfsmaster restart \033[31m fail \033[0m \n"
        echo "master ======> mfsmaster restart fail" >> $ha_log
        exit 0
    fi
}





function main()
{
    print_date
    mk_log

    if [ $init -eq 1 ];then
	start_master
    elif [ $init -eq 2 ];then
        stop_master
    elif [ $init -eq 3 ];then
        restart_master
    elif [ $init -eq 4 ];then
        restore_master
    fi
}

main

