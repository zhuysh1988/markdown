##code_backup.sh
    #!/bin/bash
    #printf "%-15s %+30s\n" $0 jihongrui@outlook.com
    
    LANG="en_US.UTF-8"
    PATH="/sbin:/usr/sbin:/usr/local/sbin:/bin:/usr/bin:/usr/local/bin:"
    export PATH
    ##############################################################################################################
    
    # Set Tar File Time
    DATE="$(date +%F)"
    # Set Local Backup Directory
    BAKDIR="/codebak"
    
    
    
    
    ##############################################################################################################
    # 取的本机的IP
    function Get_rip(){
    local ip_file='/etc/ssh/ip.pid'
    if [[ -f $ip_file ]] ;then
            local -r check_ip=$(awk -F '=' '{print $2}' "${ip_file}")
            if  [[ "${check_ip}" != "" ]];then
                    RIP="${check_ip}"
            else
    
    # 检测命令
    if ip &>/dev/null 
    then
        RIPS=$(/sbin/ip addr |grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'|grep -Ev '255|127\.0\.0\.1|0\.0\.0\.0')
    else
        RIPS=$(ifconfig |grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'|grep -Ev '255|127\.0\.0\.1|0\.0\.0\.0')
    fi
    
    # 取默认网关IP的前三位 以和 IP 做比对
    DEGAWAY1=$(route -nee |grep 'UG' |awk '{print $2}'|awk -F \. '{print $1"."$2"."$3}')
    DEGAWAY2=$(netstat -r | grep 'default' |awk '{print $2}'|awk -F \. '{print $1"."$2"."$3}')
    if [[ "${DEGAWAY1}" == "${DEGAWAY2}" ]];then
            DEGAWAY=${DEGAWAY2}
    else
            DEGAWAY=${DEGAWAY1}
    fi
    
    
    # 取能连接外网的IP
    for ip in ${RIPS};
    do
            ip3=$(echo "${ip}" |awk -F \. '{print $1"."$2"."$3}')
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
    fi
    }
    ##############################################################################################################
    
    function check_bak(){
    local -r network_nu=$(echo "${RIP}" | awk -F \. '{print $3}')
    if [[ "${network_nu}" == '85' ]];then
    
    	SCPBAK="backup@192.168.85.185:/data4/85bak/${RIP}/"
    	REMOTEBAK="/data4/85bak/${RIP}"
    	(ssh  backup@192.168.85.185 "if [ ! -d ${REMOTEBAK} ];then mkdir -p ${REMOTEBAK} ;fi")
    else
    	SCPBAK="backup@192.168.88.250:/data4/88bak/${RIP}/"
    	REMOTEBAK="/data4/88bak/${RIP}"
    	(ssh  backup@192.168.88.250 "if [ ! -d ${REMOTEBAK} ];then mkdir -p ${REMOTEBAK} ;fi")
    fi
    }
    ##############################################################################################################
    
    
    ##############################################################################################################
    
    
    
    ##############################################################################################################
    
    
    function bak(){
    if [[ ! -f ${TAR} ]];then
    
    if [[ ${lenCodeDirs} -eq 0 ]]
    then
    	
    	tar  jcfp "${TAR}"   --exclude "${DIR}/logs" "${DIR}" &>/dev/null && \
            scp "${TAR}" "${SCPBAK}"  && \
            echo "${DATE}_${BZ2} is backup ok"
            echo "${DATE}_${BZ2} is backup ok" >> "${daylog}"
    else
    
    	declare -a bakdir
    	nu=0
    	for CodeDir in "${CodeDirs[@]}"
    	do
    		if [[ ${nu} -lt ${lenCodeDirs} ]]
    		then
    			if [[ -d ${CodeDir} ]];then
    			bakdir[$nu]=${CodeDir}
    			fi
    			let nu+=1
    		fi
    	done
    	tar jcfp "${TAR}" --exclude "${DIR}/logs" "${DIR}"  "${bakdir[*]}" &>/dev/null && \
    	scp "${TAR}"  "${SCPBAK}"  && \
            echo "${DATE}_${BZ2} is backup ok"
            echo "${DATE}_${BZ2} is backup ok" >> "${daylog}"
    fi
    
    fi
    
    }
    
    ##############################################################################################################
    # Get Server IP Address
    Get_rip
    
    # Set Remote Directory From IP Address
    check_bak
    
    
    
    #Check Backup Directory 
    
    if [ ! -d ${BAKDIR} ] 
    then
    	mkdir -p ${BAKDIR}
    fi
    
    # this scripts end , send massage from ${daylog}.log to mail  
    daylog="${BAKDIR}/${DATE}.log"
    touch "${daylog}"
    echo "${DATE} backup start" >> "${daylog}"
    
    # Backup Codes
    
    for DIR in $(ps -ef |grep java|grep -o '\-Dcatalina\.home.*\-Djava'|awk -F "=" '{print $2}'|awk '{print $1}')
    do
    
    
        CodeDirs=("$(grep -o "docBase=.*" "${DIR}/conf/server.xml" |awk '{print $1}'|cut -d= -f2|tr -d "\"")")
        BZ2=$(echo "${DIR}"|tr "/_" ".-")
        TAR="${BAKDIR}/${DATE}_${BZ2}.tar.bz2"
    
    #if webcode directory no set,def /tomcat/webapps
    	if [[ ${CodeDirs[*]} == '' ]];then 
    		CodeDirs[0]="${DIR}/webapps" 
    	fi
    
    
    	for SDIR in "${CodeDirs[@]}"
    	do
    		       # check local backup directory this tomcat backup file number ,if eq 0 then run 1 backup
    		       BAKFILE_NU=$(ls "${BAKDIR}"| grep -c "${BZ2}.tar.bz2")
                           MTI=$(find "${SDIR}" -mtime -1 |wc -l)
                           CTI=$(find "${SDIR}" -ctime -1 |wc -l)
                           if [[ ${MTI} -ne 0 ]] || [[ ${CTI} -ne 0 ]] || [[ ${BAKFILE_NU} -eq 0 ]]
                           then
    				bak
    		       fi
    	done
    done
    
    
    ##############################################################################################################
    echo "${DATE} backup end" >> "${daylog}"
    curl --data-ascii "ip=${RIP}&message=$(cat "${daylog}")&to=5969@dingtalk.com" http://python.test.com/mail/  &>/dev/null
    rm -f "${daylog}"
    
    ##############################################################################################################
    #Auto Crontab
    path_dir=$(cd "$(dirname "${0}")" && pwd)
    file=$(echo "$0"|awk -F '/' '{print $NF}')
    #Auto Crontab
    abs_file="${path_dir}/${file}"
    log_file="${abs_file}.log"
    
    if [[ $(grep -c "${abs_file}" /etc/crontab) -eq 0  ]] && [[ $UID -eq 0 ]]
    then
        echo "59 23 * * * ${USER} ${SHELL} ${abs_file} &>> ${log_file} ">> /etc/crontab
    fi
    ##############################################################################################################
    
