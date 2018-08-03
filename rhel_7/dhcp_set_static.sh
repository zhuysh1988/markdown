#!/bin/bash
set -e

DBUG="/root/${0}.log"
touch ${DBUG}

function dbug() {
	local msg=$1
	local level=$2
	if [[ ${level} == '' ]];then
		echo ${msg}
	fi

	echo "$(date +%F) $(date +%R) $(hostname) ${msg}" >> ${DBUG}
}


function get_dev_ip_mask(){
	local dev=$1
	local ip_msg=$(ip add show ${dev} |grep -o 'inet\ .*\/.*\ brd'|awk '{print $2}'|awk -F '/' '{print $1,$2}')
	dbug "${ip_msg}" 'd'
	if [[ ${ip_msg} != '' ]];then
		dbug "${ip_msg}"
	else
		dbug "function: get_dev_ip_mask Get ip and mask Error"
		ip_mag='False'
		dbug "${ip_msg}"
	fi
}


devs=($(ip link list|grep -E -v 'lo|loopback'|grep -o ':\ e.*:'|awk -F ':' '{print $2}'))
devs_number=${#devs[@]}

declare -a all_dev
for dev in ${devs[@]};do
	ipmask="${dev} $(get_dev_ip_mask ${dev})"
	all_dev[]=${ipmask}
#	ip=${ipmask%\ *}
#	prefix=${ipmask#*\ }
#PREFIX=24
done

default_domain=($(grep 'search' /etc/resolv.conf |awk '{print $2}'))
dns_servers=($(grep 'nameserver' /etc/resolv.conf |awk '{print $2}'))

echo ${all_dev[*]}
