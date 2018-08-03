## set_bond0.sh
    #!/bin/bash
    #=======================>jihongrui-sd@qq.com <============================
    # 绑定多个网卡为bond0 适用于CentOS 5 / 6
    # 会将所有网卡都绑定
    PATH="/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/sbin:/usr/local/bin:"
    export PATH
    
    # IP
    BONDIP='192.168.111.222'
    BONDMASK='255.255.255.0'
    
    BONDGWAY='192.168.111.1'
    
    BONDDNS1='192.168.111.1'
    BONDDNS2='223.5.5.5'
    BONDDNS3='180.76.76.76'
    
    # 配置文件目录
    NDIR="/etc/sysconfig/network-scripts/"
    
    # bond 网卡名
    BOND="ifcfg-bond0"
    # bond 模式
    MODE='5'
    
    ###################################################################################
    
    sed -i '/GATEWAY/d' /etc/sysconfig/network
    echo "GATEWAY=$BONDGWAY" >> /etc/sysconfig/network
    {
    echo "nameserver $BONDDNS1"
    echo "nameserver $BONDDNS2"
    echo "nameserver $BONDDNS3"
    } > /etc/resolv.conf
    
    
    ###################################################################################
    function NewNE(){
    # 备份原文件
    BAKDIR="/var/bak/network"
    [ ! -d ${BAKDIR} ] && mkdir -p "${BAKDIR}"
    tar cf "${BAKDIR}/$(date +%F_%R)_network-scripts.tar.gz" "${NDIR}" &>/dev/null
    
    #
    for ((i=$1;i<=$2;i++))
    
    do
    
    sed -i '/^IPADDR.*$/d' "${NDIR}${NE}${i}"
    sed -i '/^NETMASK.*$/d' "${NDIR}${NE}${i}"
    sed -i '/^GATEWAY.*$/d' "${NDIR}${NE}${i}"
    sed -i '/^DNS.*$/d' "${NDIR}${NE}${i}"
    sed -i '/^PREFIX.*$/d' "${NDIR}${NE}${i}"
    sed -i '/UUID/d' "${NDIR}${NE}${i}"
    sed -i 's#^ONBOOT\=no$#ONBOOT\=yes#g' "${NDIR}${NE}${i}"
    sed -i 's#^BOOTPROTO=dhcp$#BOOTPROTO=none#g' "${NDIR}${NE}${i}"
    sed -i '$a MASTER=bond0' "${NDIR}${NE}${i}"
    sed -i '$a SLAVE=yes' "${NDIR}${NE}${i}"
    sed -i '$a USERCTL=no' "${NDIR}${NE}${i}"
    sed -i '$a IPV6INIT=no' "${NDIR}${NE}${i}"
    done
    bondinst
    }
    
    ###################################################################################
    function bondinst(){
    
    
    #touch bond0
    {
    echo "DEVICE=bond0"
    #echo "USERCTL=no"
    echo "TYPE=Ethernet"
    echo "ONBOOT=yes"
    #echo "NM_CONTROLLED=yes"
    echo "BOOTPROTO=static"
    echo "IPADDR=$BONDIP"
    echo "NETMASK=$BONDMASK"
    } > "${NDIR}${BOND}"
    
    # add bond0 in dist.conf
    Centos5="/etc/modprobe.conf"
    Centos6="/etc/modprobe.d/dist.conf"
    if [[ -f ${Centos5} ]] && [[ ! -f ${Centos6} ]]
    then
        Files=${Centos5}
    else
        Files=${Centos6}
    fi
    if [[ $(grep 'bond' ${Files}) == "" ]]
    then
    {
    echo "alias bond0 bonding"
    echo "options bond0 miimon=100 mode=$MODE"
    }>> ${Files}
    
    service network restart
    fi
    }
    ###################################################################################
    
    function main(){
    # Check eth0 or em1
    T1=$(ls ${NDIR} |grep -c '^ifcfg-em.$')
    T2=$(ls ${NDIR} |grep -c '^ifcfg-eth.$')
    
    if [[ "$T1" -ne 0 ]] && [[ "$T2" -eq 0 ]]
    then
        NE="ifcfg-em"
        NewNE 1 "${T1}"
    else
        NE="ifcfg-eth"
        NewNE 0 "$((T2-1))"
    fi
    }
    
    ###################################################################################
    main
