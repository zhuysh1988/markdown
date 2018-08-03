    #!/bin/bash
    # jihongrui@jsqix.com
    # 每天检查当日 SSH 异常时间登陆 和 系统关键位置文件有没有修改
    ###########################################################################################
    #Auto Crontab
    path_dir=$(cd "$(dirname "${0}")" && pwd)
    file=$(echo "$0"|awk -F '/' '{print $NF}')
    abs_file="${path_dir}/${file}"
    log_file="${abs_file}.log"
    
    if [[ $(grep -c "${abs_file}" /etc/crontab) -eq 0  ]] && [[ $UID -eq 0 ]]
    then
        echo "59 23 * * * ${USER} ${SHELL} ${abs_file} &>> ${log_file} ">> /etc/crontab
    fi
    ###########################################################################################
    
    #day=$(date +%d)
    DIP=$(awk -F '=' '{print $2}' /etc/ssh/ip.pid)
    DATE=$(date +%F)
    
    TEST="/var/log/secure"
    
    Email="/tmp/server.txt"
    echo -e "${DATE}\n 非正常时间登陆 ${DIP} 列表\n" > "${Email}"
    awk '{split($3,tA,"");TI=tA[1]tA[2];AI=TI+0;if($2=='""$day""' && AI<7 && AI>20 && $6 ~/Accepted/)print  $3, $11, $9, "Login '"$DIP"'" }' "${TEST}" >> "${Email}" 
    echo -e "\n\n" >> "${Email}"
    echo -e "${DATE}\n${DIP}\t重要文件被修改记录\n" >> "${Email}"
    DIRs=(
    /boot
    /etc
    /bin
    /sbin
    /usr/bin
    /usr/sbin
    /usr/local/bin
    /usr/local/sbin
    )
    for Dir in "${DIRs[@]}"
    do
    find ${Dir} -type f -mtime -1 -ctime -1 >>$Email
    done
    
    
    #检测输出信息，如没有信息输出，就不发送邮件
    
    TEST_NU=$(grep '[Login|\/]' ${Email}|grep -v 'prelink.cache' |wc -l)
    if [ ${TEST_NU} -ne 0 ]
    then
        curl --data-ascii "ip=${DIP}&message=$(cat "${Email}")&to=1537@qq.com" http://python.test.com/mail/  &>/dev/null 
         rm -f "${Email}"
    fi
    
    
