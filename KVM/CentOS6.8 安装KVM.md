##CentOS6.8 安装KVM

###1、系统环境
    [root@localhost iso]# cat /etc/redhat-release
    CentOS release 6.5 (Final)
###2、安装KVM所有需要的包
    [root@localhost iso]# yum -y install kvm python-virtinst libvirt tunctl bridge-utils virt-manager qemu-kvm-tools virt-viewer virt-v2v
    [root@localhost iso]# yum -y install libguestfs-tools
    [root@localhost iso]# /etc/init.d/libvirtd restart


###3启动的时候可能会报错如下:
    Starting libvirtd daemon: libvirtd: relocation error: libvirtd: symbol dm_task_get_info_with_deferred_remove, version Base not defined in file libdevmapper.so.1.02 with link time reference [FAILED]


####解决办法：
    yum upgrade device-mapper-libs
    [root@localhost iso]# /etc/init.d/libvirtd restart

####检测安装
    [root@localhost iso]#  virsh -c qemu:///system list
     Id    名称                         状态
    ----------------------------------------------------


    [root@localhost iso]# lsmod |grep kvm
    kvm_intel              54285  0
    kvm                   333172  1 kvm_intel
    [root@localhost iso]# virsh --version
    0.10.2
    [root@localhost iso]# virt-install --version
    0.600.0
    [root@localhost iso]# ln -s /usr/libexec/qemu-kvm /usr/bin/qemu-kvm


###4、桥接网卡
    # 一定要关闭NetworkManager
    /etc/init.d/NetworkManager stop
    chkconfig NetworkManager off
    cd /etc/sysconfig/network-scripts/
    cp ifcfg-eth0 ifcfg-br0 # copy 一份
    cat ifcfg-eth0  #修改前的
        DEVICE=eth0
        TYPE=Ethernet
        ONBOOT=yes
        BOOTPROTO=static
        IPADDR=192.168.80.40
        NETMASK=255.255.255.0
    cat ifcfg-eth0 #修改后的
        DEVICE="eth0"
        BOOTPROTO="static"
        ONBOOT="yes"
        TYPE="Ethernet"
        BRIDGE=br0
    cat ifcfg-br0
        DEVICE="br0"
        BOOTPROTO="static"
        ONBOOT="yes"
        TYPE="Bridge"
        IPADDR=192.168.80.40
        NETMASK=255.255.255.0
    /etc/init.d/network restart

    [root@localhost network-scripts]# brctl show
    bridge name	bridge id		STP enabled	interfaces
    br0		8000.7446a0f51698	no		eth0
    virbr0		8000.52540095e5ac	yes		virbr0-nic
### 创建文件格式为qcow2的分区。
    qemu-img create -f qcow2 -o preallocation=metadata /home/KVM/centos68.img 20G;

### 创建虚拟机
    virt-install --name centos68 \  # 虚拟机名称
     --ram 2048 \   # 内存大小
     --disk path=/home/KVM/centos68.img,format=qcow2,size=20,bus=virtio \
    --vcpus 2 --os-type linux \
    --os-variant rhel6 \
    --network bridge=br0 \
    --location http://mirrors.jsqix.com/centos/6/ \
    --graphics none --console pty,target_type=serial \
    --extra-args 'console=ttyS0,115200n8 serial'

##KVM 常用命令:

###1,查看运行的虚拟机

    virsh list

###2,查看所有的虚拟机（关闭和运行的虚拟机）

    virsh list --all

###3,连接虚拟机

    virsh console +域名（虚拟机的名称）

###4，退出虚拟机

    ctrl+]

###5,关闭虚拟机

####5.1    virsh shutdown +域名  

>这个时候我在virsh list发现 test02这个虚拟机还是在运行的，并没有关闭。

>我们需要安装一个acpid的服务并启动它，什么是ACPI?

>ACPI是Advanced Configuration and PowerInterface缩写，高级配置和电源管理接口。

>acpid中的d则代表daemon。Acpid是一个用户空间的服务进程，它充当linux内核与应用程序之间通信的接口，负责将kernel中的电源管理事件转发给应用程序。

>Acpid是一个用户空间的服务进程，它充当linux内核与应用程序之间通信的接口，负责将kernel中的电源管理事件转发给应用程序。

>其实，说明了就是通过这个服务来执行电源关闭的动作，这也是为什么我们执行virsh shutdown +域名无法关机的原因。



#####（子机安装acpid服务） 是虚拟机,不是宿主机
    yum install -y acpid

    /etc/init.d/acpid start

>如果此时我没法进入子机安装acpi协议的话，那么就无法关掉该虚拟机，此时可以用下面这种方法。

####5.2  virsh destroy +域名

>这种方式的关闭，是一种删除的方式，只是在virsh list中删除了该虚拟机。



###6，挂起虚拟机

    virsh suspend +域名



###7，恢复被挂起的虚拟机

    virsh resume +域名



###8，子机随宿主主机（母机）启动而启动

    virsh autostart + 域名

###9，取消自动启动

    virsh auotstart --disable +域名

###10，彻底删除虚拟机

    1, 删除虚拟机   virsh destroy +域名

    2，解除标记     virsh undefine +域名

    3，删除虚拟机文件  

### 11,启动虚拟机并进入该虚拟机

    virsh start 域名 --console
