# 操作namespace的命令
``` bash
[root@localhost ~]# ip netns --help
Command "--help" is unknown, try "ip netns help".
[root@localhost ~]# ip netns help
Usage: ip netns list
       ip netns add NAME
       ip netns set NAME NETNSID
       ip [-all] netns delete [NAME]
       ip netns identify [PID]
       ip netns pids NAME
       ip [-all] netns exec [NAME] cmd ...
       ip netns monitor
       ip netns list-id

```
## 创建namespace
``` bash 
ip netns add ns-test
```


## 查看namespace
``` bash 
[root@localhost ~]# ip netns  list
ns-test

```
## 将tap设备tap-test 迁移至ns-test
``` bash 
ip link set tap-test netns ns-test

```
## 再次查看tab-test设备
``` bash 
[root@localhost ~]# ip link show tap-test
Device "tap-test" does not exist.

```
## 查看namespace中tap-test设备
``` bash 
[root@localhost ~]# ip netns exec ns-test  ip link show tap-test
7: tap-test: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT qlen 1000
    link/ether de:8f:56:8a:8a:8a brd ff:ff:ff:ff:ff:ff

```
## tap-test 在ns-test中绑定ip地址
``` bash 
ip netns exec ns-test ip addr add local 10.11.11.211/24 dev tap-test
```
## 启动 ns-test tap-test设备
``` bash 
ip netns exec ns-test  ip link set tap-test up
```

