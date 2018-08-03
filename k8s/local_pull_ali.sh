#!/bin/bash -x
set -e

images_file='images_list.txt'
touch $images_file
anynowtime="`date +'%Y-%m-%d %H:%M:%S'`"
echo "$anynowtime" >> $images_file

red_echo ()      { echo -e "\033[031;1m$@\033[0m"; }
green_echo ()    { echo -e "\033[032;1m$@\033[0m"; }
yellow_echo ()   { echo -e "\033[033;1m$@\033[0m"; }
blue_echo ()     { echo -e "\033[034;1m$@\033[0m"; }
purple_echo ()   { echo -e "\033[035;1m$@\033[0m"; }
bred_echo ()     { echo -e "\033[041;1m$@\033[0m"; }
bgreen_echo ()   { echo -e "\033[042;1m$@\033[0m"; }
byellow_echo ()  { echo -e "\033[043;1m$@\033[0m"; }
bblue_echo ()    { echo -e "\033[044;1m$@\033[0m"; }
bpurple_echo ()  { echo -e "\033[045;1m$@\033[0m"; }
bgreen_echo ()   { echo -e "\033[042;34;1m$@\033[0m"; }


function login_aliyun(){
    purple_echo "Login You Aliyun"
    docker login --username=15315731537@qq.com  registry.cn-hangzhou.aliyuncs.com
}

Images_space=(
registry.cn-hangzhou.aliyuncs.com/jhr-k8s/rbd-provisioner
registry.cn-hangzhou.aliyuncs.com/k8s-app-image/redis-cluster
registry.cn-hangzhou.aliyuncs.com/k8s-app-image/etcd
registry.cn-hangzhou.aliyuncs.com/k8s-app-image/echoserver

registry.cn-hangzhou.aliyuncs.com/k8s-app-image/kubernetes-zookeeper
registry.cn-hangzhou.aliyuncs.com/jhr-k8s/nfs-client-provisioner
registry.cn-hangzhou.aliyuncs.com/jhr-k8s/defaultbackend
registry.cn-hangzhou.aliyuncs.com/jhr-k8s/nginx-ingress-controller

registry.cn-hangzhou.aliyuncs.com/jhr-calico/cni
registry.cn-hangzhou.aliyuncs.com/jhr-calico/ctl
registry.cn-hangzhou.aliyuncs.com/jhr-calico/kube-controllers
registry.cn-hangzhou.aliyuncs.com/jhr-calico/node

registry.cn-hangzhou.aliyuncs.com/jhr-flannel/flannel

registry.cn-hangzhou.aliyuncs.com/jhr-k8s/etcd-amd64

registry.cn-hangzhou.aliyuncs.com/jhr-k8s/heapster-amd64

registry.cn-hangzhou.aliyuncs.com/jhr-k8s/heapster-grafana-amd64

registry.cn-hangzhou.aliyuncs.com/jhr-k8s/heapster-influxdb-amd64

registry.cn-hangzhou.aliyuncs.com/jhr-k8s/k8s-dns-dnsmasq-nanny-amd64

registry.cn-hangzhou.aliyuncs.com/jhr-k8s/k8s-dns-kube-dns-amd64

registry.cn-hangzhou.aliyuncs.com/jhr-k8s/k8s-dns-sidecar-amd64

registry.cn-hangzhou.aliyuncs.com/jhr-k8s/kube-apiserver-amd64

registry.cn-hangzhou.aliyuncs.com/jhr-k8s/kube-controller-manager-amd64

registry.cn-hangzhou.aliyuncs.com/jhr-k8s/kube-proxy-amd64

registry.cn-hangzhou.aliyuncs.com/jhr-k8s/kube-scheduler-amd64

registry.cn-hangzhou.aliyuncs.com/jhr-k8s/kubernetes-dashboard-amd64

registry.cn-hangzhou.aliyuncs.com/jhr-k8s/pause-amd64

registry.cn-hangzhou.aliyuncs.com/jihongrui/mysql
registry.cn-hangzhou.aliyuncs.com/jihongrui/nginx
registry.cn-hangzhou.aliyuncs.com/jihongrui/tomcat
registry.cn-hangzhou.aliyuncs.com/jihongrui/busybox
)

function id_extis(){
    local _images_id=$1
    if docker images |grep -q "${_images_id}" ;then
        #green_echo "${_images_id} is extis"
        return 0
    else
        red_echo "${_images_id} not extis"
        return 1
    fi 
}

function get_name_by_id(){
    local _images_id=$1
    if id_extis "${_images_id}" ;then 
        local _images_tags=(
            $(docker images |grep "${_images_id}" |awk '{print $1":"$2}' )
            )
        echo "${_images_tags}"
    else
        red_echo "Error ${_images_tags} Not Find"
        exit 1
    fi 
}

function get_name(){
    local _images_name=$1
    echo $(echo ${_images_name##*/} |awk -F ':' '{print $1}')
}


function get_version(){
    local _images_name=$1
    echo $( echo $_images_name |awk -F ':' '{print $NF}')
}

function get_aliyun_name(){
    local _images_name=$1
    for _var_ in ${Images_space[@]};do 
        if [[ "${_var_##*/}" == "${_images_name}" ]];then 
            echo ${_var_}
            return 0
        fi
    done
}

function tag_push_images(){
    local _images_id=$1
    local _images_full_name=$(get_name_by_id "${_images_id}")
    #echo $_images_full_name
    local _images_s_name=$(get_name "${_images_full_name}")
    #echo $_images_s_name
    local _images_version=$(get_version "${_images_full_name}")
    #echo $_images_version
    local _aliyun_images_name=$(get_aliyun_name "${_images_s_name}")
    if [ -z "${_aliyun_images_name}" ];then
        red_echo "Error"
        exit 1
    fi 
    #echo $_aliyun_images_name
    local _aliyun_images="${_aliyun_images_name}:${_images_version}"
    red_echo ${_aliyun_images}
    echo ${_aliyun_images} >> $images_file
#    local _local_images="registry.example.com:5000/${_images_s_name}:${_images_version}"
#    red_echo ${_local_images}
#    echo ${_local_images} >> $images_file
    
#    docker tag "${_images_id}" "${_local_images}"
#    docker push "${_local_images}"
    docker tag "${_images_id}" "${_aliyun_images}"
    docker push "${_aliyun_images}"
}

login_aliyun

for i in $@;do 
tag_push_images $i 
done 