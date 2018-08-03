# veth pair
```
veth设备特点
veth和其它的网络设备都一样，一端连接的是内核协议栈
veth设备是成对出现的，另一端两个设备彼此相连
一个设备收到协议栈的数据发送请求后，会将数据发送到另一个设备上去
```

## 创建 veth peer 设备、ns1/2 
``` bash 
[root@localhost ~]# ip link add tap1 type veth peer name tap2

[root@localhost ~]# ip netns add ns1
[root@localhost ~]# ip netns add ns2
[root@localhost ~]# ip netns list
ns2
ns1
[root@localhost ~]# ip link set tap1 netns ns1
[root@localhost ~]# ip link set tap2 netns ns2
```
## 设置IP 并 启动设备
``` bash 
[root@localhost ~]# ip netns exec ns1 ip addr add local 192.168.168.1/24 dev tap1
[root@localhost ~]# ip netns exec ns2 ip addr add local 192.168.168.2/24 dev tap2
[root@localhost ~]# ip netns exec ns1 ip link set tap1 up
[root@localhost ~]# ip netns exec ns2 ip link set tap2 up

```
## 查看ns1 / ns2 IP
``` bash 
[root@localhost ~]# ip netns exec ns1 ip a
1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
10: tap1@if9: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP qlen 1000
    link/ether aa:c6:63:de:45:8a brd ff:ff:ff:ff:ff:ff link-netnsid 1
    inet 192.168.168.1/24 scope global tap1
       valid_lft forever preferred_lft forever
    inet6 fe80::a8c6:63ff:fede:458a/64 scope link 
       valid_lft forever preferred_lft forever
[root@localhost ~]# ip netns exec ns2 ip a
1: lo: <LOOPBACK> mtu 65536 qdisc noop state DOWN qlen 1
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
9: tap2@if10: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP qlen 1000
    link/ether e6:d2:70:22:77:b6 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 192.168.168.2/24 scope global tap2
       valid_lft forever preferred_lft forever
    inet6 fe80::e4d2:70ff:fe22:77b6/64 scope link 
       valid_lft forever preferred_lft forever

```
## ping 测试
``` bash 
[root@localhost ~]# ip netns exec ns1 ping 192.168.168.2
PING 192.168.168.2 (192.168.168.2) 56(84) bytes of data.
64 bytes from 192.168.168.2: icmp_seq=1 ttl=64 time=0.042 ms
64 bytes from 192.168.168.2: icmp_seq=2 ttl=64 time=0.038 ms
^C
--- 192.168.168.2 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1000ms
rtt min/avg/max/mdev = 0.038/0.040/0.042/0.002 ms
[root@localhost ~]# ip netns exec ns2 ping 192.168.168.1
PING 192.168.168.1 (192.168.168.1) 56(84) bytes of data.
64 bytes from 192.168.168.1: icmp_seq=1 ttl=64 time=0.026 ms
64 bytes from 192.168.168.1: icmp_seq=2 ttl=64 time=0.036 ms
64 bytes from 192.168.168.1: icmp_seq=3 ttl=64 time=0.037 ms
^C
--- 192.168.168.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 1998ms
rtt min/avg/max/mdev = 0.026/0.033/0.037/0.005 ms

```