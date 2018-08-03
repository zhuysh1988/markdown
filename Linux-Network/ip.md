[root@Linux ~]# ip [option] [动作] [命令]

参数：



    option ：设定的参数，主要有：

            -s ：显示出该设备的统计数据(statistics)，例如总接受封包数等；

              动作：就是是可以针对哪些网络参数进行动作，包括有：

           link ：关于设备 (device) 的相关设定，包括 MTU, MAC 地址等等

           addr/address ：关于额外的 IP 设定，例如多 IP 的实现等等；

           route ：与路由有关的相关设定

上面的语法我们可以知道， ip 除了可以设定一些基本的网络参数之外，还能够进行额外的 IP 设定， 包括多 IP 的实现，真是太完美了！下面我们就分三个部分 (link, addr, route) 来介绍这个 ip 命令。

关于设备(device) 的相关设定： ip link

ip link 可以设定与设备 (device) 有关的相关设定，包括 MTU 以及该网络设备的 MAC 等等， 当然也可以启动 (up) 或关闭 (down) 某个网络设备。整个语法是这样的：



    [root@linux ~]# ip [-s] link show <== 单纯的查阅该设备相关的信息

    [root@linux ~]# ip link set [device] [动作与参数]

参数：



    show：仅显示出这个设备的相关内容，如果加上 -s 会显示更多统计数据；

    set ：可以开始设定项目， device 指的是 eth0, eth1 等等设备代号；

    动作与参数：包括以下动作：

       up|down ：启动 (up) 或关闭 (down) 某个设备，其他参数使用预设的以太网参数；

       address ：如果这个设备可以更改 MAC ，用这个参数修改；

       name     ：给予这个设备一个特殊的名字；

       mtu      ：设置最大传输单元。

范例一：显示出所有的设备信息



    [root@linux ~]# ip link show

    1: lo: <LOOPBACK,UP,10000> mtu 16436 qdisc noqueue

        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00

    2: eth0: <BROADCAST,MULTICAST,UP,10000> mtu 1500 qdisc pfifo_fast qlen 1000

        link/ether 00:50:fc:22:9a:cb brd ff:ff:ff:ff:ff:ff

    3: sit0: <NOARP> mtu 1480 qdisc noop

        link/sit 0.0.0.0 brd 0.0.0.0

    [root@linux ~]# ip -s link show eth0

    2: eth0: <BROADCAST,MULTICAST,UP,10000> mtu 1500 qdisc pfifo_fast qlen 1000

        link/ether 00:50:fc:22:9a:cb brd ff:ff:ff:ff:ff:ff

        RX: bytes packets errors dropped overrun mcast

        484011792 2247372 0       0       0       0

        TX: bytes packets errors dropped carrier collsns

        2914104290 2867753 0       0       0       0

使用 ip link show 可以显示出整个设备的硬件相关信息，如上所示，包括 MAC地址、MTU等等， 



比较有趣的应该是那个 sit0 的设备了，那个 sit0 的设备是将IPv4 和 IPv6 的封包进行转换， 



对于我们仅使用 IPv4 的网络是没有作用的。 lo 及 sit0 都是主机内部自行设定的。 



而如果加上 -s 的参数后，则这个网卡的相关统计信息就会被列出来， 包括接收 (RX) 及传送 (TX) 的封包数量等等，



详细的内容与 ifconfig 所输出的结果相同。



范例二：启动、关闭与设定设备的相关信息



    [root@linux ~]# ip link set eth0 up

    # 启动eth0这个设备； 

    [root@linux ~]# ip link set eth0 down

    # 关闭eth0这个设备； 

    [root@linux ~]# ip link set eth0 mtu 1000

    # 更改 MTU为1000 bytes，单位就是 bytes 。

更新网卡的 MTU 使用 ifconfig 也可以实。如果是要更改『网卡代号、 MAC 地址的信息』的话，



那可就得使用 ip了，设定前需要先关闭该网卡，否则会不成功。 如下所示：

