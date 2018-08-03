* ens192网卡
``` bash
cat ifcfg-ens192
TYPE=Ethernet
BOOTPROTO=none
NAME=ens192
DEVICE=ens192
ONBOOT=yes
USERCTL=on
VM_CONTROLLED=no
MASTER=bond0
SLAVE=yes
```

* bond0网卡
``` bash 
cat ifcfg-bond0
TYPE=Bond
BOOTPROTO=none
NAME=bond0
DEVICE=bond0
ONBOOT=yes
USERCTL=no
NM_CONTROLLED=no
BONDING_OPTS="mode=1 miimon=100"
IPADDR=192.168.1.111
NETMASK=255.255.248.0
GATEWAY=192.168.1.1

```

* ens224网卡
``` bash 
cat ifcfg-ens224
TYPE=Ethernet
BOOTPROTO=none
NAME=ens224
DEVICE=ens224
ONBOOT=yes
USERCTL=no
NM_CONTROLLED=no
MASTER=bond1
SLAVE=yes

```

* bond1网卡
```bash 
cat ifcfg-bond1
TYPE=Bond
BOOTPROTO=none
NAME=bond1
DEVICE=bond1
ONBOOT=yes
USERCTL=no
NM_CONTROLLED=no
BONDING_OPTS="mode=1 miimon=100"
BRIDGE=br-aux

```

* bond1.2002 网卡
``` bash
cat ifcfg-bond1.2002
BOOTPROTO=none
DEVICE=bond1.2002
ONBOOT=yes
USERCTL=no
NM_CONTROLLED=no
IPADDR=10.22.2.1
NETMASK=255.255.255.0
VLAN=yes
```

* bond1.2003 网卡
``` bash
cat ifcfg-bond1.2003
BOOTPROTO=none
DEVICE=bond1.2003
ONBOOT=yes
USERCTL=no
NM_CONTROLLED=no
IPADDR=10.22.3.1
NETMASK=255.255.255.0
VLAN=yes
```

* bond1.2004 网卡
``` bash
cat ifcfg-bond1.2004
BOOTPROTO=none
DEVICE=bond1.2004
ONBOOT=yes
USERCTL=no
NM_CONTROLLED=no
IPADDR=10.22.4.1
NETMASK=255.255.255.0
VLAN=yes
```

* br-aux网桥
```bash 
cat ifcfg-br-aux 
TYPE=Bridge
BOOTPROTO=none
DEVICE=br-aux
ONBOOT=yes
NM_CONTROLLED=no

```





TYPE="Ethernet"
PROXY_METHOD="none"
BROWSER_ONLY="no"
BOOTPROTO="static"
DEFROUTE="no"
IPV4_FAILURE_FATAL="no"
IPV6INIT="no"
IPV6_AUTOCONF="yes"
IPV6_DEFROUTE="yes"
IPV6_FAILURE_FATAL="no"
IPV6_ADDR_GEN_MODE="stable-privacy"
NAME="ens32"
DEVICE="ens32"
ONBOOT="yes"
IPV6_PRIVACY="no"


# SET IP address
# IP 地址
IPADDR=10.15.15.10
# NETMASK
NETMASK=255.255.255.0
PREFIX=24
# GATEWAY
GATEWAY=10.15.15.2

# SET DNS 
# 要配置一个向 DHCP 服务器发送不同的主机名的接口，请在 ifcfg 文件中添加以下行：
DHCP_HOSTNAME=hostname

# 要将接口配置为忽略由 DHCP 服务器发送的路由，请在 ifcfg 文件中添加以下行
PEERDNS=no

# 这样可防止网络服务使用从 DHCP 服务器接收的 DNS 服务器更新 /etc/resolv.conf。
# 要配置一个接口以便使用具体 DNS 服务器，请如上所述设定 PEERDNS=no，并在 ifcfg 文件中添加以下行：
DNS1=ip-address
DNS2=ip-address


ADDRESS0=10.10.10.0 是要连接的远程网络或主机的网络地址。
NETMASK0=255.255.255.0 是使用 ADDRESS0=10.10.10.0 定义的网络地址的子网掩码。
GATEWAY0=192.168.1.1 是默认网关，或用来连接 ADDRESS0=10.10.10.0 的 IP 地址。
以下为使用网络/子网掩码指令格式的 route-interface 文件示例。默认网关为 192.168.0.1，但租用线
路或 WAN 连接位于 192.168.0.10。这两个静态路由分别用于连接 10.10.10.0/24 和 172.16.1.0/24
网络：
ADDRESS0=10.10.10.0
NETMASK0=255.255.255.0
GATEWAY0=192.168.0.10
ADDRESS1=172.16.1.10
NETMASK1=255.255.255.0
GATEWAY1=192.168.0.10


