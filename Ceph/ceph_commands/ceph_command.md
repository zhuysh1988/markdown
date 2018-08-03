 # ceph常用命令
 

 

## 一：ceph集群启动、重启、停止
### 1：ceph 命令的选项如下：
> 选项简写描述

``` bash
--verbose-v详细的日志。
--valgrindN/A（只适合开发者和质检人员）用 Valgrind 调试。
--allhosts-a在 ceph.conf 里配置的所有主机上执行，否 则它只在本机执行。
--restartN/A核心转储后自动重启。
--norestartN/A核心转储后不自动重启。
--conf-c使用另外一个配置文件。
```
 



> Ceph 子命令包括：

``` bash
命令描述
start启动守护进程。
stop停止守护进程。
forcestop暴力停止守护进程，等价于 kill -9
killall杀死某一类守护进程。
cleanlogs清理掉日志目录。
cleanalllogs清理掉日志目录内的所有文件。
```
 



### 2：启动所有守护进程

> 要启动、关闭、重启 Ceph 集群，执行 ceph 时加上 相关命令，语法如下：
``` bash
/etc/init.d/ceph [options] [start|restart|stop] [daemonType|daemonID]
```




> 下面是个典型启动实例：
``` bash
sudo /etc/init.d/ceph -a start
# 加 -a （即在所有节点上执行）执行完成后Ceph本节点所有进程启动。
 
```


> 把 CEPH 当服务运行，按此语法：
``` bash
service ceph [options] [start|restart] [daemonType|daemonID]
典型实例：  service ceph -a start
```


### 3:启动单一实例

>要启动、关闭、重启一类守护进程  本例以要启动本节点上某一类的所有 Ceph 守护进程，
``` bash
/etc/init.d/ceph  [start|restart|stop] [daemonType|daemonID]
/etc/init.d/ceph start osd.0
```



> 把ceph当做服务运行，启动一节点上某个 Ceph 守护进程，
``` bash
按此语法： service ceph  start {daemon-type}.{instance}
service ceph  start osd.0
```

 

## 二、集群维护常用命令概览
 

### 1：检查集群健康状况
> 启动集群后、读写数据前，先检查下集群的健康状态。你可以用下面的命令检查：
``` bash
ceph health   或者 ceph health detail （输出信息更详细）
```



> 要观察集群内正发生的事件，打开一个新终端，然后输入：
``` bash
ceph -w
```
```
输出信息里包含：
集群唯一标识符
集群健康状况
监视器图元版本和监视器法定人数状态
OSD 版本和 OSD 状态摘要
其内存储的数据和对象数量的粗略统计，以及数据总量等。
```

> 例如：

``` bash
[root@admin-node ~]# ceph -w
    cluster 3561217d-a5b4-4f79-b38a-9e873eaeb018   #集群唯一标识符
     health HEALTH_OK      #集群健康状况
     monmap e3: 3 mons at {node1=10.1.1.2:6789/0,node2=10.1.1.3:6789/0,node3=10.1.1.4:6789/0}   #监视器图元版本和监视器法定人数状态
            election epoch 8, quorum 0,1,2 node1,node2,node3
     osdmap e24: 3 osds: 3 up, 3 in             #OSD 版本和 OSD 状态摘要
      pgmap v2395: 128 pgs, 7 pools, 860 bytes data, 44 objects
            19066 MB used, 42343 MB / 61410 MB avail
                 128 active+clean

2016-11-15 11:06:18.161961 mon.0 [INF] pgmap v2395: 128 pgs: 128 active+clean; 860 bytes data, 19066 MB used, 42343 MB / 61410 MB avail
```
 




> 新版本新增选项如下：
 

``` bash
 -s, --status          show cluster status
  -w, --watch           watch live cluster changes
  --watch-debug         watch debug events
  --watch-info          watch info events
  --watch-sec           watch security events
  --watch-warn          watch warn events
  --watch-error         watch error events
  --version, -v         display version
  --verbose             make verbose
  --concise             make less verbose
```
 



> 使用方法演示：
``` bash
ceph -w --watch-info
```