范例三：修改网卡代号、MAC 等参数



    [root@linux ~]# ip link set eth0 name vbird

    SIOCSIFNAME: Device or resource busy

    # 因为该设备目前是启动的，所以不能这样做设定。你应该要这样做：

    [root@linux ~]# ip link set eth0 down       <==关闭设备

    [root@linux ~]# ip link set eth0 name vbird <==重新设定

    [root@linux ~]# ip link show                <==查看信息

    2. vbird: <BROADCAST,MILTICASE> mtu 900 qdisc pfifo_fast qlen 1000

        link/ehter 00:40:d0:13:c3:46 brd ff:ff:ff:ff:ff:ff

    # 呵呵，连网卡代号都可以改变！不过，玩玩后记得改回来啊！

    # 因为我们的 ifcfg-eth0 还是使用原本的设备代号！避免有问题，要改回来

    [root@linux ~]# ip link set vbird name eth0 <==设备改回来 

    [root@linux ~]# ip link set eth0 address aa:aa:aa:aa:aa:aa

    [root@linux ~]# ip link show eth0

    # 如果你的网卡支持MAC更改的话，

    # 那么上面这个命令就可以更改你的网卡MAC了！

    # 不过，还是那句老话，测试完之后请立刻改回来！

在这个设备的硬件相关信息设定，上面包括 MTU, MAC 以及传输的模式等等，都可以在这里设定。 



有趣的是那个 address 的项目，那个项目后面接的可是MAC地址而不是IP地址很容易搞错啊！切记切记！



更多的硬件参数可以使用 man ip 查阅一下与 ip link 有关的设定。



关于额外的 IP 相关设定： ip address



如果说 ip link 是与 OSI 七层模型的第二层数据链路层有关的话，那么 ip address (ip addr) 就是与第三层网络层有关的了。主要是在设定与 IP 有关的各项参数，包括 netmask, broadcast 等等。



    [root@linux ~]# ip address show   <==查看IP参数

    [root@linux ~]# ip address [add|del] [IP参数] [dev ?备名] [相关参数]

参数：



    show  ：单纯的显示出设备的 IP 信息；

    add|del ：进行相关参数的增加 (add) 或删除 (del) 设定，主要有：

    IP 参数 ：主要就是网域的设定，例如 192.168.100.100/24 之类的设定；

    dev ：这个 IP 参数所要设定的设备，例如 eth0, eth1 等等；

     相关参数：如下所示：

            broadcast：设定广播位址，如果设定值是 + 表示让系统自动计算；

            label    ：该设备的别名，例如eth0:0；

            scope    ：这个设备的领域，通常是以下几个大类：

                       global ：允许来自所有来源的连线；

                       site   ：仅支持IPv6 ，仅允许本主机的连接；

                       link   ：仅允许本设备自我连接；

                       host   ：仅允许本主机内部的连接；

                       所以当然是使用 global 了。预设也是 global ！

范例一：显示出所有设备的 IP 参数：



    [root@linux ~]# ip address show

    1: lo: <LOOPBACK,UP,10000> mtu 16436 qdisc noqueue

        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00

        inet 127.0.0.1/8 scope host lo

        inet6 ::1/128 scope host

           valid_lft forever preferred_lft forever

    2: eth0: <BROADCAST,MULTICAST,UP,10000> mtu 1500 qdisc pfifo_fast qlen 1000

        link/ether 00:50:fc:22:9a:cb brd ff:ff:ff:ff:ff:ff

        inet 192.168.1.2/24 brd 192.168.1.255 scope global eth0

        inet6 fe80::250:fcff:fe22:9acb/64 scope link

           valid_lft forever preferred_lft forever

    3: sit0: <NOARP> mtu 1480 qdisc noop

        link/sit 0.0.0.0 brd 0.0.0.0

下面我们进一步来新增虚拟的网络设备：

