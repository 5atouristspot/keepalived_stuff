#!/usr/bin/env bash

############################################################
# Effect : install keepalived
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
    --master         init keepalived master
    --backup         init keepalived backup
    --local_ip|-lp   local real ip
    --remote_ip|-rp  remote real ip
    --virtual_ip|-rp virtaul ip / VIP
EOF
}



while test $# -gt 0
do
    case $1 in
        --master)
        keep_conf='keepalived.conf.sample.master'
        shift
        ;;
        --backup)
        keep_conf='keepalived.conf.sample.backup'
        shift
        ;;
        --local_ip|-lp)
        local_ip=$2
        shift
        ;;
        --remote_ip|-rp)
        remote_ip=$2
        shift
        ;;
        --virtual_ip|-vp)
        virtual_ip=$2
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


install_log='./keepalived_install.log'

function mk_log()
{
    touch $install_log

    if [ -f $install_log ]; then
        echo -e "step.1 ====> $install_log make \033[32m succ \033[0m \n"
        echo "step.1 ====> $install_log make succ" >> $install_log
    else
        echo -e "step.1 ====> $install_log make \033[31m fail \033[0m \n"
        echo "step.1 ====> $install_log make fail" >> $install_log
        exit 0
    fi
}


function print_date()
{
    echo '-------------------'`date`'---------------------' >> $install_log
}

function install_keepalived()
{
    #download keepalived
    #apt-get install keepalived=1:1.2.13-1~ubuntu14.04.1 -y
    apt-get install keepalived=1:1.2.7-1ubuntu1 -y
    
    keepalived_status=`dpkg -l keepalived | grep 'ii  keepalived ' | grep -v grep | wc -l`

    if [ $keepalived_status -ne 0 ];then
        echo -e "keepalived == step.1 ====> keepalived install \033[32m succ \033[0m \n"
        echo "keepalived == step.1 ====> keepalived install succ" >> $install_log
    else
        echo -e "keepalived == step.1 ====> keepalived install \033[31m fail \033[0m \n"
        echo "keepalived == step.1 ====> keepalived install fail" >> $install_log
        exit 0
    fi

    #modify keepalived config
    cp ./$keep_conf /etc/keepalived/
    mv /etc/keepalived/$keep_conf /etc/keepalived/keepalived.conf

    sed -i "s/\[local_real_ip\]/$local_ip/g" /etc/keepalived/keepalived.conf
    sed -i "s/\[remote_real_ip\]/$remote_ip/g" /etc/keepalived/keepalived.conf
    sed -i "s/\[virtual_ip\]/$virtual_ip/g" /etc/keepalived/keepalived.conf

    localip_status=`cat /etc/keepalived/keepalived.conf | grep $local_ip | grep -v grep | wc -l`
    remoteip_status=`cat /etc/keepalived/keepalived.conf | grep $remote_ip | grep -v grep | wc -l`
    virtual_status=`cat /etc/keepalived/keepalived.conf | grep $virtual_ip | grep -v grep | wc -l`

    if [ $localip_status -eq 1 ];then
        echo -e "keepalived == step.2 ====> keepalived config modify local_real_ip \033[32m succ \033[0m \n"
        echo "keepalived == step.2 ====> keepalived config modify local_real_ip succ" >> $install_log
    else
        echo -e "keepalived == step.2 ====> keepalived config modify local_real_ip \033[31m fail \033[0m \n"
        echo "keepalived == step.2 ====> keepalived config modify local_real_ip fail" >> $install_log
        exit 0
    fi


    if [ $remoteip_status -eq 1 ];then
        echo -e "keepalived == step.3 ====> keepalived config modify remote_real_ip \033[32m succ \033[0m \n"
        echo "keepalived == step.3 ====> keepalived config modify remote_real_ip succ" >> $install_log
    else
        echo -e "keepalived == step.3 ====> keepalived config modify remote_real_ip \033[31m fail \033[0m \n"
        echo "keepalived == step.3 ====> keepalived config modify remote_real_ip fail" >> $install_log
        exit 0
    fi

    if [ $virtual_status -eq 1 ];then
        echo -e "keepalived == step.4 ====> keepalived config modify virtual_ip \033[32m succ \033[0m \n"
        echo "keepalived == step.4 ====> keepalived config modify virtual_ip succ" >> $install_log
    else
        echo -e "keepalived == step.4 ====> keepalived config modify virtual_ip \033[31m fail \033[0m \n"
        echo "keepalived == step.4 ====> keepalived config modify virtual_ip fail" >> $install_log
        exit 0
    fi

    #copy keepalived_check_mfsmaster.sh to /etc/keepalived/
    cp ./keepalived_check_mfsmaster.sh /etc/keepalived/

    if [ -e /etc/keepalived/keepalived_check_mfsmaster.sh ]; then
        echo -e "keepalived == step.5 ====> /etc/keepalived/keepalived_check_mfsmaster.sh make \033[32m succ \033[0m \n"
        echo "keepalived == step.5 ====> /etc/keepalived/keepalived_check_mfsmaster.sh make succ" >> $install_log
    else
        echo -e "keepalived == step.5 ====> /etc/keepalived/keepalived_check_mfsmaster.sh make \033[31m fail \033[0m \n"
        echo "keepalived == step.5 ====> /etc/keepalived/keepalived_check_mfsmaster.sh make fail" >> $install_log
        exit 0
    fi
    #copy moosefsha.sh to /etc/keepalived/
    cp ./moosefsha.sh /etc/keepalived/
    
    if [ -e /etc/keepalived/moosefsha.sh ]; then
        echo -e "keepalived == step.6 ====> /etc/keepalived/moosefsha.sh make \033[32m succ \033[0m \n"
        echo "keepalived == step.6 ====> /etc/keepalived/moosefsha.sh make succ" >> $install_log
    else
        echo -e "keepalived == step.6 ====> /etc/keepalived/moosefsha.sh make \033[31m fail \033[0m \n"
        echo "keepalived == step.6 ====> /etc/keepalived/moosefsha.sh make fail" >> $install_log
        exit 0
    fi


    #copy keepalivedha.sh to /etc/keepalived/
    cp ./keepalivedha.sh /etc/keepalived/

    if [ -e /etc/keepalived/keepalivedha.sh ]; then
        echo -e "keepalived == step.7 ====> /etc/keepalived/keepalivedha.sh make \033[32m succ \033[0m \n"
        echo "keepalived == step.7 ====> /etc/keepalived/keepalivedha.sh make succ" >> $install_log
    else
        echo -e "keepalived == step.7 ====> /etc/keepalived/keepalivedha.sh make \033[31m fail \033[0m \n"
        echo "keepalived == step.7 ====> /etc/keepalived/keepalivedha.sh make fail" >> $install_log
        exit 0
    fi
}

