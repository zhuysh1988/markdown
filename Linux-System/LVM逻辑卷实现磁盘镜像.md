#LVM逻辑卷实现磁盘镜像
#####大家都知道用lvm作分区扩展很方便，其实用lvs还可以用作磁盘镜像，类似于raid1，即多块磁盘互相同步备份，可以有效避免数据丢失的尴尬。

###1.新建磁盘分区

>新建4个分区/dev/sdb1,/dev/sdb2,/dev/sdb3,/dev/sdb4，如：

    Disk /dev/sdb: 1999.8 GB, 1999844147200 bytes
    255 heads, 63 sectors/track, 243133 cylinders
    Units = cylinders of 16065 * 512 = 8225280 bytes

       Device Boot      Start         End      Blocks   Id  System
    /dev/sdb1               1         374     3004123+  83  Linux
    /dev/sdb2             375         748     3004155   83  Linux
    /dev/sdb3             749        1122     3004155   83  Linux
    /dev/sdb4            1123        1496     3004155   83  Linux

>其中/dev/sdb1,/dev/sdb2用作数据磁盘，/dev/sdb2用作/dev/sdb1的镜像；
>/dev/sdb3用作日志；/dev/sdb4作为备用，当sdb1或sdb2损害时备用，类似于raid5中的热备盘。

###2.创建pv和vg

    pvcreate /dev/sdb1

    pvcreate /dev/sdb2
    pvcreate /dev/sdb3
    pvcreate /dev/sdb4
    vgcreate vg_test  /dev/sdb1 /dev/sdb2 /dev/sdb3

>注：/dev/sdb4暂未使用，待备用

###3.创建包含镜像功能的逻辑卷(mirror_test)

    [root@localhost ~]# lvcreate -L 2.8G -m1 -n mirror_test vg_test /dev/sdb1 /dev/sdb2 /dev/sdb3
      Rounding up size to full physical extent 2.80 GB
      Logical volume "mirror_test" created
    [root@localhost ~]# lvs -a -o +devices
      LV                     VG                Attr   LSize   Origin Snap%  Move Log              Copy%  Convert Devices

      mirror_test            vg_test           mwi-a-   2.80G                    mirror_test_mlog  24.27         mirror_test_mimage_0(0),mirror_test_mimage_1(0)
      [mirror_test_mimage_0] vg_test           Iwi-ao   2.80G                                                    /dev/sdb1(0)
      [mirror_test_mimage_1] vg_test           Iwi-ao   2.80G                                                    /dev/sdb2(0)
      [mirror_test_mlog]     vg_test           lwi-ao   4.00M                                                    /dev/sdb3(0)

>其中：-m1参数为创建镜像；-L参数为设定镜像卷的大小为2.8G；-n参数为指定镜像名称。这个镜像包括三部分：sdb1和sdb2位数据卷和镜像卷，sdb3为日志卷。

###4.格式化挂载
    [root@localhost ~]# mkfs.ext3 /dev/vg_test/mirror_test
    [root@localhost ~]# mkdir -p /test
    [root@localhost ~]# mount /dev/vg_test/mirror_test /test


###5.测试
>(1)创建测试文件

    for x in {1..100};do echo "$x test test test " >> /test/test.txt ;done
>(2)模拟对/dev/sdb2进行破坏


    [root@localhost ~]# dd if=/dev/zero of=/dev/sdb2 count=10 bs=1M
    10+0 records in
    10+0 records out
    10485760 bytes (10 MB) copied, 0.008574 seconds, 1.2 GB/s
    [root@localhost ~]# lvs -a -o +devices
      Couldn't find device with uuid z74R0l-ZLUV-X6TS-QrpF-nXDZ-gc74-UvwGC0.
      LV                     VG                Attr   LSize   Origin Snap%  Move Log              Copy%  Convert Devices

      mirror_test            vg_test           mwi-ao   2.80G                    mirror_test_mlog 100.00         mirror_test_mimage_0(0),mirror_test_mimage_1(0)
      [mirror_test_mimage_0] vg_test           iwi-ao   2.80G                                                    /dev/sdb1(0)
      [mirror_test_mimage_1] vg_test           iwi-ao   2.80G                                                    unknown device(0)
      [mirror_test_mlog]     vg_test           lwi-ao   4.00M                                                    /dev/sdb3(0)

