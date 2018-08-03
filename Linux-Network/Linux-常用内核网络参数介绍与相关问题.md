##Linux 常用内核网络参数介绍与相关问题

>Linux 内核中关于网络的相关参数进行简要介绍。然后对常见相关问题的处理进行说明。

 

###Liunx 常见网络参数介绍

###下表是常见网参数的介绍：

    参数	描述
    net.core.rmem_default	默认的TCP数据接收窗口大小（字节）。
    net.core.rmem_max	最大的TCP数据接收窗口（字节）。
    net.core.wmem_default	默认的TCP数据发送窗口大小（字节）。
    net.core.wmem_max	最大的TCP数据发送窗口（字节）。
    net.core.netdev_max_backlog	在每个网络接口接收数据包的速率比内核处理这些包的速率快时，允许送到队列的数据包的最大数目。的数据包的最大数目。
    net.core.somaxconn	定义了系统中每一个端口最大的监听队列的长度，这是个全局的参数。
    net.core.optmem_max	表示每个套接字所允许的最大缓冲区的大小。
    net.ipv4.tcp_mem	确定TCP栈应该如何反映内存使用，每个值的单位都是内存页（通常是4KB）。
    第一个值是内存使用的下限；
    第二个值是内存压力模式开始对缓冲区使用应用压力的上限；
    第三个值是内存使用的上限。在这个层次上可以将报文丢弃，从而减少对内存的使用。对于较大的BDP可以增大这些值（注意，其单位是内存页而不是字节）。
    net.ipv4.tcp_rmem	为自动调优定义socket使用的内存。
    第一个值是为socket接收缓冲区分配的最少字节数；
    第二个值是默认值（该值会被rmem_default覆盖），缓冲区在系统负载不重的情况下可以增长到这个值；
    第三个值是接收缓冲区空间的最大字节数（该值会被rmem_max覆盖）。
    net.ipv4.tcp_wmem	为自动调优定义socket使用的内存。
    第一个值是为socket发送缓冲区分配的最少字节数；
    第二个值是默认值（该值会被wmem_default覆盖），缓冲区在系统负载不重的情况下可以增长到这个值；
    第三个值是发送缓冲区空间的最大字节数（该值会被wmem_max覆盖）。
    net.ipv4.tcp_keepalive_time	TCP发送keepalive探测消息的间隔时间（秒），用于确认TCP连接是否有效。
    net.ipv4.tcp_keepalive_intvl	探测消息未获得响应时，重发该消息的间隔时间（秒）。
    net.ipv4.tcp_keepalive_probes	在认定TCP连接失效之前，最多发送多少个keepalive探测消息。
    net.ipv4.tcp_sack	启用有选择的应答（1表示启用），通过有选择地应答乱序接收到的报文来提高性能，让发送者只发送丢失的报文段，（对于广域网通信来说）这个选项应该启用，但是会增加对CPU的占用。
    net.ipv4.tcp_fack	启用转发应答，可以进行有选择应答（SACK）从而减少拥塞情况的发生，这个选项也应该启用。
    net.ipv4.tcp_timestamps	TCP时间戳（会在TCP包头增加12个字节），以一种比重发超时更精确的方法（参考RFC 1323）来启用对RTT 的计算，为实现更好的性能应该启用这个选项。
    net.ipv4.tcp_window_scaling	启用RFC 1323定义的window scaling，要支持超过64KB的TCP窗口，必须启用该值（1表示启用），TCP窗口最大至1GB，TCP连接双方都启用时才生效。
    net.ipv4.tcp_syncookies	表示是否打开TCP同步标签（syncookie），内核必须打开了CONFIG_SYN_COOKIES项进行编译，同步标签可以防止一个套接字在有过多试图连接到达时引起过载。
    net.ipv4.tcp_tw_reuse	表示是否允许将处于TIME-WAIT状态的socket（TIME-WAIT的端口）用于新的TCP
    连接 。
    net.ipv4.tcp_tw_recycle	能够更快地回收TIME-WAIT套接字。
    net.ipv4.tcp_fin_timeout	对于本端断开的socket连接，TCP保持在FIN-WAIT-2状态的时间（秒）。对方可能会断开连接或一直不结束连接或不可预料的进程死亡。
    net.ipv4.ip_local_port_range	表示TCP/UDP协议允许使用的本地端口号
    net.ipv4.tcp_max_syn_backlog	对于还未获得对方确认的连接请求，可保存在队列中的最大数目。如果服务器经常出现过载，可以尝试增加这个数字。
    net.ipv4.tcp_low_latency	允许TCP/IP栈适应在高吞吐量情况下低延时的情况，这个选项应该禁用。
    net.ipv4.tcp_westwood	启用发送者端的拥塞控制算法，它可以维护对吞吐量的评估，并试图对带宽的整体利用情况进行优化，对于WAN 通信来说应该启用这个选项。
    net.ipv4.tcp_bic	为快速长距离网络启用Binary Increase Congestion，这样可以更好地利用以GB速度进行操作的链接，对于WAN通信应该启用这个选项。
    net.ipv4.tcp_max_tw_buckets	该参数设置系统的TIME_WAIT的数量，如果超过默认值则会被立即清除。
    net.ipv4.route.max_size	内核所允许的最大路由数目。
    net.ipv4.ip_forward	接口间转发报文。
    net.ipv4.ip_default_ttl	报文可以经过的最大跳数。
    net.netfilter.nf_conntrack_tcp_timeout_established 	让iptables对于已建立的连接，在设置时间内若没有活动，那么则清除掉。
    net.netfilter.nf_conntrack_max	哈希表项最大值。
