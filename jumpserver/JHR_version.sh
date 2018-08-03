#!/bin/bash
# coding: utf-8
# Copyright (c) 2018
# Gmail: liuzheng712
#

set -e

function Git_Clone(){
  _echo "git clone $1 In $2"
  ( cd $2 && git clone $1 ) || { 
    _echo "Git clone $1 Error" 
    exit 1
  }
}

function _echo(){
    echo "---------------------------------------------------------------------------------------"
    echo "++++++++++++++|||    $*   |||++++++++++++++++"
    echo "---------------------------------------------------------------------------------------"
}

function Download_OBJ(){
  _echo "Download $1 TO $2 "
  axel -n 10 -U "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/65.0.3325.162 Safari/537.36 Avast/65.0.411.162" \
      -o $2 $1 || {
  _echo "Download $1 Fied" 
  exit 1
      }
}

function Yum_Pip(){
  _echo "准备YUM 源和pip源"
{
mkdir -p ~/.pip
cat <<EOF > ~/.pip/pip.conf
[global]
index-url = https://mirrors.aliyun.com/pypi/simple/

[install]
trusted-host=mirrors.aliyun.com
EOF 

mkdir ~/yumbak
mv /etc/yum.repos.d/* ~/yumbak
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
yum clean all && yum makecache fast
} || {
    _echo "网络出错,请检查" && \
    exit 1
}
}


function Set_System(){
  _echo "0. 系统的一些配置"
setenforce 0 || true
systemctl stop iptables.service || true
systemctl stop firewalld.service || true

localedef -c -f UTF-8 -i zh_CN zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8
echo 'LANG=zh_CN.UTF-8' > /etc/locale.conf

}

function Install_Base_RPM(){
  _echo "1. 安装基本依赖"
{
yum install git axel yum-axelget  wget zip unzip epel-release nginx sqlite-devel xz gcc automake zlib-devel openssl-devel redis mariadb mariadb-devel mariadb-server supervisor -y
} || {
_echo "yum出错，请更换源重新运行" && \
exit 1
}

}

function Git_OBJ(){

Git_Clone https://github.com/jumpserver/jumpserver.git /opt 
Git_Clone https://github.com/jumpserver/coco.git /opt
Git_Clone https://github.com/jumpserver/luna.git /opt
}

