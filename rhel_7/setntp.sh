#!/bin/bash


set_server(){
# NTP 设置
## NTP Server
yum install chrony -y
sed -i '10aallow 0.0.0.0/0' /etc/chrony.conf
systemctl enable chronyd && systemctl restart chronyd
}
set_client(){
## NTP Client
yum install chrony -y && sed -i '/^server/d' /etc/chrony.conf
sed -i '1aserver ntp.example.com iburst' /etc/chrony.conf
systemctl enable chronyd && systemctl restart chronyd
}

case $1 in
   0 | server)
        set_server
   ;;
   1 | clent)
        set_client
   ;;
   *)
   echo "0=server ; 1=clent"
   ;;
esac
