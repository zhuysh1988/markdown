# RHEL7没有图形界面，安装图形界面

## 背景：
* 新建RHEL7机器，启动后没有图形界面

## 原因：
* 系统在创建时，没有安装图形化
* 系统默认的运行级别不是图形化
* 系统在安装后，有降低内存的操作，内存过低无法启动桌面,以及其他

> 下面着重叙述，在创建系统时，没有安装图形化。应该怎么单独安装图形化的方法。 
> 一般而言，我们在安装系统的时候会有图形界面供我们选择。选择“Server with GUI”默认是”
> Minimal Install”。 如果一不小心，没有选中这个按钮，那么我们启动机器的时候就没有图形界面。

## 手动安装图形化界面
### 1 先将OS资源挂载好

### 2 再配置yum源，可以查看既存博客，如何配置yum源（http://blog.csdn.net/zengzisuzi/article/details/78134455）
```
[root@ClusterRhel7n1zs ~]# cd /mnt
[root@ClusterRhel7n1zs mnt]# yum group list
Loaded plugins: langpacks, product-id, subscription-manager
This system is not registered to Red Hat Subscription Management. You can use su                                                                                                 bscription-manager to register.
There is no installed groups file.
Maybe run: yum groups mark convert (see man yum)
zs                                                       | 4.1 kB     00:00
(1/2): zs/group_gz                                         | 134 kB   00:00
(2/2): zs/primary_db                                       | 3.4 MB   00:05
Available environment groups:
   Minimal Install
   Infrastructure Server
   File and Print Server
   Basic Web Server
   Virtualization Host
   Server with GUI
Available Groups:
   Compatibility Libraries
   Console Internet Tools
   Development Tools
   Graphical Administration Tools
   Legacy UNIX Compatibility
   Scientific Support
   Security Tools
   Smart Card Support
   System Administration Tools
   System Management
Done
```

### 3 开始安装图形化界面
```
[root@ClusterRhel7n1zs mnt]#yum -y groupinstall "Server with GUI"
...
Complete!
```

### 4 查看已经安装详情
```
[root@ClusterRhel7n1zs mnt]# show-installed
WARNING: The following groups contain packages not found in the repositories:
XXX base
        yum-plugin-security
XXX core
        ql2100-firmware
        ql23xx-firmware
        ql2200-firmware
        bfa-firmware
XXX gnome-desktop
        unoconv
        polkit-gnome
        gvfs-obexftp

@base
        -yum-plugin-security
@compat-libraries
@core
        -bfa-firmware
        -ql2100-firmware
        -ql2200-firmware
        -ql23xx-firmware
@development
@dial-up
@fonts
@gnome-desktop
        -gvfs-obexftp
        -polkit-gnome
        -unoconv
@guest-agents
@guest-desktop-agents
@input-methods
@internet-browser
@multimedia
@print-client
@x11
# Others
Red_Hat_Enterprise_Linux-Release_Notes-7-ja-JP
grub2
man-pages-ja
# 1255 package names, 246 leaves
# 14 groups, 3 leftovers, 8 excludes
# 29 lines
```
### 5 随后便可以使用命令切换到图形界面了
```
[root@ClusterRhel7n1zs mnt]# startx
```

### 6 将图形界面设置为默认启动界面
```
[root@ClusterRhel7n1zs mnt]#systemctl get-default
multi-user.target  
[root@ClusterRhel7n1zs mnt]#cat /etc/inittab  
[root@ClusterRhel7n1zs mnt]#systemctl set-default graphical.target
rm '/etc/systemd/system/default.target'  
ln -s '/usr/lib/systemd/system/graphical.target' '/etc/systemd/system/default.target' 
[root@ClusterRhel7n1zs mnt]#systemctl get-default 
graphical.target 
[root@ClusterRhel7n1zs mnt]#reboot
```