###注意:本文使用的为公网源 所以重装的机器需要能连公网，如果不能连接公网你需要搭建私有源

FROM <https://my.oschina.net/firxiao/blog/295553>
####登录到需要重装系统的centos上

##下载启动文件

###本文安装的为centos6.5 根据不同版本下载不同的文件

    wget http://mirrors.aliyun.com/centos/6.5/os/x86_64/images/pxeboot/vmlinuz
    wget http://mirrors.aliyun.com/centos/6.5/os/x86_64/images/pxeboot/initrd.img


###将下载的文件复制到/boot 目录

    cp vmlinuz /boot/vmlinuz.centos.pxe
    cp initrd.img /boot/initrd.img.centos.pxe



####添加安装启动项

###编辑启动菜单

    vim /boot/grub/menu.lst
####添加

    title CentOS 6.5 VNC Installation
    root (hd0,0)
    kernel /vmlinuz.centos.pxe vnc vncpassword=password headless ip=127.0.0.1 netmask=255.255.255.0 gateway=127.0.0.1 dns=114.114.114.114 ksdevice=eth0 method=http://mirrors.aliyun.com/centos/6.5/os/x86_64/ lang=en_US keymap=us
    initrd /initrd.img.centos.pxe
####更改password为你的vnc密码(至少6位)

####更改127.0.0.1 为重装系统主机的IP
####
####更改网关127.0.0.1为重装系统主机的网关
####
####编辑启动顺序
####
####找到

    default=0
###若刚才添加的title 为第二个title 则将0改为1
###
###若刚才添加的title 为第三个title 则将0改为2
###
###以此类推
###
###附上我的配置
###

    # Note that you do not have to rerun grub after making changes to this file
    # NOTICE:  You have a /boot partition.  This means that
    #          all kernel and initrd paths are relative to /boot/, eg.
    #          root (hd0,0)
    #          kernel /vmlinuz-version ro root=/dev/mapper/vg_openstack-lv_root
    #          initrd /initrd-[generic-]version.img
    #boot=/dev/sda
    default=1
    timeout=5
    splashimage=(hd0,0)/grub/splash.xpm.gz
    hiddenmenu
    title CentOS (2.6.32-431.el6.x86_64)
            root (hd0,0)
            kernel /vmlinuz-2.6.32-431.el6.x86_64 ro root=/dev/mapper/vg_openstack-lv_root rd_LVM_LV=vg_openstack/lv_root rd_NO_LUKS.UTF-8 rd_NO_MD SYSFONT=latarcyrheb-sun16 crashkernel=auto  KEYBOARDTYPE=pc KEYTABLE=us rd_LVM_LV=vg_openstack/lv_swap rd_NO_DM rhgb quiet
            initrd /initramfs-2.6.32-431.el6.x86_64.img
    title CentOS 6.5 VNC Installation
    root (hd0,0)
    kernel /vmlinuz.centos.pxe vnc vncpassword=firxiao headless ip=192.168.2.254 netmask=255.255.255.0 gateway=192.168.2.1 dns=114.114.114.114 ksdevice=eth0 method=http://mirrors.aliyun.com/centos/6.5/os/x86_64/  lang=en_US keymap=us
           initrd /initrd.img.centos.pxe
####最后仔细检查是否有错误

##重启

    reboot


####通过vnc客户端访问 IP:1

####开始安装


# Centos7

###摘要: 使用vnc进行远程重新安装centos7
###一、下载启动文件

     #wget http://mirrors.aliyun.com/centos/7/os/x86_64/images/pxeboot/initrd.img -O /boot/initrd.img.remote
     #wget http://mirrors.aliyun.com/centos/7/os/x86_64/images/pxeboot/vmlinuz -O /boot/vmlinuz.remote
###二、配置grub2

    #vim /etc/grub.d/40_custom
###追加:

    menuentry "remote reinstall" {
            set root=(hd0,1)
            linux /vmlinuz.remote repo=http://mirrors.aliyun.com/centos/7/os/x86_64/ vnc vncpassword=password ip=192.168.100.51 netmask=255.255.255.0 gateway=192.168.100.1 nameserver=223.5.5.5 noselinux headless xfs panic=60
            initrd /initrd.img.remote
    }
###注意: 将ip地址、nameserver、vncpasswod、及repo改为你自己的 其中密码最少6位

    #vim /etc/default/grub
###追加:

    GRUB_DEFAULT="remote reinstall"
###更改好执行

    #grub2-mkconfig --output=/boot/grub2/grub.cfg
###执行后完成后无报错后执行

    #reboot
###三、vnc连接进行安装

####使用vnc客户端连接你配置的ip 输入你配置的密码
####
####例如本文中:
####
####vnc客户端连接 192.168.100.51:1
####
####如图:
![](http://upload-images.jianshu.io/upload_images/5969055-d48c4464be739f1d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![](http://upload-images.jianshu.io/upload_images/5969055-02037833ef0b634d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###mac系统 Finder → 远程连接服务器 →  vnc://192.168.100.51:5901/
![](http://upload-images.jianshu.io/upload_images/5969055-a07826fe64546f0b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
