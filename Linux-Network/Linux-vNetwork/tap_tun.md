# tap/tun 使用
``` bash
[root@localhost ~]# tunctl help
Create: tunctl [-b] [-u owner] [-g group] [-t device-name] [-p|-n] [-f tun-clone-device]
Delete: tunctl -d device-name [-f tun-clone-device]

The default tun clone device is /dev/net/tun - some systems use
/dev/misc/net/tun instead

-b will result in brief output (just the device name)
-n will result in a point-to-point tun device,
-p in an ethernet tap device. Default is a tap,
   except the device contains "tun" in the name.

```

## 检测 fun模块
* 如果有如下输出，说明系统已安装tun模块
``` bash 
[root@localhost ~]# modinfo tun
filename:       /lib/modules/3.10.0-693.el7.x86_64/kernel/drivers/net/tun.ko.xz
alias:          devname:net/tun
alias:          char-major-10-200
license:        GPL
author:         (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
description:    Universal TUN/TAP device driver
rhelversion:    7.4
srcversion:     4E9F57A6269CFD0F4BE4021
depends:        
intree:         Y
vermagic:       3.10.0-693.el7.x86_64 SMP mod_unload modversions 
signer:         Red Hat Enterprise Linux kernel signing key
sig_key:        4F:FD:D6:3C:93:7E:B4:A7:A1:14:BC:5E:89:1A:CB:DE:50:20:65:21
sig_hashalgo:   sha256

```
## 检测是否已加载tun模块
* 没有加载会输出
``` bash 
[root@localhost ~]# lsmod |grep tun
[root@localhost ~]# 

```
* 加载tun模块
``` bash 
[root@localhost ~]# modprobe tun
[root@localhost ~]# lsmod |grep tun
tun                    31621  0 
```
## 检测是否有tunctl 命令
``` bash 
[root@localhost ~]# tunctl
-bash: tunctl: command not found
[root@localhost ~]# 

```
* 安装tunctl 
* Create the repository config file /etc/yum.repos.d/nux-misc.repo
``` bash

[nux-misc]  
name=Nux Misc  
baseurl=http://li.nux.ro/download/nux/misc/el7/x86_64/  
enabled=0  
gpgcheck=1  
gpgkey=http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro  
```

* Install tunctl rpm package
```
yum --enablerepo=nux-misc install tunctl  
```

## 创建tap设备
``` bash 
[root@localhost ~]# tunctl -t tap-test
Set 'tap-test' persistent and owned by uid 0
```
## 查看创建的tap设备
``` bash 
[root@localhost ~]# ip link list
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: ens32: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast state DOWN mode DEFAULT qlen 1000
    link/ether 00:0c:29:a2:67:b9 brd ff:ff:ff:ff:ff:ff
3: ens33: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast state DOWN mode DEFAULT qlen 1000
    link/ether 00:0c:29:a2:67:c3 brd ff:ff:ff:ff:ff:ff
4: ens34: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT qlen 1000
    link/ether 00:0c:29:a2:67:cd brd ff:ff:ff:ff:ff:ff
5: tap0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT qlen 1000
    link/ether ca:b0:bf:f7:5f:f7 brd ff:ff:ff:ff:ff:ff
6: tap1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT qlen 1000
    link/ether 62:73:82:3d:c7:28 brd ff:ff:ff:ff:ff:ff
7: tap-test: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT qlen 1000
    link/ether de:8f:56:8a:8a:8a brd ff:ff:ff:ff:ff:ff

```
## 删除tap设备
``` bash 
[root@localhost ~]# tunctl -d tap0
Set 'tap0' nonpersistent
[root@localhost ~]# tunctl -d tap1
Set 'tap1' nonpersistent
[root@localhost ~]# ip link list
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: ens32: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast state DOWN mode DEFAULT qlen 1000
    link/ether 00:0c:29:a2:67:b9 brd ff:ff:ff:ff:ff:ff
3: ens33: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc pfifo_fast state DOWN mode DEFAULT qlen 1000
    link/ether 00:0c:29:a2:67:c3 brd ff:ff:ff:ff:ff:ff
4: ens34: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT qlen 1000
    link/ether 00:0c:29:a2:67:cd brd ff:ff:ff:ff:ff:ff
7: tap-test: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT qlen 1000
    link/ether de:8f:56:8a:8a:8a brd ff:ff:ff:ff:ff:ff

```
## 给tap-test 设置IP

``` bash 
ip addr add local 10.11.11.221/24 dev tap-test

```
## 查看tap-test IP地址
``` bash 
[root@localhost ~]# ip addr show tap-test
7: tap-test: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN qlen 1000
    link/ether de:8f:56:8a:8a:8a brd ff:ff:ff:ff:ff:ff
    inet 10.11.11.221/24 scope global tap-test
       valid_lft forever preferred_lft forever

```


## ping 测试
``` bash 
[root@localhost ~]# ping 10.11.11.221
PING 10.11.11.221 (10.11.11.221) 56(84) bytes of data.
64 bytes from 10.11.11.221: icmp_seq=1 ttl=64 time=0.146 ms
64 bytes from 10.11.11.221: icmp_seq=2 ttl=64 time=0.062 ms
64 bytes from 10.11.11.221: icmp_seq=3 ttl=64 time=0.052 ms
^C
--- 10.11.11.221 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2000ms
rtt min/avg/max/mdev = 0.052/0.086/0.146/0.043 ms

```

