# 使用Linux 做为Route

## 开启 路由转发功能

* 临时生效
``` bash
[root@localhost ~]# echo 1 > /proc/sys/net/ipv4/ip_forward
[root@localhost ~]# cat /proc/sys/net/ipv4/ip_forward
1

```

* 长期生效
``` bash 
 sed -i '3anet.ipv4.ip_forward=1' /etc/sysctl.conf
 sysctl -p
```

* 查看
``` bash 
[root@localhost ~]# cat /proc/sys/net/ipv4/ip_forward
1
```

## Create veth pair namespace  AND set IP 
``` bash 
for i in 1 2 ;do 
ip link add tap$i type veth peer name ptap$i && \
ip netns add ns$i && \
ip link set tap$i netns ns$i && \
ip addr add local 192.168.${i}.1/24 dev ptap$i && \
ip netns exec ns$i ip addr add local 192.168.${i}.2/24 dev tap$i && \
ip link set ptap$i up && \
ip netns exec ns$i ip link set tap$i up;
done

```



## Add namespace route path
``` bash 
[root@localhost ~]# ip netns exec ns1 route add -net 192.168.2.0 netmask 255.255.255.0 gw 192.168.1.1
[root@localhost ~]# ip netns exec ns1 route -nee
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface    MSS   Window irtt
192.168.1.0     0.0.0.0         255.255.255.0   U     0      0        0 tap1     0     0      0
192.168.2.0     192.168.1.1     255.255.255.0   UG    0      0        0 tap1     0     0      0
[root@localhost ~]# ip netns exec ns2 route add -net 192.168.1.0 netmask 255.255.255.0 gw 192.168.2.1
[root@localhost ~]# ip netns exec ns2 route -nee
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface    MSS   Window irtt
192.168.1.0     192.168.2.1     255.255.255.0   UG    0      0        0 tap2     0     0      0
192.168.2.0     0.0.0.0         255.255.255.0   U     0      0        0 tap2     0     0      0


```

## Testing Net Ping
``` bash 
[root@localhost ~]# ip netns exec ns1 ping 192.168.2.2
PING 192.168.2.2 (192.168.2.2) 56(84) bytes of data.
64 bytes from 192.168.2.2: icmp_seq=1 ttl=63 time=0.090 ms
64 bytes from 192.168.2.2: icmp_seq=2 ttl=63 time=0.047 ms
^C
--- 192.168.2.2 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 999ms
rtt min/avg/max/mdev = 0.047/0.068/0.090/0.023 ms
[root@localhost ~]# ip netns exec ns2 ping 192.168.1.2
PING 192.168.1.2 (192.168.1.2) 56(84) bytes of data.
64 bytes from 192.168.1.2: icmp_seq=1 ttl=63 time=0.035 ms
64 bytes from 192.168.1.2: icmp_seq=2 ttl=63 time=0.044 ms
^C
--- 192.168.1.2 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 999ms
rtt min/avg/max/mdev = 0.035/0.039/0.044/0.007 ms


```