>LVM是逻辑盘卷管理（Logical VolumManager）的简称，它是Linux环境下对磁盘分区进行管理的一种机制，
>LVM是建立在硬盘和分区之上的一个逻辑层，来提高磁盘分LVM区管理的灵活性。
>前面谈到，LVM是在磁盘分区和文件系统之间添加的一个逻辑层，来为文件系统屏蔽下层磁盘分区布局，
>提供一个抽象的盘卷，在盘卷上建立文件系统。物理卷（physical volume）物理卷就是指硬盘分区或从逻辑上与磁盘分区具有同样功能的设备（如RAID），
>是LVM的基本存储逻辑块，但和基本的物理存储介质（如分区、磁盘等）比较，却包含有与LVM相关的管理参数。

###创建一个LVM一般经过以下几个步骤；
######1.创建LVM分区类型：方法和创建其他一般分区的方式是一样的，区别仅仅是LVM的分区类型为8e。
######    创建完分区以后用t修改分区类型为8e
######2.创建一个逻辑卷需要经过以下几个步骤；
######    创建物理卷(PV)-->创建卷组(VG)-->创建卷组(LV)
######3.创建物理卷
######    创建物理卷的命令为pvcreate，利用该命令将希望添加到卷组的所有分区或者磁盘创建为物理卷
###用法：
    pvcreate  /dev/sdb1（将单个分区创建为物理卷）
    pvdisplay /dev/sdb1  （查看创建的物理卷的详细信息）pvs 也可以查看；



    [root@station55 ~]# pvcreate /dev/sd{b,c}1
    Physical volume "/dev/sdb1" successfully created
    Physical volume "/dev/sdc1" successfully created
>(上面的意思就是把我分区的sdb1和sdc1创建为物理卷)





    [root@station55 ~]# pvs
    PV         VG   Fmt  Attr PSize  PFree
    /dev/sda2  vg0  lvm2 a--  59.99g  7.99g
    /dev/sdb1  myvg lvm2 a--  10.00g 10.00g
    /dev/sdc1  myvg lvm2 a--  10.00g 10.00g
>（查看刚创建的物理卷的简要信息）
###4 创建卷组
>创建卷组的命令为vgcreate

    vgcreate VGNAME /dev/sdb1 vgcreate命令第一个参数是指定该卷组的逻辑名，后面参数是指定希望添加到该卷组的所有分区和磁盘，PE大小决定了逻辑卷的最大大小，
    4MB的PE决定了单个逻辑卷最大容量为256GB，若希望使用大于256G的逻辑卷则创建卷组 时指定更大的PE。
    PE大小范围为8KB到512MB，并且必须总是2的倍数（使用-s指定)。
    vgdisplay  查看卷组的信息；vgs也可以查看；


    [root@station55 ~]# vgcreate myvg /dev/sd{b,c}1
    Volume group "myvg" successfully created
>（创建卷组myvg，把物理卷的sd{b,c}1加进来）
    
    [root@station55 ~]# vgs
    VG   #PV #LV #SN Attr   VSize  VFree
    myvg   2   0   0 wz--n- 20.00g 20.00g
    vg0    1   4   0 wz--n- 59.99g  7.99g
>（查看刚创建的卷组的简要信息）
###5.创建逻辑卷
>创建逻辑卷的命令；

    lvcreate -L SIZE -n LV_NAME VG_NAME
    lvdisplay 查看创建的详细信息 vgs也可以查看；
    [root@station55 ~]# lvcreate -L 10G -n mylv  myvg
    Logical volume "mylv" created
>（创建的大小为10G 逻辑卷名字mylv，从myvg中添加）

    [root@station55 ~]# lvs
    LV   VG   Attr      LSize  Pool Origin Data%  Move Log Cpy%Sync Convert
    mylv myvg -wi-a---- 10.00g
    root vg0  -wi-ao--- 20.00g
    swap vg0  -wi-ao---  2.00g
    usr  vg0  -wi-ao--- 10.00g
    var  vg0  -wi-ao--- 20.00g
     （查看刚创建的逻辑卷的简要信息）
    创建好的LVM 的路径保存在：
    /dev/VG_NAME/LV_NAME
    /dev/mapper/VG_NAME-LV_NAME
    /dev/mapper/testvg-mylv
>
    [root@station55 ~]# lvdisplay /dev/myvg/mylv
    --- Logical volume ---
    LV Path                /dev/myvg/mylv
    LV Name                mylv
    VG Name                myvg
    LV UUID                Yu0Ja1-uL3H-APbU-KFjj-Bmql-VwA9-FhBItY
    LV Write Access        read/write
    LV Creation host, time station55.magelinux.com, 2013-07-15 08:39:00 +0800
    LV Status              available
    # open                 0
    LV Size                10.00 GiB
    Current LE             2560
    Segments               1
    Allocation             inherit
    Read ahead sectors     auto
    - currently set to     256
    Block device           253:4
>（查看创建的逻辑卷存放路径的详细信息）
###6.创建文件系统
    mke2fs -t  ext4    后面跟创建的LV的路径。 
    [root@station55 ~]# mke2fs -t ext4 /dev/myvg/mylv
    mke2fs 1.41.12 (17-May-2010)
    Filesystem label=
    OS type: Linux
    Block size=4096 (log=2)
    Fragment size=4096 (log=2)
