#shell

    #Auto Crontab
    path_dir=$(cd "$(dirname "${0}")" && pwd)
    file=$(echo "$0"|awk -F '/' '{print $NF}')
    abs_file="${path_dir}/${file}"
    log_file="${abs_file}.log"
    
    if [[ $(grep -c "${abs_file}" /etc/crontab) -eq 0  ]] && [[ $UID -eq 0 ]]
    then
        echo "59 23 * * * ${USER} ${SHELL} ${abs_file} &>> ${log_file} ">> /etc/crontab
    fi
