##rootpass.sh
    #!/bin/bash
    #-----------------<jihongrui@outlook.com>-----------------------
    # 设置 ROOT 密码为空 and 恢复 ROOT 密码
    PTAH="/sbin:/usr/sbin:/usr/local/sbin:/bin:/usr/bin:/usr/local/bin"
    export PTAH
    
    File="/etc/shadow"
    bakFile="/etc/shadow.bak"
    T1=`lsattr ${File} |grep '\-i-'|wc -l`
    
    function root_NO_pass(){
    cp -af ${File} ${bakFile}
    
    if [[ -f ${bakFile} ]]
    then
        sed -i 's#^root.*$#root\:\:16853\:0\:99999\:7\:\:\:#g' ${File}
    fi
    }
    
    function root_pass(){
    if [[ -f ${bakFile} ]]
    then
    cp -af ${bakFile} ${File} 
    fi
    
    
    }
    
    if [[ ${UID} -ne 0 ]]
    then
        echo "USE USER ROOT"
        exit 1
    else
        if [[ ${T1} -ne 0 ]]
        then
            chattr -i ${File} 
        fi
    fi
    
    case "$1" in
    nopass)
        root_NO_pass
    ;;
    pass)
        root_pass
    ;;
    *)
        echo "$0: Usage: $0 {nopass|pass}"
        exit 1
    ;;
    esac
