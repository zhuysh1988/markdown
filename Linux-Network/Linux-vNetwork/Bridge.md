# Linux-虚拟网络设备-LinuxBridge 

## 基本概念
``` bash 

       bridge是一个虚拟网络设备，具有网络设备的特性（可以配置IP、MAC地址等）；而且bridge还是一个虚拟交换机，和物理交换机设备功能类似。网桥是一种在链路层实现中继，对帧进行转发的技术，根据MAC分区块，可隔离碰撞，将网络的多个网段在数据链路层连接起来的网络设备。 
       对于普通的物理设备来说，只有两端，从一段进来的数据会从另一端出去，比如物理网卡从外面网络中收到的数据会转发到内核协议栈中，而从协议栈过来的数据会转发到外面的物理网络中。而bridge不同，bridge有多个端口，数据可以从任何端口进来，进来之后从哪个口出去原理与物理交换机类似，需要看mac地址。 
       bridge是建立在从设备上（物理设备、虚拟设备、vlan设备等，即attach一个从设备，类似于现实世界中的交换机和一个用户终端之间连接了一根网线），并且可以为bridge配置一个IP（参考LinuxBridge MAC地址行为），这样该主机就可以通过这个bridge设备与网络中的其他主机进行通信了。另外它的从设备被虚拟化为端口port，它们的IP及MAC都不在可用，且它们被设置为接受任何包，最终由bridge设备来决定数据包的去向：接收到本机、转发、丢弃、广播。

```

## 作用
``` bash 

       bridge是用于连接两个不同网段的常见手段，不同网络段通过bridge连接后就如同在一个网段一样，工作原理很简单就是L2数据链路层进行数据包的转发。

```

## brctl 命令
* 检测和安装brctl 
``` bash 
[root@localhost ~]# brctl --help
-bash: brctl: command not found
[root@localhost ~]# rpm -qa |grep bridge
[root@localhost ~]# yum install bridge-utils -y

```
* brctl help
``` bash 
[root@localhost ~]# brctl --help
Usage: brctl [commands]
commands:
	addbr     	<bridge>		add bridge
	delbr     	<bridge>		delete bridge
	addif     	<bridge> <device>	add interface to bridge
	delif     	<bridge> <device>	delete interface from bridge
	hairpin   	<bridge> <port> {on|off}	turn hairpin on/off
	setageing 	<bridge> <time>		set ageing time
	setbridgeprio	<bridge> <prio>		set bridge priority
	setfd     	<bridge> <time>		set bridge forward delay
	sethello  	<bridge> <time>		set hello time
	setmaxage 	<bridge> <time>		set max message age
	setpathcost	<bridge> <port> <cost>	set path cost
	setportprio	<bridge> <port> <prio>	set port priority
	show      	[ <bridge> ]		show a list of bridges
	showmacs  	<bridge>		show a list of mac addrs
	showstp   	<bridge>		show bridge stp info
	stp       	<bridge> {on|off}	turn stp on/off


```

# Example: br veth peer 

## Create veth peer
``` bash 

for i in {1..4};do 
ip link add tap$i type veth peer name ptap$i
done

```

## Create namespace
``` bash 

for i in {1..4};do 
ip netns add ns$i
done

```

## set tap in namespace
``` bash 
for i in {1..4};do 
ip link set tap$i netns ns$i
done
```

## Create bridge
``` bash 
[root@localhost ~]# brctl addbr br-aux
[root@localhost ~]# brctl show
bridge name	bridge id		STP enabled	interfaces
br-aux		8000.000000000000	no	

```

## Move tap in bridge br-aux
``` bash 
for i in {1..4};do 
brctl addif br-aux ptap$i
done


# ADD local net dev ens32 10.9.9.0/24
brctl addif br-aux ens32

[root@localhost ~]# brctl show 
bridge name	bridge id		STP enabled	interfaces
br-aux		8000.000c29a267b9	no		ens32
							ptap1
							ptap2
							ptap3
							ptap4
[root@localhost ~]# 



```

## Configure IP in tap
``` bash 
for i in {1..4};do 
ip netns exec ns$i ip addr add local 10.9.9.9${i}/24 dev tap$i
done

```

## Up for br-aux tap dev
``` bash 
ip link set br-aux up

for i in {1..4};do 
ip link set ptap$i up ;
ip netns exec ns$i ip link set tap$i up ;
done

```
# Ping Testing 
## 
``` bash 
[root@localhost ~]# ip netns exec ns1 ping -c 1 10.9.9.92
PING 10.9.9.92 (10.9.9.92) 56(84) bytes of data.
64 bytes from 10.9.9.92: icmp_seq=1 ttl=64 time=0.159 ms

--- 10.9.9.92 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.159/0.159/0.159/0.000 ms
[root@localhost ~]# ip netns exec ns2 ping -c 1 10.9.9.91
PING 10.9.9.91 (10.9.9.91) 56(84) bytes of data.
64 bytes from 10.9.9.91: icmp_seq=1 ttl=64 time=0.035 ms

--- 10.9.9.91 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 0.035/0.035/0.035/0.000 ms
[root@localhost ~]# ip netns exec ns2 curl http://10.9.9.1/
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
 <head>
  <title>Index of /</title>
 </head>
 <body>
<h1>Index of /</h1>
<ul><li><a href="centos/"> centos/</a></li>
<li><a href="centos7/"> centos7/</a></li>
<li><a href="epel/"> epel/</a></li>
<li><a href="ocp36/"> ocp36/</a></li>
<li><a href="ocp37/"> ocp37/</a></li>
<li><a href="openstack_for_redhat_o/"> openstack_for_redhat_o/</a></li>
<li><a href="repo_file/"> repo_file/</a></li>
<li><a href="rhceph-2/"> rhceph-2/</a></li>
<li><a href="rhel7.3-server-extra-ha/"> rhel7.3-server-extra-ha/</a></li>
<li><a href="rhel7.4-server-extra-ha/"> rhel7.4-server-extra-ha/</a></li>
<li><a href="rhopenstack-10-N/"> rhopenstack-10-N/</a></li>
<li><a href="rhopenstack-11-O/"> rhopenstack-11-O/</a></li>
<li><a href="ubuntu/"> ubuntu/</a></li>
</ul>
</body></html>


```