## 2：检查集群的使用情况

> 检查集群的数据用量及其在存储池内的分布情况，可以用 df 选项，它和 Linux 上的 df 相似。如下：
``` bash
ceph df
```


> 输出的 GLOBAL 段展示了数据所占用集群存储空间的概要。

```
SIZE: 集群的总容量；
AVAIL: 集群的空闲空间总量；
RAW USED: 已用存储空间总量；
% RAW USED: 已用存储空间比率。用此值参照 full ratio 和 near full \ ratio 来确保不会用尽集群空间。
详情见存储容量。
输出的 POOLS 段展示了存储池列表及各存储池的大致使用率。没有副本、克隆品和快照占用情况。例如，如果你把 1MB 的数据存储为对象，
理论使用率将是 1MB ，但考虑到副本数、克隆数、和快照数，实际使用率可能是 2MB 或更多。
NAME: 存储池名字；
ID: 存储池唯一标识符；
USED: 大概数据量，单位为 KB 、 MB 或 GB ；
%USED: 各存储池的大概使用率；
Objects: 各存储池内的大概对象数。
```
 




> 例如：

```
[root@admin-node ~]# ceph df
GLOBAL:
    SIZE       AVAIL      RAW USED     %RAW USED
    61410M     42342M       19067M         31.05
POOLS:
    NAME             ID     USED     %USED     MAX AVAIL     OBJECTS
    rbd              0         0         0        21171M           0
    .rgw.root        1       848         0        21171M           3
    .rgw.control     2         0         0        21171M           8
    .rgw             3         0         0        21171M           0
    .rgw.gc          4         0         0        21171M          32
    data             5        12         0        21171M           1
    .users.uid       6         0         0    
```
 


   
> 新版本新增ceph osd df  命令，可以详细列出集群每块磁盘的使用情况，包括大小、权重、使用多少空间、使用率等等
> 例如：


```
[root@admin-node ~]# ceph osd df
ID WEIGHT  REWEIGHT SIZE   USE    AVAIL  %USE  VAR  
 0 0.01999  1.00000 20470M  6356M 14113M 31.05 1.00
 1 0.01999  1.00000 20470M  6355M 14114M 31.05 1.00
 2 0.01999  1.00000 20470M  6356M 14113M 31.05 1.00
              TOTAL 61410M 19068M 42341M 31.05      
MIN/MAX VAR: 1.00/1.00  STDDEV: 0
```
 


### 3：检查集群状态
> 要检查集群的状态，执行下面的命令：:
``` bash
ceph status
```


> 例如：

``` bash
[root@admin-node ~]# ceph status
    cluster 3561217d-a5b4-4f79-b38a-9e873eaeb018
     health HEALTH_OK
     monmap e3: 3 mons at {node1=10.1.1.2:6789/0,node2=10.1.1.3:6789/0,node3=10.1.1.4:6789/0}
            election epoch 8, quorum 0,1,2 node1,node2,node3
     osdmap e24: 3 osds: 3 up, 3 in
      pgmap v2457: 128 pgs, 7 pools, 860 bytes data, 44 objects
            19068 MB used, 42341 MB / 61410 MB avail
                 128 active+clean
```
 

### 4：检查MONITOR状态
> 查看监视器图，执行下面的命令：:
``` bash
ceph mon stat
 ```

> 例如：

``` bash
[root@admin-node ~]# ceph mon stat
e3: 3 mons at {node1=10.1.1.2:6789/0,node2=10.1.1.3:6789/0,node3=10.1.1.4:6789/0}, election epoch 8, quorum 0,1,2 node1,node2,node3

或者：
ceph mon dump
例如：
[root@admin-node ~]# ceph mon dump
dumped monmap epoch 3
epoch 3
fsid 3561217d-a5b4-4f79-b38a-9e873eaeb018
last_changed 2016-11-14 10:52:00.887330
created 0.000000
0: 10.1.1.2:6789/0 mon.node1
1: 10.1.1.3:6789/0 mon.node2
2: 10.1.1.4:6789/0 mon.node3
```
 