## 史上最详细的linux网卡ifcfg-eth0配置详解
>通过查资料与工作中的进行一下总结：
```conf
DEVICE="eth1"  #网卡名称
NM_CONTROLLED="yes"  #network mamager的参数 ,是否可以由NNetwork Manager托管
HWADDR=        #MAC地址
TYPE=Ethernet          #类型
DEFROUTE=yes   #就是default route，是否把这个eth设置为默认路由
ONBOOT=yes  # 设置为yes，开机自动启用网络连接
IPADDR=    #IP地址
BOOTPROTO=none    #设置为none禁止DHCP，设置为static启用静态IP地址，设置为dhcp开启DHCP服务

# --------------------
NETMASK=255.255.255.0          
PREFIX=24   #子网掩码24位
# -----------------------
DNS1=8.8.8.8    #第一个dns服务器
BROADCAST        #广播
UUID   #唯一标识
GATEWAY=   #设置网关
DNS2=8.8.4.4 # 第二个dns服务器
IPV6INIT=no   #禁止IPV6
USERCTL=no    #是否允许非root用户控制该设备，设置为no，只能用root用户更改
NAME="System eth1"     #这个就是个网络连接的名字

#------------------------
# BOND
MASTER=bond1   #指定主的名称 
SLAVE     #指定了该接口是一个接合界面的组件。
NETWORK     #网络地址
ARPCHECK=yes # 检测
PEERDNS    # 是否允许DHCP获得的DNS覆盖本地的DNS
PEERROUTES    #是否从DHCP服务器获取用于定义接口的默认网关的信息的路由表条目
IPV6INIT  # 是否启用IPv6的接口。
IPV4_FAILURE_FATAL=yes   #如果ipv4配置失败禁用设备
IPV6_FAILURE_FATAL=yes  #如果ipv6配置失败禁用设备



在Windows上配置网络比较容易，有图形化界面可操作。在Linux中往往是通过命令修改文件的方式配置网络，因此不仅需要知道配置哪个文件，还要知道文件中每个配置参数的功能。在Redhat/Fedora等Linux中，网络配置文件一般是/etc/sysconfig/network-scripts/ifcfg-eth0；而在SLES 10中却是/etc/sysconfig/network/ifcfg-eth-id-xx:xx:xx:xx:xx:xx（后面是该网络接口的MAC地址）；在SLES 11中是/etc/sysconfig/network/ifcfg-eth0。

        在一个计算机系统中，可以有多个网络接口，分别对应多个网络接口配置文件，在/etc/sysconfig/network-scripts/目录下，依次编号的文件是ifcfg-eth0，ifcfg-eth1，...，ifcfg-eth<X>。常用的是ifcfg-eth0，表示第一个网络接口配置文件。

        ifcfg-eth0示例：

TYPE=Ethernet
DEVICE=eth0
BOOTPROTO=none
ONBOOT=yes
IPADDR=10.0.1.27
NETMASK=255.255.255.0
GATEWAY=10.0.1.1
BROADCAST=10.10.1.255
HWADDR=00:0C:29:13:5D:74
PEERDNS=yes
DNS1=10.0.1.41
USERCTL=no
NM_CONTROLLED=no
IPV6INIT=yes
IPV6ADDR=FD55:faaf:e1ab:1B0D:10:14:24:106/64
1. 配置参数说明
注：这些参数值不区分大小写，不区分单引号和双引号，甚至可以不用引号。

TYPE：配置文件接口类型。在/etc/sysconfig/network-scripts/目录有多种网络配置文件，有Ethernet 、IPsec等类型，网络接口类型为Ethernet。

DEVICE：网络接口名称

BOOTPROTO：系统启动地址协议

none：不使用启动地址协议

bootp：BOOTP协议

dhcp：DHCP动态地址协议

static：静态地址协议

ONBOOT：系统启动时是否激活

yes：系统启动时激活该网络接口

no：系统启动时不激活该网络接口

IPADDR：IP地址

NETMASK：子网掩码

GATEWAY：网关地址

BROADCAST：广播地址

HWADDR/MACADDR：MAC地址。只需设置其中一个，同时设置时不能相互冲突。

PEERDNS：是否指定DNS。如果使用DHCP协议，默认为yes。

yes：如果DNS设置，修改/etc/resolv.conf中的DNS

no：不修改/etc/resolv.conf中的DNS

DNS{1, 2}：DNS地址。当PEERDNS为yes时会被写入/etc/resolv.conf中。

NM_CONTROLLED：是否由Network Manager控制该网络接口。修改保存后立即生效，无需重启。被其坑过几次，建议一般设为no。

yes：由Network Manager控制

no：不由Network Manager控制

USERCTL：用户权限控制

yes：非root用户允许控制该网络接口

no：非root用户不运行控制该网络接口

IPV6INIT：是否执行IPv6

yes：支持IPv6

no：不支持IPv6

IPV6ADDR：IPv6地址/前缀长度