function modify_rsyslog()
{
    #download rsyslog
    apt-get install rsyslog -y

    rsyslog_status=`dpkg -l rsyslog | grep 'ii  rsyslog ' | grep -v grep | wc -l`

    if [ $rsyslog_status -ne 0 ];then
        echo -e "rsyslog == step.1 ====> rsyslog install \033[32m succ \033[0m \n"
        echo "rsyslog == step.1 ====> rsyslog install succ" >> $install_log
    else
        echo -e "rsyslog == step.1 ====> rsyslog install \033[31m fail \033[0m \n"
        echo "rsyslog == step.1 ====> rsyslog install fail" >> $install_log
        exit 0
    fi

    #add keepalived syslog
    keeplog_status=`cat /etc/rsyslog.conf | grep '/var/log/keepalived' | grep -v grep | wc -l`
    if [ $keeplog_status -eq 0 ]; then
        echo "local0.*                 /var/log/keepalived" >> /etc/rsyslog.conf
    fi

    keeplog_status=`cat /etc/rsyslog.conf | grep '/var/log/keepalived' | grep -v grep | wc -l`
    if [ $keeplog_status -ne 0 ];then
        echo -e "rsyslog == step.2 ====> keepalived /etc/rsyslog.conf append \033[32m succ \033[0m \n"
        echo "rsyslog == step.2 ====> keepalived /etc/rsyslog.conf append succ" >> $install_log
    else
        echo -e "rsyslog == step.2 ====> keepalived /etc/rsyslog.conf append \033[31m fail \033[0m \n"
        echo "rsyslog == step.2 ====> keepalived /etc/rsyslog.conf append fail" >> $install_log
        exit 0
    fi

    #restart rsyslog
    /etc/init.d/rsyslog restart

    rsys_status=`killall -0 rsyslogd && echo $?`
    if [ $rsys_status -eq 0 ]; then
        echo -e "rsyslog == step.3 ====> keepalived rsyslog restart \033[32m succ \033[0m \n"
        echo "rsyslog == step.3 ====> keepalived rsyslog restart succ" >> $install_log
    else
        echo -e "rsyslog == step.3 ====> keepalived rsyslog restart \033[31m fail \033[0m \n"
        echo "rsyslog == step.3 ====> keepalived rsyslog restart fail" >> $install_log
        exit 0
    fi

}


