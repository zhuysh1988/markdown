## Centos系统调整LVM卷/home分区到/分区

>解决linux系统CentOS下调整home和根分区大小:目标：将VolGroup-lv_home缩小到20G，并将剩余的空间添加给VolGroup-lv_root,1.首先查看磁盘使用情况...

>目标：将VolGroup-lv_home缩小到20G，并将剩余的空间添加给VolGroup-lv_root
 
- ###1.首先查看磁盘使用情况
    [root@localhost ~]# df -h
    文件系统 容量  已用 可用  已用% 挂载点
    Filesystem              Size  Used Avail Use% Mounted on  
    /dev/mapper/VolGroup-lv_root 154G  7.9G  139G   6% /
    tmpfs                  1.9G  100K  1.9G   1% /dev/shm
    /dev/sda1              485M   69M  391M  15% /boot
    /dev/mapper/VolGroup-lv_home 299G  984M  283G   1% /home
 
- ###2、卸载/home
    [root@localhost ~]# umount /home
    umount /home 如果提示无法卸载，则是有进程占用/home，使用如下命令来终止占用进程：
    [root@localhost ~]# fuser -m /home  
 
- ###3、调整分区大小
    [root@localhost ~]# resize2fs -p /dev/mapper/VolGroup-lv_home 20G
    如果提示运行“e2fsck -f /dev/mapper/VolGroup-lv_home”，则执行相关命令： 
    [root@localhost ~]# e2fsck -f /dev/mapper/VolGroup-lv_home 然后重新执行命令：
    [root@localhost ~]# resize2fs -p /dev/mapper/VolGroup-lv_home 20G
    注：resize2fs 为重新设定磁盘大小，只是重新指定一下大小，并不对结果有影响，需要下面lvreduce的配合
 
- ###4、挂载上/home，查看磁盘使用情况
    [root@localhost ~]# mount /home
    [root@localhost ~]# df -h
 
- ###5、设置空闲空间
    使用lvreduce指令用于减少LVM逻辑卷占用的空间大小。可能会删除逻辑卷上已有的数据，所以在操作前必须进行确认。记得输入 “y”
    [root@localhost ~]# lvreduce -L 20G /dev/mapper/VolGroup-lv_home
    注：lvreduce -L 20G的意思为设置当前文件系统为20G，如果lvreduce -l 20G是指从当前文件系统上减少20G
    使用lvreduce减小逻辑卷的大小。注意：减小后的大小不能小于文件的大小，否则会丢失数据。 
     
    可以使用vgdisplay命令等查看一下可以操作的大小。也可以是用fdisk -l命令查看详细信息。
    [root@localhost ~]# vgdisplay
    注：vgdisplay为显示LVM卷组的元数据信息
 
- ###6.把闲置空间挂在到根目录下
    [root@localhost ~]# lvextend -L +283G /dev/mapper/VolGroup-lv_root
    注：lvextend -L +283G为在文件系统上增加283G
    [root@localhost ~]# resize2fs -p /dev/mapper/VolGroup-lv_root
 
- ###7、检查调整结果
    [root@localhost ~]# df -h