> 要检查监视器的法定人数状态，执行下面的命令：
``` bash
ceph quorum_status
```



> 例如：

``` bash
[root@admin-node ~]# ceph quorum_status
{"election_epoch":8,"quorum":[0,1,2],"quorum_names":["node1","node2","node3"],"quorum_leader_name":"node1","monmap":{"epoch":3,"fsid":"3561217d-a5b4-4f79-b38a-9e873eaeb018","modified":"2016-11-14 10:52:00.887330","created":"0.000000","mons":[{"rank":0,"name":"node1","addr":"10.1.1.2:6789\/0"},{"rank":1,"name":"node2","addr":"10.1.1.3:6789\/0"},{"rank":2,"name":"node3","addr":"10.1.1.4:6789\/0"}]}}

```
 


5：检查 MDS 状态:

元数据服务器为 Ceph 文件系统提供元数据服务，元数据服务器有两种状态： up | \ down 和 active | inactive ，
执行下面的命令查看元数据服务器状态为 up 且 active ：

ceph mds stat

[root@admin-node ~]# ceph mds stat
e1: 0/0/0 up
 



要展示元数据集群的详细状态，执行下面的命令：

ceph mds dump
 



例如：

```
[root@admin-node ~]# ceph mds dump
dumped mdsmap epoch 1
epoch   1
flags   0
created 0.000000
modified        2016-11-13 15:45:29.289935
tableserver     0
root    0
session_timeout 0
session_autoclose       0
max_file_size   0
last_failure    0
last_failure_osd_epoch  0
compat  compat={},rocompat={},incompat={}
max_mds 0
in
up      {}
failed
stopped
data_pools
metadata_pool   0
inline_data     disabled
```
 




6、删除一个节点的所有的ceph数据包

[root@node1 ~]# ceph-deploy purge node1
[root@node1 ~]# ceph-deploy purgedata node1
 





7、为ceph创建一个admin用户并为admin用户创建一个密钥，把密钥保存到/etc/ceph目录下：

ceph auth get-or-create client.admin mds 'allow' osd 'allow *' mon 'allow *' > /etc/ceph/ceph.client.admin.keyring
或
ceph auth get-or-create client.admin mds 'allow' osd 'allow *' mon 'allow *' -o /etc/ceph/ceph.client.admin.keyring
 





8、为osd.0创建一个用户并创建一个key

ceph auth get-or-create osd.0 mon 'allow rwx' osd 'allow *' -o /var/lib/ceph/osd/ceph-0/keyring
 





9、为mds.node1创建一个用户并创建一个key

ceph auth get-or-create mds.node1 mon 'allow rwx' osd 'allow *' mds 'allow *' -o /var/lib/ceph/mds/ceph-node1/keyring
 





10、查看ceph集群中的认证用户及相关的key

ceph auth list
 




11、删除集群中的一个认证用户

ceph auth del osd.0
 




12、查看集群的详细配置

[root@node1 ~]# ceph daemon mon.node1 config show | more
 





13、查看集群健康状态细节

```
[root@admin ~]# ceph health detail
HEALTH_WARN 12 pgs down; 12 pgs peering; 12 pgs stuck inactive; 12 pgs stuck unclean
pg 3.3b is stuck inactive since forever, current state down+peering, last acting [1,2]
pg 3.36 is stuck inactive since forever, current state down+peering, last acting [1,2]
pg 3.79 is stuck inactive since forever, current state down+peering, last acting [1,0]
pg 3.5 is stuck inactive since forever, current state down+peering, last acting [1,2]
pg 3.30 is stuck inactive since forever, current state down+peering, last acting [1,2]
pg 3.1a is stuck inactive since forever, current state down+peering, last acting [1,0]
pg 3.2d is stuck inactive since forever, current state down+peering, last acting [1,0]
pg 3.16 is stuck inactive since forever, current state down+peering, last acting [1,2]
```
 



14、查看ceph log日志所在的目录

[root@node1 ~]# ceph-conf --name mon.node1 --show-config-value log_file
/var/log/ceph/ceph-mon.node1.log