function install_postfix()
{
    #download postfix
    apt-get install postfix -y

    postfix_status=`dpkg -l postfix | grep 'ii  postfix ' | grep -v grep | wc -l`

    if [ $postfix_status -ne 0 ];then
        echo -e "postfix == step.1 ====> postfix install \033[32m succ \033[0m \n"
        echo "postfix == step.1 ====> postfix install succ" >> $install_log
    else
        echo -e "postfix == step.1 ====> postfix install \033[31m fail \033[0m \n"
        echo "postfix == step.1 ====> postfix install fail" >> $install_log
        exit 0
    fi

    #modify postfix main.cf
    sed -i 's/^relayhost/#relayhost/g' /etc/postfix/main.cf

    #append /etc/postfix/main.cf
    relayhost_status=`cat /etc/postfix/main.cf | egrep "^relayhost" | grep -v grep | wc -l`
    if [ $relayhost_status -eq 0 ]; then
        echo "relayhost = [smtp.exmail.qq.com]:25" >> /etc/postfix/main.cf
    fi

    auth_status=`cat /etc/postfix/main.cf | egrep "^smtp_sasl_auth_enable" | grep -v grep | wc -l`
    if [ $auth_status -eq 0 ]; then
        echo "smtp_sasl_auth_enable = yes" >> /etc/postfix/main.cf
    fi

    password_status=`cat /etc/postfix/main.cf | egrep "^smtp_sasl_password_maps" | grep -v grep | wc -l`
    if [ $password_status -eq 0 ]; then
        echo "smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd" >> /etc/postfix/main.cf
    fi

    security_status=`cat /etc/postfix/main.cf | egrep "^smtp_sasl_security_options" | grep -v grep | wc -l`
    if [ $security_status -eq 0 ]; then
        echo "smtp_sasl_security_options = noanonymous" >> /etc/postfix/main.cf
    fi

    type_status=`cat /etc/postfix/main.cf | egrep "^smtp_sasl_type" | grep -v grep | wc -l`
    if [ $type_status -eq 0 ]; then
        echo "smtp_sasl_type = cyrus" >> /etc/postfix/main.cf
    fi

    sender_status=`cat /etc/postfix/main.cf | egrep "^sender_canonical_maps" | wc -l`
    if [ $sender_status -eq 0 ]; then
        echo "sender_canonical_maps = hash:/etc/postfix/sender_canonical" >> /etc/postfix/main.cf
    fi

    main_status=`cat /etc/postfix/main.cf | egrep "^relayhost|^smtp_sasl_auth_enable|^smtp_sasl_password_maps|^smtp_sasl_security_options|^smtp_sasl_type = cyrus|^sender_canonical_maps" | grep -v grep | wc -l`

    if [ $main_status -eq 6 ];then
        echo -e "postfix == step.2 ====> /etc/postfix/main.cf modify \033[32m succ \033[0m \n"
        echo "postfix == step.2 ====> /etc/postfix/main.cf modify succ" >> $install_log
    else
        echo -e "postfix == step.2 ====> /etc/postfix/main.cf modify \033[31m fail \033[0m \n"
        echo "postfix == step.2 ====> /etc/postfix/main.cf modify fail" >> $install_log
        exit 0
    fi



    #append /etc/postfix/sasl_passwd
    saspass_status=`touch /etc/postfix/sasl_passwd && cat /etc/postfix/sasl_passwd | grep back_res_service | grep -v grep | wc -l`
    if [ $saspass_status -eq 0 ]; then
        echo '[smtp.exmail.qq.com]:25 back_res_service@dangjianwang.com:$eCf8427e#' >> /etc/postfix/sasl_passwd    
        postmap /etc/postfix/sasl_passwd
    fi

    saspass_status=`touch /etc/postfix/sasl_passwd && cat /etc/postfix/sasl_passwd | grep back_res_service | grep -v grep | wc -l`
    if [ $saspass_status -ne 0 ];then
        echo -e "postfix == step.3 ====> /etc/postfix/sasl_passwd modify \033[32m succ \033[0m \n"
        echo "postfix == step.3 ====> /etc/postfix/sasl_passwd modify succ" >> $install_log
    else
        echo -e "postfix == step.3 ====> /etc/postfix/sasl_passwd modify \033[31m fail \033[0m \n"
        echo "postfix == step.3 ====> /etc/postfix/sasl_passwd modify fail" >> $install_log
        exit 0
    fi


    #append /etc/postfix/sender_canonical
    canonical_status=`touch /etc/postfix/sender_canonical && cat /etc/postfix/sender_canonical | grep back_res_service | grep -v grep | wc -l`
    if [ $canonical_status -eq 0 ]; then
        echo 'root back_res_service@dangjianwang.com' >> /etc/postfix/sender_canonical
        postmap /etc/postfix/sender_canonical
    fi

    canonical_status=`touch /etc/postfix/sender_canonical && cat /etc/postfix/sender_canonical | grep back_res_service | grep -v grep | wc -l`
    if [ $canonical_status -ne 0 ];then
        echo -e "postfix == step.4 ====> /etc/postfix/sender_canonical modify \033[32m succ \033[0m \n"
        echo "postfix == step.4 ====> /etc/postfix/sender_canonical modify succ" >> $install_log
    else
        echo -e "postfix == step.4 ====> /etc/postfix/sender_canonical modify \033[31m fail \033[0m \n"
        echo "postfix == step.4 ====> /etc/postfix/sender_canonical modify fail" >> $install_log
        exit 0
    fi

    #restart postfix
    service postfix restart
    postfix_status=`ps -ef | grep "postfix/master" | grep -v grep | wc -l`

    if [ $postfix_status -eq 1 ];then
        echo -e "postfix == step.5 ====> postfix restart \033[32m succ \033[0m \n"
        echo "postfix == step.5 ====> postfix restart succ" >> $install_log
    else
        echo -e "postfix == step.5 ====> postfix restart \033[31m fail \033[0m \n"
        echo "postfix == step.5 ====> postfix restart fail" >> $install_log
        exit 0
    fi    

}


function main()
{
    print_date
    mk_log

    install_keepalived
    modify_rsyslog
    install_postfix
}

main

