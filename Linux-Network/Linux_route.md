##Linux下route add route del 用法

###显示现在所有路由
    #route
    root@Ubuntu:~# route
    Kernel IP routing table
    Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
    10.147.9.0      *               255.255.255.0   U     1      0        0 eth0
    192.168.1.0     *               255.255.255.0   U     2      0        0 wlan0
    192.168.122.0   *               255.255.255.0   U     0      0        0 virbr0
    link-local      *               255.255.0.0     U     1000   0        0 eth0
    192.168.0.0     192.168.1.1     255.255.0.0     UG    0      0        0 wlan0
    default         10.147.9.1      0.0.0.0         UG    0      0        0 eth0
    root@ubuntu:~#
#####结果是自上而下， 就是说， 哪条在前面， 哪条就有优先， 前面都没有， 就用最后一条default
###举例:
#####添加一条路由(发往192.168.62这个网段的全部要经过网关192.168.1.1)
    route add -net 192.168.62.0 netmask 255.255.255.0 gw 192.168.1.1
#####删除一条路由
    route del -net 192.168.122.0 netmask 255.255.255.0

####删除的时候不用写网关

###linux下添加路由的方法：

####一：使用 route 命令添加
#####使用route 命令添加的路由，机器重启或者网卡重启后路由就失效了，方法：
    //添加到主机的路由
    # route add –host 192.168.168.110 dev eth0
    # route add –host 192.168.168.119 gw 192.168.168.1
    //添加到网络的路由
    # route add –net IP netmask MASK eth0
    # route add –net IP netmask MASK gw IP
    # route add –net IP/24 eth1
    //添加默认网关
    # route add default gw IP
    //删除路由
    # route del –host 192.168.168.110 dev eth0

####二：在linux下设置永久路由的方法：
    1.在/etc/rc.local里添加
    方法：
    route add -net 192.168.3.0/24 dev eth0
    route add -net 192.168.2.0/24 gw 192.168.3.254
    2.在/etc/sysconfig/network里添加到末尾
    方法：GATEWAY=gw-ip 或者 GATEWAY=gw-dev
    3./etc/sysconfig/static-router :
    any net x.x.x.x/24 gw y.y.y.y
