## mysql_xtrabackup.sh

    #!/bin/bash
    ### Use innobackupex Backup Mysql Database For Everyday
    
    # 必须设置 
    
    # 
    
    Backup_dir='/home/mysql_bak'		
    
    Mysql_sock='/var/lib/mysql/mysql.sock'
    
    User='root'
    
    Password=''
    
    # 按 , 号分割,可写多个
    Database=''
    
    
    ########################################################################################
    function chk_mysql_runing(){
    local ps_chk=$(ps -ef |grep -v grep |grep -c mysql)
    local netstat_chk=$(netstat -lntp |grep -c mysqld)
    if [[ "${ps_chk}" != '0' ]] && [[ "${netstat_chk}" != '0' ]];then
    	# mysql runing
    	return 0
    else
    	# mysql not runing
    	return 1
    fi
    }
    ########################################################################################
    function chk_user_pass_sock(){
    local mysql_cmd=$(which mysql)
    
    
    if [[ "${Database}" != '' ]] ;then
    	local chk_d=1 # 设置变量为1
    else
    	local chk_d=0 # 没有设置为0
    fi
    if [[ "${User}" != '' ]] ;then
    	local chk_u=2
    else
    	local chk_u=0
    fi
    if [[ "${Password}" != '' ]] ;then
    	local chk_p=4
    else
    	local chk_p=0
    fi
    
    local last_chk=$(( chk_d + chk_u + chk_p ))
    
    if [[ ${last_chk} -eq 0 ]] || [[ ${last_chk} -eq 4 ]];then # not set all 
    	local chk_cmd=$("${mysql_cmd}" -S"${Mysql_sock}"  -e "show status like 'Uptime'" |grep -c 'Uptime' )
    	Command="${CMD} -S ${Mysql_sock} --backup ${Everyday_bak_dir}"
    elif [[ ${last_chk} -eq 1 ]] || [[ ${last_chk} -eq 5 ]];then  # set db
    	local chk_cmd=$("${mysql_cmd}" -S"${Mysql_sock}"  -e "show status like 'Uptime'" |grep -c 'Uptime' )
    	Command="${CMD} -S ${Mysql_sock} --databases="${Database}" --backup ${Everyday_bak_dir}"
    
    elif [[ ${last_chk} -eq 2 ]];then # set user
    	local chk_cmd=$("${mysql_cmd}" -S"${Mysql_sock}" -u"${User}" -e "show status like 'Uptime'" |grep -c 'Uptime' )
    	Command="${CMD} -S ${Mysql_sock} -u"${User}" --backup ${Everyday_bak_dir}"
    
    elif [[ ${last_chk} -eq 3 ]];then # set user db
    	local chk_cmd=$("${mysql_cmd}" -S"${Mysql_sock}" -u"${User}" -e "show status like 'Uptime'" |grep -c 'Uptime' )
    	Command="${CMD} -S ${Mysql_sock} -u"${User}" --databases="${Database}" --backup ${Everyday_bak_dir}"
    
    
    elif [[ ${last_chk} -eq 6 ]];then # set user pass 
    	local chk_cmd=$("${mysql_cmd}" -S"${Mysql_sock}" -u"${User}" -p"${Password}" -e "show status like 'Uptime'" |grep -c 'Uptime' )
    	Command="${CMD} -S ${Mysql_sock} -u"${User}" -p"${Password}" --backup ${Everyday_bak_dir}"
    
    elif [[ ${last_chk} -eq 7 ]];then # set all
    	local chk_cmd=$("${mysql_cmd}" -S"${Mysql_sock}" -u"${User}" -p"${Password}" -e "show status like 'Uptime'" |grep -c 'Uptime' )
    	#local chk_cmd=$("${mysql_cmd}" -S"${Mysql_sock}" -u"${User}" -p"${Password}" -e "show databases" |grep -c "${Database}" )
    	Command="${CMD} -S ${Mysql_sock} -u"${User}" -p"${Password}" --databases="${Database}" --backup ${Everyday_bak_dir}"
    
    else
    	echo "Check Error For Function chk_user_pass_sock"
    	exit 2
    fi
    if [[ "${chk_cmd}" == '1' ]] ;then
    	return 0
    else
    	return 1
    fi
    
    }
    
    
    ########################################################################################
    if [[ ${UID} -ne 0 ]];then
    
    	echo "Please Use Root Run This Scripts"
    	exit 1
    else
    
    
    ########################################################################################
    
    Today=$(date +%F)
    
    Everyday_bak_dir="${Backup_dir}/${Today}"
    
    if [[ ! -d "${Everyday_bak_dir}" ]];then
    	mkdir -p "${Everyday_bak_dir}"
    fi
    ########################################################################################
    CMD=$(which innobackupex)
    
    
    if chk_mysql_runing ;then
    	# mysql runing
    	if chk_user_pass_sock ;then
    		${Command}
    		echo "mysql backup is ok"
    	else
    		echo "ERROR , mysql backup is EROOR "
    	fi
    		
    else
    	# mysql not runing
    	echo "Please Start Mysql Services"
    fi
    
    ########################################################################################
    #Auto Crontab
    path_dir=$(cd "$(dirname "${0}")" && pwd)
    file=$(echo "$0"|awk -F '/' '{print $NF}')
    abs_file="${path_dir}/${file}"
    log_file="${abs_file}.log"
    
    if [[ $(grep -c "${abs_file}" /etc/crontab) -eq 0  ]] && [[ $UID -eq 0 ]]
    then
        echo "00 04 * * * ${USER} ${SHELL} ${abs_file} &>> ${log_file} ">> /etc/crontab
    fi
    ########################################################################################
    fi
