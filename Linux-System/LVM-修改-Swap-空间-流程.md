#LVM 修改 Swap 空间 流程
+ 应该查看下/etc/fstab对应挂载,如果是以UUID方式挂载的,应修改为文件或者设备才可以.否责重启后报错
+ swap 空间 对应 /dev/vg/lv_swap

#关闭swap挂载
    swapoff -a    #取消所有的挂载
#缩小lv_swap
    lvreduce -L -xxx /dev/vg/lv_swap
#格式化lv_swap
    mkswap /dev/vg/lv_swap
#挂载lv_swap
    swapon /dev/vg/lv_swap

#swap相关命令
    [root@54 ~]# swapoff --help

    Usage:
     swapoff -a [-v]                      disable all swaps
     swapoff [-v] <special>               disable given swap
     swapoff -h                           display help
     swapoff -V                           display version

    The <special> parameter:
     {-L label | LABEL=label}             LABEL of device to be used
     {-U uuid  | UUID=uuid}               UUID of device to be used
     <device>                             name of device to be used
     <file>                               name of file to be used

    [root@54 ~]# swapo
    swapoff  swapon
    [root@54 ~]# swapo
    swapoff  swapon
    [root@54 ~]# swapon --help

    Usage:
     swapon [options] [<special>]
     -a, --all                enable all swaps from /etc/fstab
     -d, --discard[=<policy>] enable swap discards, if supported by device
     -e, --ifexists           silently skip devices that do not exist
     -f, --fixpgsz            reinitialize the swap space if necessary
     -p, --priority <prio>    specify the priority of the swap device
     -s, --summary            display summary about used swap devices
     -h, --help               display help
     -V, --version            display version
     -v, --verbose            verbose output

    The <special> parameter:
     {-L label | LABEL=label}             LABEL of device to be used
     {-U uuid  | UUID=uuid}               UUID of device to be used
     <device>                             name of device to be used
     <file>                               name of file to be used