范例二：新增一个设备，名称假设为 eth0:vbird

    

    [root@linux ~]# ip address add 192.168.50.50/24 broadcast + /

    > dev eth0 label eth0:vbird

    [root@linux ~]# ip address show eth0

    2: eth0: mtu 1500 qdisc pfifo_fast qlen 1000

        link/ether 00:40:d0:13:c3:46 brd ff:ff:ff:ff:ff:ff

        inet 192.168.1.100/24 brd 192.168.1.255 scope global eth0

        inet 192.168.50.50/24 brd 192.168.50.255 scope global eth0:vbird

        inet6 fe80::240:d0ff:fe13:c346/64 scope link

           valid_lft forever preferred_lft forever

    # 看上面的输出多出了一行，增加了新的设备，名称是 eth0:vbird

    # 至于那个 broadcast + 也可以写成 broadcast 192.168.50.255 。

    [root@linux ~]# ifconfig

    eth0:vbir Link encap:Ethernet HWaddr 00:40:D0:13:C3:46

              inet addr:192.168.50.50 Bcast:192.168.50.255 Mask:255.255.255.0

              UP BROADCAST RUNNING MULTICAST MTU:1500 Metric:1

              Interrupt:5 Base address:0x3e00

    # 如果使用 ifconfig 就能够看到这个怪东西了！

范例三：将刚刚的设备删除



    [root@linux ~]# ip address del 192.168.50.50/24 dev eth0

    # 删除比较简单。

关于路由的设定： ip route

这个项目就是路由的查看与设定。事实上ip route 的功能几乎与 route 这个命令一样，但是，它还可以进行额外的参数设置，例如 MTU 的规划等等，相当的强悍啊！



    [root@linux ~]# ip route show <==单纯的显示出路由的设定

    [root@linux ~]# ip route [add|del] [IP或网域] [via gateway] [dev 设备]

参数：



    show ：单纯的显示出路由表，也可以使用 list ；

    add|del ：增加 (add) 或删除 (del) 路由；

        IP或网域：可使用 192.168.50.0/24 之类的网域或者是单纯的 IP ；

        via     ：从那个 gateway 出去，不一定需要；

        dev     ：由那个设备连出去，需要；

        mtu     ：可以额外的设定 MTU 的数值；

范例一：显示出目前的路由资料



    [root@linux ~]# ip route show

    192.168.1.0/24 dev eth0 proto kernel scope link src 192.168.1.2

    169.254.0.0/16 dev eth1 scope link

    default via 192.168.1.254 dev eth1

如上表所示，最简单的功能就是显示出目前的路由信息，其实跟 route 这个命令相同。必须注意的几点：



proto：此路由的路由协定，主要有 redirect, kernel, boot, static, ra 等， 其中 kernel 指的是直接由核心判断自动设定。



scope：路由的范围，主要是 link ，是与本设备有关的直接连接。



再来看一下如何进行路由的增加与删除：



范例二：增加路由，主要是本机直接可沟通的网域



    [root@linux ~]# ip route add 192.168.5.0/24 dev eth0

    # 针对本机直接沟通的网域设定好路由，不需要透过外部的路由器

    [root@linux ~]# ip route show

    192.168.5.0/24 dev eth0 scope link

    ....以下省略....

范例三：增加可以通往外部的路由，需透过 router ；



    [root@linux ~]# ip route add 192.168.10.0/24 via 192.168.5.100 dev eth0

    [root@linux ~]# ip route show

    192.168.5.0/24 dev eth0 scope link

    ....其他省略....

    192.168.10.0/24 via 192.168.5.100 dev eth0

    # 仔细，因为我有 192.168.5.0/24 的路由存在 (与我的网卡直接相关)，

    # 所以才可以将 192.168.10.0/24 的路由丢给 192.168.5.100

    # 那部主机来帮忙传递！与之前提到的 route 命令是一样的限制！

范例四：增加预设路由



    [root@linux ~]# ip route add default via 192.168.1.2 dev eth0

    # 那个 192.168.1.2 就是我的预设路由器(gateway)；

    # 记住，只要一个预设路由就OK了；

范例五：删除路由



    [root@linux ~]# ip route del 192.168.10.0/24

    [root@linux ~]# ip route del 192.168.5.0/24 

 

事实上，这个 ip 的命令实在是太博大精深了！刚接触 Linux 网络的朋友，可能会看到有点晕！



您先会使用 ifconfig, ifup , ifdown 与 route 即可， 等以后有经验了之后，再继续回来玩 ip 这个好玩的命令吧！



有兴趣的话，也可以自行参考 ethtool 这个命令！
