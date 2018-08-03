## set_hostname.sh
    #!/bin/bash
    #-----------------<jihongrui@outlook.com>-----------------------
    # 根据IP地址的后两段,设置hostname
    # 192.168.11.22   set   22.11.domain.com
    
    PTAH="/sbin:/usr/sbin:/usr/local/sbin:/bin:/usr/bin:/usr/local/bin"
    export PTAH
    
    domain='domain.com'
    
    # 记录本机IP至这个文件
    ip_file='/etc/ssh/ip.pid'
    
    # 取的本机的IP
    function Get_rip(){
    if [[ -f $ip_file ]] && [[ `awk -F \= '{print $2}' $ip_file` != "" ]];then
        RIP=`awk -F \= '{print $2}' $ip_file`
    else
    
    # 检测命令
    which ip &>/dev/null
    if [[ $? -ge 0 ]];then
        HOSTIPS=(`/sbin/ip addr |egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'|egrep -v '255|127\.0\.0\.1|0\.0\.0\.0'`)
    else
        HOSTIPS=(`ifconfig |egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'|egrep -v '255|127\.0\.0\.1|0\.0\.0\.0'`)
    fi
    
    # 取默认网关IP的前三位 以和 IP 做比对
    DEGAWAY1=`route -nee |grep 'UG' |awk '{print $2}'|awk -F \. '{print $1"."$2"."$3}'`
    DEGAWAY2=`netstat -r | grep 'default' |awk '{print $2}'|awk -F \. '{print $1"."$2"."$3}'`
    if [[ "${DEGAWAY1}" == "${DEGAWAY2}" ]];then
            DEGAWAY=${DEGAWAY2}
    else
            DEGAWAY=${DEGAWAY1}
    fi
    
    
    # 取能连接外网的IP
    for ip in ${HOSTIPS};
    do
            ip3=`echo ${ip} |awk -F \. '{print $1"."$2"."$3}'`
            if [[ "${ip3}" == "${DEGAWAY}" ]];then
                    if [[ $(ping -c 2 223.5.5.5 &>/dev/null ; echo $?) -eq 0 ]];then
                            RIP=${ip}
                    else
                            echo "IP ERROR"
                            exit 1
                    fi
            fi
    done
    echo "RIP=${RIP}" > $ip_file
    fi
    }
    
    Get_rip
    
    HOSTIP=${RIP}
    
    HOST=$(echo $HOSTIP |awk -F\. '{print $4"."$3".${domain}"}')
    
    if [[ ${HOST} != "" ]] && [[ $HOSTIP != "" ]]
            then
                    hostname ${HOST}
                    echo "${HOSTIP}  ${HOST}" >> /etc/hosts
                    echo "127.0.0.1  ${HOST}" >> /etc/hosts
                    sed -i 's#^HOSTNAME\=.*$#HOSTNAME\='$(echo ${HOST})'#g' /etc/sysconfig/network
    fi
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
