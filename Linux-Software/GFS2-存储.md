###一，GFS2简介
>GFS2 是一个基于 GFS的先进的集群文件系统，能够同步每台主机的集群文件系统的metadata，
能够进行文件锁的管理，并且必须要redhat cluster suite支持，GFS2可以grow，进行容量的调整；
不过这是在disk 动态容量调整的支持下，也就是本文所要实现的CLVM。
####实验环境：
    192.168.168.77 管理服务器 iscsi-target-server
    192.168.168.39 iscsi-initiator
    192.168.168.40 iscsi-initiator
    192.168.168.38 iscsi-initiator
####原理：
>node1,node2,node3分别通过ISCSI-initiator登录并挂载tgtd服务器的存储设备，
利用RHCS搭建GFS2高可用集群文件系统，且保证3个节点对存储设备能够同时读写访问。



###二，准备工作
>分别设置4台服务器的hosts文件，以便能够解析对应节点，设置管理节点到各集群节点的ssh密钥无密码登录,
关闭NetworkManager,设置开机不自动启动。

    192.168.168.77  storage
    192.168.168.39  node39
    192.168.168.40  node40
    192.168.168.38  node38

>建立storage 到 node节点的SSH KEY 互信,免密码登陆

>关闭 SElinux iptables NetworkManager

###集群安装
######RHCS的核心组件为cman和rgmanager，其中cman为基于openais的“集群基础架构层”，rgmanager为资源管理器。
######RHCS的集群中资源的配置需要修改其主配置文件/etc/cluster/cluster.xml实现，其仅安装在集群中的某一节点上即可，
######而cman和rgmanager需要分别安装在集群中的每个节点上。这里选择将此三个rpm包分别安装在了集群中的每个节点上
##### 挂载ISCSI磁盘就不写了
###为集群创建配置文件
######RHCS的配置文件/etc/cluster/cluster.conf，其在每个节点上都必须有一份，且内容均相同，其默认不存在，因此需要事先创建，ccs_tool命令可以完成此任务。
######另外，每个集群通过集群ID来标识自身，因此，在创建集群配置文件时需要为其选定一个集群名称，这里假设其为tcluster。此命令需要在集群中的某个节点上执行
#每个节点都必须操作:
    yum install cman rgmanager gfs2-utils lvm2-cluster -y
    ccs_tool create tcluster  # 名字随变取
    lvmconf --enable-cluster
    /etc/init.d/clvmd start && chkconfig clvmd on
###为集群添加节点
######RHCS集群需要配置好各节点及相关的fence设备后才能启动，因此，这里需要事先将各节点添加进集群配置文件。每个节点在添加进集群时，需要至少为其配置node id(每个节点的id必须惟一)，ccs_tool的addnode子命令可以完成节点添加。
######将前面规划的三个集群节点添加至集群中，可以使用如下命令实现。    ccs_tool addnode -n 1 node38
    ccs_tool addnode -n 2 node39
    ccs_tool addnode -n 3 node40
    # 查看cluster
    ccs_tool lsnode
    /etc/init.d/cmain start && chkconfig cmain on
    /etc/init.d/rgmanager start && chkconfig rgmanager on
    # 查看集群状态信息
    clustat

#单个节点操作:
###### 对ISCSI磁盘分区 名为/dev/sdb1
###三，配置使用cLVM(集群逻辑卷)
    pvcreate /dev/sdb1
    vgcreate vg_storage /dev/sdb1
    lvcreate -L 10G -n lv_storage1 vg_storage
    # 现在在每个node上都应该可以看到有个lv_storage1
###格式化
#####mkfs.gfs2为gfs2文件系统创建工具，其一般常用的选项有：

    -b BlockSize：指定文件系统块大小，最小为512，默认为4096；
    -J MegaBytes：指定gfs2日志区域大小，默认为128MB，最小值为8MB；
    -j Number：指定创建gfs2文件系统时所创建的日志区域个数，一般需要为每个挂载的客户端指定一个日志区域；
    -p LockProtoName：所使用的锁协议名称，通常为lock_dlm或lock_nolock之一；
    -t LockTableName：锁表名称，一般来说一个集群文件系统需一个锁表名以便让集群节点在施加文件锁时得悉其所关联到的集群文件系统，锁表名称为clustername:fsname，其中的clustername必须跟集群配置文件中的集群名称保持一致，因此，也仅有此集群内的节点可访问此集群文件系统；此外，同一个集群内，每个文件系统的名称必须惟一。

#####格式化完成后，重启node1,node2,node3,不然无法挂载刚才创建的GFS2分区
    mkfs.gfs2 -p lock_dlm -j 3 -t gcluster:storage /dev/vg_storage/lv_storage1

###每个节点操作:
    mkdir /data
    mount /dev/vg_storage/lv_storage1 /data
    echo "/dev/vg_storage/lv_storage1 /data  gfs2 defaults 0 0" >>/etc/fstab

#已完成

### 给GFS2 添加journal
    gfs2_jadd -j 1 /dev/vg_storage/lv_storage1
### LVM 扩容
    lvextend -L +2G /dev/vg_storage/lv_storage1
    gfs2_grow /dev/vg_storage/lv_storage1