>查看状态发现/dev/sdb2处于“unknown device(0)”状态。

    [root@localhost ~]# lvscan
      Couldn't find device with uuid z74R0l-ZLUV-X6TS-QrpF-nXDZ-gc74-UvwGC0.
      ACTIVE            '/dev/vg_test/mirror_test' [2.80 GB] inherit

>(3)重新挂载确认数据可读取

    [root@localhost ~]# umount /test
    [root@localhost test]# cd
    [root@localhost ~]# mount /dev/vg_test/mirror_test /test
    [root@localhost ~]# cat /test/test.txt
    lvs mirror test
>(4)将坏掉的设备删除

    [root@localhost ~]# vgreduce --removemissing --force vg_test
      Couldn't find device with uuid z74R0l-ZLUV-X6TS-QrpF-nXDZ-gc74-UvwGC0.
      WARNING: Bad device removed from mirror volume, vg_test/mirror_test
      WARNING: Mirror volume, vg_test/mirror_test converted to linear due to device failure.
      Wrote out consistent volume group vg_test
>移除后vgdisplay /dev/vg_test发现mirrored  volumes选项没有了；并且由于sdb2的实效，
>镜像mirror_test也已经有mirror模式转变成线性模式，如果恢复我们需要用到lvconvert命令来恢复。

>(5)镜像数据恢复


    [root@localhost ~]# vgextend vg_test /dev/sdb4  
      Volume group "vg_test" successfully extended  
    [root@localhost ~]# lvconvert -m1 /dev/vg_test/mirror_test /dev/sdb1 /dev/sdb4 /dev/sdb3  
      vg_test/mirror_test: Converted: 0.0%  
      vg_test/mirror_test: Converted: 20.8%  
      vg_test/mirror_test: Converted: 40.4%  
      vg_test/mirror_test: Converted: 60.1%  
      vg_test/mirror_test: Converted: 79.4%  
      vg_test/mirror_test: Converted: 99.2%  
      vg_test/mirror_test: Converted: 100.0%  
>ok，恢复完成，我们来查看下状态：

    [root@localhost ~]# lvdisplay /dev/vg_test  
      --- Logical volume ---  
      LV Name                /dev/vg_test/mirror_test  
      VG Name                vg_test  
      LV UUID                RUamnD-nYCt-D9yp-cNdX-ix1y-r9P9-wenSjb  
      LV Write Access        read/write  
      LV Status              available  
      # open                 1  
      LV Size                2.80 GB  
      Current LE             717  
      Mirrored volumes       2  
      Segments               1  
      Allocation             inherit  
      Read ahead sectors     auto  
      - currently set to     256  
      Block device           253:8  
         
    [root@localhost ~]# cat /test/test.txt   
    lvs mirror test  
    [root@localhost ~]# lvs -a -o +devices  
      LV                     VG                Attr   LSize   Origin Snap%  Move Log              Copy%  Convert Devices                                          
                                    
      mirror_test            vg_test           mwi-ao   2.80G                    mirror_test_mlog 100.00         mirror_test_mimage_0(0),mirror_test_mimage_1(0)  
      [mirror_test_mimage_0] vg_test           iwi-ao   2.80G                                                    /dev/sdb1(0)                                     
      [mirror_test_mimage_1] vg_test           iwi-ao   2.80G                                                    /dev/sdb4(0)                                     
      [mirror_test_mlog]     vg_test           lwi-ao   4.00M                                                    /dev/sdb3(0)   
>镜像卷由原来的sdb2转变为sdb4

>总结：在某些不支持raid的服务器上，我们可以使用lvm的磁盘镜像来解决防止数据丢失的问题了。