####注意：不同类型或版本操作系统下上述参数可能有所不同。
 

###网络相关内核参数引发的常见问题的处理

####Linux NAT 哈希表满导致服务器丢包

###问题现象

>发现 ECS Linux服务器出现间歇性丢包的情况，通过 tracert、mtr 等手段排查，外部网络未见异常。
同时，如下图所示，在系统日志中重复出现大量（kernel nf_conntrack: table full, dropping packet.）错误信息：  



###问题分析

>ip_conntrack 是 Linux 系统内 NAT 的一个跟踪连接条目的模块。ip_conntrack 模块会使用一个哈希表记录 tcp 通讯协议的 established connection 记录，当这个哈希表满了的时候，便会导致 nf_conntrack: table full, dropping packet 错误。
###处理办法

>用户可以 尝试 参阅如下步骤，通过修改如下内核参数来调整 ip_conntrack 限制。
####对于 Centos 5.x 系统

    1、使用【管理终端】进入服务器。

    2、在终端下输入如下指令编辑系统内核配置：

    # vi /etc/sysctl.conf

    3、设置或修改如下参数：

    #哈希表项最大值

    net.ipv4.netfilter.ip_conntrack_max = 655350

    #超时时间，默认情况下 timeout 是5天（432000秒）

    net.ipv4.netfilter.ip_conntrack_tcp_timeout_established = 1200

    4、在终端下输入如下指令使上述配置生效：

    # sysctl -p
####对于 Centos 6.x 及以上系统

    1、使用【管理终端】进入服务器；

    2、在终端下输入如下指令编辑系统内核配置：

    # vi /etc/sysctl.conf

    3、设置或修改如下参数：

    哈希表项最大值

    net.netfilter.nf_conntrack_max = 655350

    超时时间，默认情况下 timeout 是5天（432000秒）

    net.netfilter.nf_conntrack_tcp_timeout_established = 1200

    4、在终端下输入如下指令使上述配置生效：

    # sysctl -p
###服务器 message 日志 kernel: TCP: time wait bucket table overflowt 报错处理方法

####问题现象

>查询服务器 /var/log/message 日志，发现全部是类似如下 kernel: TCP: time wait bucket table overflowt 的报错信息，报错提示 tcp TIME WAIT 溢出：



####问题分析

    通过 netstat -anp |grep tcp |wc -l统计 TCP 连接数。然后对比/etc/sysctl.conf配置文件的net.ipv4.tcp_max_tw_buckets 最大值。看是否有超出情况。

    编辑文件vim /etc/sysctl.conf，查询net.ipv4.tcp_max_tw_buckets 参数



####处理办法

>如果确认连接使用很高，容易超出限制。则可以将参数 net.ipv4.tcp_max_tw_buckets调高，扩大限制。

>最后，在终端下输入如下指令使上述配置生效：

    #sysctl -p
 

###Linux FIN_WAIT2 状态的 TCP 链接过多解决方法

####问题现象

>在 HTTP 应用中，存在一个问题，SERVER 由于某种原因关闭连接，如 KEEPALIVE 的超时。这样，作为主动关闭的 SERVER 一方就会进入 FIN_WAIT2 状态。但 TCP/IP 协议栈有个问题，FIN_WAIT2 状态是没有超时的（不象 TIME_WAIT 状态），所以如果 CLIENT不关闭，这个 FIN_WAIT_2 状态将保持到系统重新启动，越来越多的 FIN_WAIT_2 状态会致使内核 crash。

