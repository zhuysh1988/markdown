##chattr.sh
    #!/bin/bash
    #printf "%-15s %+30s\n" $0 jihongrui@outlook.com
    #LANG="en_US.UTF-8"
    PATH="/sbin:/usr/sbin:/usr/local/sbin:/bin:/usr/bin:/usr/local/bin:"
    export PATH
    #锁定关键文件和日志
    
    FILE=(
    /etc/passwd
    /etc/group
    /etc/shadow
    /etc/gshadow
    /etc/inittab
    /etc/sudoers
    )
    
    LOG=(
     /var/log/messages
     /var/log/secure
     /var/log/lastlog
    )
    
    function file(){
    if [[ $1 == "+" ]];then
        AA='+i'
    else
        AA='-i'
    fi
    for x in ${FILE[@]}
    do
        chattr ${AA} ${x}
    done
    }
    
    function log(){
    if [[ $1 == "+" ]];then
        AA='+a'
    else
        AA='-a'
    fi
    for x in ${LOG[@]}
    do
        chattr ${AA} ${x}
    done
    }
    
    
    if [[ $UID != "0" ]]
    then
        echo "Plsase Use root or sudo $0 "
    fi
    case $1 in 
        file+)
            file +
            ;;
        file-)
            file -
            ;;
        log+)
            log +
            ;;
        log-)
            log -
            ;;
        *)
            echo $"Usage: $0 {file+ |file-|log+|log-}"
            exit 2
    esac
    
