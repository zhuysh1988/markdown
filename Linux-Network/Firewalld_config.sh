#!/bin/bash
set -e 

if [ $UID -ne 0 ];then 
    echo "Error, Use Root OR UID=0 user Run $0 "
    exit 1
fi 



function Check_Zone_Exist(){
# Check This Host Firewalld 
# Exist The Zone return 0
local _zone=$1
local _all_zone=$(firewall-cmd --get-zones)
for i in ${_all_zone};do 
    if [ $i == $_zone ];then 
        return 0
    fi 
done 
return 1
}

function Check_Interface_In_Zone(){
local _zone=$1
local _interface=$2
local _check_state=$(firewall-cmd --zone=${_zone} --query-interface=${_interface})
if [ ${_check_state} == 'yes' ];then 
    return 0
else 
    return 1
fi 
}


function Add_Interface_In_Zone(){
local _zone=$1
local _interface=$2
if ! Check_Interface_In_Zone ${_zone} ${_interface} ;then  
    firewall-cmd --zone=${_zone} --change-interface=${_interface}
fi 
}

function Check_Service_In_Zone(){
    local _zone=$1
    local _service=$2
    local _check_state=$(
        firewall-cmd --zone=${_zone} --query-service=${_service}
    )

        if [ "${_check_state}" == "yes" ];then 
            return 1
        else 
            return 0
        fi 
}



function Add_Services_In_Zone(){
local _zone=$1
local _services=${@:2}
        for _ser in ${_services};do
            if Check_Service_In_Zone ${_zone} ${_ser} ;then 
                firewall-cmd --zone=${_zone} --add-service=${_ser}
            fi 
        done
}




function Clean_Zone_Services(){
    local _zone=$1 
    local _all_services=(
        $(
        firewall-cmd --zone=${_zone}  --list-services
            )
        )
    if [ ${#_all_services[@]} -ne 0 ];then 
        for _services in ${_all_services[@]};do 
            firewall-cmd --zone=${_zone} --remove-service=${_services}
        done 
    fi 

}

function _echo(){
echo '---------------------------------------------------------------'
echo '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
echo "#############      $@      ##############"
echo '+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++'
echo '---------------------------------------------------------------'

}

function Use(){

_echo "Zones: block dmz drop external home internal public trusted work"
_echo "Use: $0 zone interface services"

}

function Check_Interface_Exist(){
local _interface=$1
local _check_state=$(ip link list |awk -F ':' '{print $2}'|grep -c "${_interface}")
if [ ${_check_state} -eq 1 ];then 
    return 0
else 
    _echo "ERROR : The Interface $_interface Not Exist"
    return 1
fi 
}

function Set_Zone(){
# add zone and set this zone to default
# add services to this zone
# Use: Set_Zone zone interface ssh icmp ftp
# target default DROP ACCEPT %%REJECT%%
if Check_Zone_Exist $1 ;then 
    local _zone=$1
else 
    _echo "ERROR: The Zone $1 Not Exist"
    exit 1
fi 
if Check_Interface_Exist $2 ;then 
    local _interface=$2
else 
    exit 1
fi 

    local _services=${@:3}

if [ $# -lt 2 ];then
    echo "Error, Set_Zone "
    exit 1
elif [ $# -eq 2 ];then 

    Add_Interface_In_Zone ${_zone} ${_interface} 
    Clean_Zone_Services ${_zone}

elif [ $# -ge 3 ];then 

    Add_Interface_In_Zone ${_zone} ${_interface} 
    Clean_Zone_Services ${_zone}
    Add_Services_In_Zone ${_zone} ${_services}

fi 

firewall-cmd --set-default-zone=${_zone}
firewall-cmd --reload
}



Set_Zone $@