####处理办法

    1、编辑文件vim /etc/sysctl.conf修改如下内容：
    net.ipv4.tcp_syncookies = 1  # 表示开启 SYN Cookies。当出现 SYN 等待队列溢出时，启用 cookies 来处理，可防范少量 SYN 攻击，默认为 0，表示关闭。
    net.ipv4.tcp_fin_timeout = 30 # 表示如果套接字由本端要求关闭，这个参数决定了它保持在 FIN-WAIT-2 状态的时间。
    net.ipv4.tcp_max_syn_backlog = 8192 # 表示 SYN 队列的长度，默认为 1024，加大队列长度为 8192，可以容纳更多等待连接的网络连接数。
    net.ipv4.tcp_max_tw_buckets = 5000 # 表示系统同时保持 TIME_WAIT 套接字的最大数量，如果超过这个数字，TIME_WAIT 套接字将立刻被清除并打印警告信息。默认为 180000，改为 5000。
    2、通过sysctl -p命令使参数生效。

 

###服务器上出现大量 CLOSE_WAIT 的原因及解决方法

###问题现象

>通过命令 netstat -an|grep CLOSE_WAIT|wc -l 查看当前服务器上处于 CLOSE_WAIT 状态的连接数，根据服务器上的业务量来判断 CLOSE_WAIT 数量是否超出了正常的范围。
问题原因

>TCP连接断开时需要进行四次挥手，TCP连接的两端都可以发起关闭连接的请求，若对端发起了关闭连接，但本地没有进行后续的关闭连接操作，那么该链接就会处于CLOSE_WAIT状态。虽然该链接已经处于半开状态，但是已经无法和对端通信，需要及时的释放掉该链接。

####解决方法

>建议从业务层面及时判断某个连接是否已经被对端关闭，即在程序逻辑中对连接及时进行关闭检查。

>Java 中 IO 可以通过 read 方法来判断，当 read 方法返回 -1 时则表示流已经到达末尾，可以使用 close 方法关闭该链接。C 语言中检查 read 的返回值，若是 0 则可以关闭该连接，若小于 0 则查看一下 errno，若不是 AGAIN 则同样可以关闭连接。

 

###服务器上出现大量 TIME_WAIT 的原因及解决方法

####问题现象

>通过 netstat 或 ss ，可以看到有大量处于 TIME_WAIT 状态的连接。
####问题分析

####可以通过如下命令查看 TIME_WAIT 数量：

    netstat -n | awk '/^tcp/ {++y[$NF]} END {for(w in y) print w, y[w]}'

####处理办法

    1、编辑文件vim /etc/sysctl.conf，修改或加入以下内容：

    net.ipv4.tcp_syncookies = 1 
    net.ipv4.tcp_tw_reuse = 1 
    net.ipv4.tcp_tw_recycle = 1
    net.ipv4.tcp_fin_timeout = 30
    2、然后执行 /sbin/sysctl -p让参数生效。

 

###net.ipv4.tcp_fin_timeout 修改导致的 TCP 连接异常排查

####问题现象

>服务端 A 与客户端 B 建立了 TCP 连接，之后，服务端 A 主动断开了连接，但是在客户端 B 上仍然看到连接是建立的。


####问题原因

>通常是由于修改了服务端内核参数 net.ipv4.tcp_fin_timeout 默认设置所致。

####处理办法

    编辑文件vim /etc/sysctl.conf ，修改如下设置：

    net.ipv4.tcp_fin_timeout=30

    最后，使用命令 sysctl -p 使配置生效即可。

 

###内核配置问题导致 NAT 环境访问异常

####问题现象

>用户在其本地网络环境通过 SSH 无法连接 ECS Linux 服务器，或者访问该 Linux 服务器上承载的 HTTP 业务出现异常。 telent 测试也会被 reset。

####问题原因

>如果用户本地网络是通过 NAT 共享的方式上网，该问题可能是由于用户本地 NAT 环境和目标 Linux 相关内核参数配置不匹配导致的。

####处理办法

>可以尝试通过如下方式修改目标 Linux 服务器的内核参数来解决该问题：

    1、远程连接目标 Linux；

    2、查看当前配置：

    cat /proc/sys/net/ipv4/tcp_tw_recyclecat /proc/sys/net/ipv4/tcp_timestamps
    查看上述两个配置的值【是不是0】，如果为 1 的话，NAT 环境下的请求可能会导致上述问题。

    3、通过如下方式将上述参数值修改为 0：

    vi /etc/sysctl.conf
    添加如下内容：

    net.ipv4.tcp_tw_recycle=0net.ipv4.tcp_timestamps=0
    4、使用如下指令使配置生效：

    sysctl -p
    5、上述配置修改后，再重新做 SSH 登录或者业务访问测试。