>(格式化成功)
>创建了文件系统以后，就可以加载并使用它：

    mount  逻辑卷路径   挂载点 
    [root@station55 ~]# mount /dev/myvg/mylv /mnt/
>如果希望系统启动时自动加载文件系统，则还需要在/etc/fstab中添加内容
###7.扩展VG
>首先准备好一个PV；

    [root@station55 ~]# pvcreate /dev/sdc2
    Physical volume "/dev/sdc2" successfully created
    使用vgextend命令即可完成扩展；
    vgextend VG_NAME /PATH/TO/PV 
    [root@station55 ~]# vgextend myvg /dev/sdc2
    Volume group "myvg" successfully extended
###8.缩减VG
    确定要移除的PV；
    将此PV上的数据转移至其它PV；
    [root@station55 ~]# pvmove /dev/sdb1
    /dev/sdb1: Moved: 0.3%
    /dev/sdb1: Moved: 64.6%
    /dev/sdb1: Moved: 100.0%
    （转移sdb1的数据到别的磁盘上）
    从卷组中将此PV移除；
    [root@station55 ~]# vgreduce myvg  /dev/sdb1
    Removed "/dev/sdb1" from volume group "myvg"
###9.扩展逻辑卷
 确定扩展多大？
 确定当前逻辑卷所在的卷组有足够的空闲空间；
 扩展：
>1.1物理边界

    lvextend -L [+]SIZE /path/to/lv
    [root@station55 ~]# lvextend -L +3G /dev/myvg/mylv
    Extending logical volume mylv to 13.00 GiB
    Logical volume mylv successfully resized
    （给逻辑卷加3个G）
>1.2逻辑边界

     resize2fs /path/to/lv
    [root@station55 ~]# resize2fs /dev/myvg/mylv
    resize2fs 1.41.12 (17-May-2010)
    Filesystem at /dev/myvg/mylv is mounted on /mnt; on-line resizing required
    old desc_blocks = 1, new_desc_blocks = 1
    Performing an on-line resize of /dev/myvg/mylv to 3407872 (4k) blocks.
    The filesystem on /dev/myvg/mylv is now 3407872 blocks long.
>文件系统检测：

     e2fsck   /path/to/device
    [root@station55 ~]# e2fsck /dev/myvg/mylv
    e2fsck 1.41.12 (17-May-2010)
    /dev/myvg/mylv: clean, 11/851968 files, 92640/3407872 blocks
>意思就是坚持没有问题 clean）
###10.缩减逻辑卷
 确定缩减为多大？前提是：至少能容纳原有的所有数据。
 缩减：
 
>1、卸载并强行检测文件系统；

    e2fsck -f 路径
    [root@station55 ~]# e2fsck -f /dev/myvg/mylv
    e2fsck 1.41.12 (17-May-2010)
    Pass 1: Checking inodes, blocks, and sizes
    Pass 2: Checking directory structure
    Pass 3: Checking directory connectivity
    Pass 4: Checking reference counts
    Pass 5: Checking group summary information
    /dev/myvg/mylv: 11/851968 files (0.0% non-contiguous), 92640/3407872 blocks
>2、逻辑边界

    resize2fs /path/to/device SIZE
    [root@station55 ~]# resize2fs /dev/myvg/mylv 10G
    resize2fs 1.41.12 (17-May-2010)
    The filesystem is already 2621440 blocks long.  Nothing to do!
    （提示已经缩减至10G）
>3、物理边界

       lvreduce -L [-]SIZE /path/to/lv
    [root@station55 ~]# lvreduce -L -3G /dev/myvg/mylv
    WARNING: Reducing active logical volume to 10.00 GiB
    THIS MAY DESTROY YOUR DATA (filesystem etc.)
    Do you really want to reduce mylv? [y/n]: y
    Reducing logical volume mylv to 10.00 GiB
    Logical volume mylv successfully resized
    （警告缩减有风险，输入y提示缩减成功）
###11.快照卷创建：
     生命周期为整个数据时长；在这段时长内，数据的增长量不能超出快照卷大小；
     快照卷应该是只读的；
     跟原卷在同一卷组内；
     lvcreate 
      -s : 快照卷；
      -p r: 限制快照卷为只读访问
     lvcreate -L SIZE -s -p r -n LV_NAME /path/to/lv
    [root@station55 ~]# lvcreate -L 50M -s -p r -n kuaizhao /dev/myvg/mylv
    Rounding up size to full physical extent 52.00 MiB
    Logical volume "kuaizhao" created
    （创建快照成功，用lvs可以看到快照卷的信息）
    创建完后快照卷就可以挂在查看了
    [root@station55 ~]# mount /dev/myvg/kuaizhao /media/
    mount: block device /dev/mapper/myvg-kuaizhao is write-protected, mounting read-only
    （提示挂在为只读模式）
###12.移除逻辑卷：
    lvremove /path/to/lv
    [root@station55 ~]# lvremove /dev/myvg/mylv
    Do you really want to remove active logical volume mylv? [y/n]: y
    Logical volume "mylv" successfully removed
    （移除逻辑卷成功，移除mylv前先把快照给移除命令和移除逻辑卷一样）
###13.移除卷组：
     vgremove VG_NAME
    [root@station55 ~]# vgremove myvg
    Volume group "myvg" successfully removed
    （移除搞定）
###14.移除物理卷；
    [root@station55 ~]# pvremove /dev/sdc1
    Labels on physical volume "/dev/sdc1" successfully wiped
    （移除搞定）
