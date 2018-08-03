#服务器多IP取出IP:

    ip_file='/etc/ssh/ip.pid'
    
    function Get_rip(){
    
    if [[ -f $ip_file ]] && [[ `cat $ip_file |wc -l` -eq 1 ]];then
            RIP=`awk -F \= '{print $2}' $ip_file`
    else
    
    HOSTIPS=(`/sbin/ip addr |egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'|egrep -v '255|127\.0\.0\.1'`)
    
    
    # 取默认网关IP的前三位 以和 IP 做比对
    DEGAWAY1=`route -nee |grep 'UG' |awk '{print $2}'|awk -F \. '{print $1"."$2"."$3}'`
    DEGAWAY2=`netstat -r | grep 'default' |awk '{print $2}'|awk -F \. '{print $1"."$2"."$3}'`
    if [[ "${DEGAWAY1}" == "${DEGAWAY2}" ]];then
            DEGAWAY=${DEGAWAY2}
    else
            DEGAWAY=${DEGAWAY1}
    fi
    echo ${DEGAWAY}
    
    
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


#Centos版本

    VERSION1=`uname -r|awk -F \. '{print $1}'`
    VERSION2=`uname -r|awk -F \. '{print $2}'`
    VERSION3=`uname -r|awk -F \. '{print $3}'|awk -F \- '{print $1}'`
    if [[ ${VERSION1} -eq 2 ]] && [[ ${VERSION2} -le 6 ]] && [[ ${VERSION3} -lt 30 ]];then
            REPO="http://repo.zabbix.com/zabbix/3.0/rhel/5/x86_64/zabbix-release-3.0-1.el5.noarch.rpm"
            SYS=5
    elif [[ ${VERSION1} -eq 2 ]] && [[ ${VERSION2} -ge 6 ]] && [[ ${VERSION3} -ge 30 ]];then
            REPO="http://repo.zabbix.com/zabbix/3.0/rhel/6/x86_64/zabbix-release-3.0-1.el6.noarch.rpm"
            SYS=6
    elif [[ ${VERSION1} -eq 3 ]] ;then
            REPO="http://repo.zabbix.com/zabbix/3.0/rhel/7/x86_64/zabbix-release-3.0-1.el7.noarch.rpm"
            SYS=7
    else
            echo "CHECK VERSION ERROR "
            exit 2
    fi
    echo ${REPO}
    echo ${SYS}
