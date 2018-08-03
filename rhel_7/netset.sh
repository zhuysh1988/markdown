#!/bin/bash

IP=$1

set_start(){
local d='/etc/sysconfig/network-scripts/ifcfg-eno33554952'
sed -i '/UUID/d' $d
sed -i 's#dhcp#static#g' $d
sed -i 's#^ONBOOT.*$#ONBOOT=yes#g' $d
sed -i '/IPADDR/d' $d
sed -i '$aIPADDR=10.0.0.'"$IP"'' $d
sed -i '/NETMASK/d' $d
sed -i '$aNETMASK=255.255.255.0' $d
sed -i '/GETAWAY/d' $d
sed -i '$aGETAWAY=10.0.0.2' $d
sed -i '/^DNS.*/d' $d
sed -i '$aDNS1=10.0.0.10' $d
sed -i '$aDNS2=10.0.1.10' $d


local c='/etc/sysconfig/network-scripts/ifcfg-eno50332176'
sed -i '/UUID/d' $c
sed -i 's#dhcp#static#g' $c
sed -i 's#^ONBOOT.*$#ONBOOT=yes#g' $c
sed -i '/IPADDR/d' $c
sed -i '$aIPADDR=10.0.1.'"$IP"'' $c
sed -i '/NETMASK/d' $c
sed -i '$aNETMASK=255.255.255.0' $c

systemctl restart NetworkManager
}
if [[ $UID -eq 0 ]] && [[ $IP != '' ]] ;then

hostnamectl set-hostname "node${IP}.example.com"

#Array_devs=($(find /etc/sysconfig/network-scripts/ -type f -name "ifcfg-e*"|sort))

set_start


else
        echo "Error , Check You Command"
fi
