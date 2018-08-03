#lvm 增加根分区容量


#添加硬盘
    fdisk -l
    #新加硬盘为 /dev/sdb

#分区
    fdisk /dev/sdb
    #分为一个分区 /dev/sdb1 修改标签为8e  LVM

#LVM
    pvcreate /dev/sdb1
    vgextend VGGROUP /dev/sdb1
    lvresize -L +10G /dev/VGGROUP/LVNAME
    OR
    lvextend -L +10G /dev/VGGROUP/LVNAME

    #根分区可能要重启,不过测试 CENTOS6/7不需要重启

#修复文件系统
    e2fsck -f /dev/VGGROUP/LVNAME

#重置文件系统大小
    # ext4/3/2
    resize2fs /dev/VGGROUP/LVNAME

    # xfs
    xfs_growfs /dev/VGGROUP/LVNAME
