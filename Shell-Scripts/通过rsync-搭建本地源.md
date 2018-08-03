# 通过rsync 搭建本地源
## 脚本:
    #!/bin/bash
    # jihongrui@allcmd.com
    
    
    # mirrors.yun-idc.com 这个源可以rsync
    # 这个目录是本地存放目录
    Centos_6_base='/data/web_root/yum/centos/6'
    # 这个是源链接 不要带  http://
    yumidc='mirrors.yun-idc.com/centos/6/os/x86_64/'
    
    
    
    RsyncBin="/usr/bin/rsync"
    RsyncPerm='-avrt --delete --no-iconv --bwlimit=1000'
    LogFile='/var/log/yum/rsync_yum_log'
    Date=`date +%Y-%m-%d`
    
    #check
    function check {
    if [ $? -eq 0 ];then
        echo -e "\033[1;32mRsync is success!\033[0m" >>$LogFile/$Date.log
    else
        echo -e "\033[1;31mRsync is fail!\033[0m" >>$LogFile/$Date.log
    fi
    }
    
    if [ ! -d "$LogFile" ];then
        mkdir -p $LogFile
    fi
    
    
    # start
    
    echo 'Now start to rsync centos 6 base!' >>$LogFile/$Date.log
    $RsyncBin $RsyncPerm rsync://$yumidc $Centos_6_base >>$LogFile/$Date.log
    check
    
    
    #Auto Crontab
    path_dir=$(cd "$(dirname "${0}")" && pwd)
    file=$(echo "$0"|awk -F '/' '{print $NF}')
    abs_file="${path_dir}/${file}"
    log_file="${abs_file}.log"
    
    if [[ $(grep -c "${abs_file}" /etc/crontab) -eq 0  ]] && [[ $UID -eq 0 ]]
    then
        echo "59 23 * * * ${USER} ${SHELL} ${abs_file} &>> ${log_file} ">> /etc/crontab
    fi
    
## Centos.repo
### 把域名换成你自己的,IP也可以, 7和6一样,把目录改成7的就可以
    [test]
    name=CentOS-$releasever - test
    baseurl=http://mirrors.test.com/centos/6
    gpgcheck=1
    enabled=1
    gpgkey=http://mirrors.test.com/centos/6/RPM-GPG-KEY-CentOS-6
## Ubuntu
### 把域名换成你自己的,IP也可以
    deb http://mirrors.yun-idc.com/ubuntu/ trusty main restricted universe multiverse
    deb http://mirrors.yun-idc.com/ubuntu/ trusty-security main restricted universe multiverse
    deb http://mirrors.yun-idc.com/ubuntu/ trusty-updates main restricted universe multiverse
    deb http://mirrors.yun-idc.com/ubuntu/ trusty-proposed main restricted universe multiverse
    deb http://mirrors.yun-idc.com/ubuntu/ trusty-backports main restricted universe multiverse
    deb-src http://mirrors.yun-idc.com/ubuntu/ trusty main restricted universe multiverse
    deb-src http://mirrors.yun-idc.com/ubuntu/ trusty-security main restricted universe multiverse
    deb-src http://mirrors.yun-idc.com/ubuntu/ trusty-updates main restricted universe multiverse
    deb-src http://mirrors.yun-idc.com/ubuntu/ trusty-proposed main restricted universe multiverse
    deb-src http://mirrors.yun-idc.com/ubuntu/ trusty-backports main restricted universe multiverse
