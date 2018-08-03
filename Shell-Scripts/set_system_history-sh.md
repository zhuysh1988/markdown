## set_system_history.sh
    #!/bin/bash
    
    # jihongrui@outlook.com
    
    #主要功能：
    #
    #可以记录哪个ip和时间(精确到秒)作了哪些命令
    #
    #通过用户登录时候，重新定义HISTFILE
    #
    #HISTFILE文件名包含登录用户名，ip,登录时间(精确到秒)等
    #
    #这样即使相同的用户从不同ip、在不同的时间登录都会被记录
    #
    #可以记录每条命令的开始执行时间
    
    if [[ $UID -eq 0 ]];then
        cat << EOF >> /etc/profile
    # jihongrui add 
    #history
    export HISTTIMEFORMAT="[%Y.%m.%d %H:%M:%S]"
    USER_IP=\`who -u am i 2>/dev/null| awk '{print \$NF}'|sed -e 's/[()]//g'\`
    HISTDIR=/var/log/.hist
    if [ -z \$USER_IP ]
    then
    USER_IP=\`hostname\`
    fi
    if [ ! -d \$HISTDIR ]
    then
    mkdir -p \$HISTDIR
    chmod 777 \$HISTDIR
    fi
    if [ ! -d \$HISTDIR/\${LOGNAME} ]
    then
    mkdir -p \$HISTDIR/\${LOGNAME}
    chmod 300 \$HISTDIR/\${LOGNAME}
    fi
    export HISTSIZE=409600
    DT=\`date +%Y%m%d_%H%M%S\`
    export HISTFILE="\$HISTDIR/\${LOGNAME}/\${USER_IP}.hist.\$DT"
    chmod 600 \$HISTDIR/\${LOGNAME}/*.hist* 2>/dev/null
    EOF
    source /etc/profile
    fi
    
    python_file='Linux_history.py'
    
    if [[ -f ${python_file} ]];then
        path_dir=$(cd `dirname ${0}` && pwd)
    
    #Auto Crontab
    abs_file="${path_dir}/${0}"
    log_file="${abs_file}.log"
    
    if [[ `grep ${abs_file} /etc/crontab|wc -l` -eq 0  ]] && [[ $UID -eq 0 ]]
    then
        echo "59 */1 * * * root python "${abs_file}" &>> "${log_file}" ">> /etc/crontab
    fi
    fi
