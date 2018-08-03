##Linux 使用 ip route , ip rule , iptables 配置策略路由
>要求192.168.0.100以内的使用 10.0.0.1 网关上网，其他IP使用 20.0.0.1 上网。

>首先要在网关服务器上添加一个默认路由，当然这个指向是绝大多数的IP的出口网关。

    ip route add default gw 20.0.0.1

>之后通过 ip route 添加一个路由表

    ip route add table 3 via 10.0.0.1 dev ethX (ethx是10.0.0.1所在的网卡,3 是路由表的编号)

>之后添加 ip  rule 规则

    ip rule add fwmark 3  table 3 （fwmark 3是标记，table 3 是路由表3 上边。 意思就是凡事标记了 3 的数据使用table3 路由表）

>之后使用iptables给相应的数据打上标记

    iptables -A PREROUTING -t mangle -i eth0 -s 192.168.0.1 -192.168.0.100 -j MARK --set-mark 3

>因为mangle的处理是优先于 nat 和fiter表的，所以相依数据包到达之后先打上标记，之后在通过ip rule规则，对应的数据包使用相应的路由表进行路由，最后读取路由表信息，将数据包送出网关。

##ip rule:

>进行路由时，根据路由规则来进行匹配，按优先级（pref）从低到高匹配,直到找到合适的规则.所以在应用中配置默认路由是必要的

 

##路由规则的添加
    ip rule add from 192.168.1.10/32 table 1 pref 100
>如果pref值不指定，则将在已有规则最小序号前插入

 

>PS: 创建完路由规则若需立即生效须执行
    
    ip route flush cache

         

    From -- 源地址
            To -- 目的地址（这里是选择规则时使用，查找路由表时也使用）
              Tos -- IP包头的TOS（type of sevice）域Linux高级路由-
             Dev -- 物理接口
             Fwmark -- iptables标签
    
     

    采取的动作除了指定路由表外，还可以指定下面的动作：
             Table 指明所使用的表
              Nat 透明网关
    
                 Prohibit 丢弃该包，并发送 COMM.ADM.PROHIITED的ICMP信息 
                Reject 单纯丢弃该包
                 Unreachable丢弃该包， 并发送 NET UNREACHABLE的ICMP信息
    
     
    
    Usage: ip rule [ list | add | del ]SELECTOR ACTION
             SELECTOR := [ from PREFIX ] [ toPREFIX ] [ tos TOS ][ dev STRING ] [ pref NUMBER ]
             ACTION := [ table TABLE_ID ] [ natADDRESS ][ prohibit | reject | unreachable ]
                      [ flowid CLASSID ]
             TABLE_ID := [ local | main | default| new | NUMBER ]

###详解看<http://blog.csdn.net/scdxmoe/article/details/38661457>


##linux策略路由，路由策略（高级路由设置，多出口）
FROM <http://rfyiamcool.blog.51cto.com/1030776/768562>

##功能说明：
###由Linux实现流量分割，
    1， 到202.96.209.133的数据从Linux路由器的eth2到路由器A,再到202.96.209.133。
    2， 到Internet其他地方的数据从Linux路由器的eth1到路由器B,再到Internet。

##实现方法：
###打开Linux的路由功能：
    echo 1 >/proc/sys/net/ipv4/ip_forward
###首先添加一条规则，指定从172.16.16.2来的数据查找路由表5：
    ip ru add from 172.16.16.2 lookup 5

###1，实现第一个功能
####（1），在路由表5中添加一条路由，到202.96.209.133的数据经过192.168.1.1：
    # ip ro add 202.96.209.133 via 192.168.1.1 table 5
####（2），这样就完成了路由的设置，因为172.16.16.2是私有地址，所以在Linux路由器的出口eth2处应该对其进行NAT的设置，如下：
    # iptables -t nat -A POSTROUTING -s 172.16.16.2 -d 202.96.209.133 -j SNAT --to 192.168.1.3
####（3），刷新路由缓存：
    # ip ro flush cache

###2， 实现第二个功能（在第一个的基础上）
####（1），在路由表5中添加默认路由：
    # ip ro add default via 10.10.10.2 table 5
####（2），在Linux路由器的出口eth1处进行NAT设置：
    # iptables -t nat -A POSTROUTING -s 172.16.16.2 -j SNAT --to 10.10.10.1
####（3），刷新路由缓存：
    # ip ro flush cache
####注意：如果路由缓存不刷新的话，路由命令不能马上生效！


####脚本如下：


    #!/bin/sh  
    echo 1 >/proc/sys/net/ipv4/ip_forward  
    ip ru add from 172.16.16.2 lookup 5  
    ip ro add 202.96.209.133 via 192.168.1.1 table 5  
    iptables -t nat -A POSTROUTING -s 172.16.16.2 -d 202.96.209.133 -j SNAT --to 192.168.1.3  
    ip ro add default via 10.10.10.2 table 5  
    iptables -t nat -A POSTROUTING -s 172.16.16.2 -j SNAT --to 10.10.10.1  
    ip ro flush cache  




####你也可以将上面脚本中的几行iptables命令合为一行如下：
    #iptables -t nat -A POSTROUTING -s 172.16.16.2 -j MASQUERADE
####那么脚本如下：



    #!/bin/sh
    echo 1 >/proc/sys/net/ipv4/ip_forward
    ip ru add from 172.16.16.2 lookup 5
    ip ro add 202.96.209.133 via 192.168.1.1 table 5
    ip ro add default via 10.10.10.2 table 5
    iptables -t nat -A POSTROUTING -s 172.16.16.2 -j MASQUERADE
    ip ro flush cache





>可以使用tracert命令进行测试。不同点在于路由的第二跳，到202.96.209.133时，第二跳为：192.168.1.1，到其他地方时第二跳为：10.10.10.2。

>注意：linux路由器是不能上网的，因为没有为他自己指定专门的路由或默认路由。为Linux路由器指定路由的命令如下：

    ip ro add default via 192.168.1.1
    ip ro flush cache
##文章2:
    实验名称：Linux下实现基于源地址的策略路由
    操作系统：RedHat 7.2
    所使用的内核：2.4.18
    必须的模块： iproute2，iptables

>功能描述:首先你必须明白策略路由和路由策略是两个不同的概念，策略路由是根据IP包中的源地址，端口号等来实现的；而路由策略可以理解为路由表中的一系列路由动作。

>普通的路由是根据IP包中的目的地址来判断的，如：如果数据包是到http://linux.networksbase.com的，那么发送到网关192.168.1.1，如果到其他地方发送到192.168.2.1。
但很多时候我们需要对数据包的源地址也要作出判断，如：网络中有几条出口线路，那么优先权高的人走速率快的链路，其他人走速率慢的链路，这个时候就需要策略路由。


###描述：实验中有两个局域网：LAN 1和LAN 2，我们要实现如下功能：
    1，LAN 1中的192.168.2.25和192.168.2.128从路由器A上网；
    2，LAN 1中的其他用户从路由器B上网；
    3，LAN 2中的所有用户从路由器A上网
###实现:
####首先你要打开Linux服务器的路由功能，命令如下：
    echo 1> /proc/sys/net/ipv4/ip_forward

####然后设置LAN 1和LAN 2的IP伪装：
    iptables -t nat -A POSTROUTING -s 192.168.2.0/24 -j MASQUERADE
    iptables -t nat -A POSTROUTING -s 172.16.3.0/24 -j MASQUERADE

####1，设置192.168.2.25和192.168.2.128的路由：
    ip rule add from 192.168.2.25 lookup 5
    ip rule add from 192.168.2.128 lookup 5
####这两句话的意思是将来自192.168.2.25和192.168.2.128的数据查找路由表5
    ip route add default via 192.168.0.1 table 5
####定义路由表5的路由策略。

###2，设置LAN 1中其他用户的路由：
    ip rule add from 192.168.2.0/24 lookup 6
####这句话的意思是让来自192.168.2.0的数据查找路由表6
    ip route add default via 192.168.1.1 table 6
####定义路由表6的路由策略。

###3，设置LAN 2的路由：
    ip rule add from 172.16.3.0/24 lookup 6
####这句话的意思是让来自LAN 2的数据查找路由表6
    ip route add default via 192.168.1.1 table 6(这条命令上面已经用过了！)
###4，刷新路由：
    ip route flush cache
###5，脚本如下：



    #!/bin/sh  
    echo 1> /proc/sys/net/ipv4/ip_forward  
    iptables -t nat -A POSTROUTING -s 192.168.2.0/24 -j MASQUERADE  
    iptables -t nat -A POSTROUTING -s 172.16.3.0/24 -j MASQUERADE  
    ip rule add from 192.168.2.25 lookup 5  
    ip rule add from 192.168.2.128 lookup 5  
    ip route add default via 192.168.0.1 table 5  
    ip rule add from 192.168.2.0/24 lookup 6  
    ip rule add from 172.16.3.0/24 lookup 6  
    ip route add default via 192.168.1.1 table 6  
    ip route flush cache  


####6，更明显一些，我们可以将上面脚本中的iptables命令行替换为下面的行
    iptables -t nat -A POSTROUTING -s 192.168.2.25/24 -j SNAT --to 192.168.0.51
    iptables -t nat -A POSTROUTING -s 192.168.2.128/24 -j SNAT --to 192.168.0.51
    iptables -t nat -A POSTROUTING -s 192.168.2.0/24 -j SNAT --to 192.168.1.51
    iptables -t nat -A POSTROUTING -s 172.16.3.0/24 -j SNAT --to 192.168.0.51
##那么新脚本如下：

 

    #!/bin/sh  
    echo 1> /proc/sys/net/ipv4/ip_forward  
    iptables -t nat -A POSTROUTING -s 192.168.2.25/24 -j SNAT --to 192.168.0.51  
    iptables -t nat -A POSTROUTING -s 192.168.2.128/24 -j SNAT --to 192.168.0.51  
    iptables -t nat -A POSTROUTING -s 192.168.2.0/24 -j SNAT --to 192.168.1.51  
    iptables -t nat -A POSTROUTING -s 172.16.3.0/24 -j SNAT --to 192.168.0.51  
    ip rule add from 192.168.2.25 lookup 5  
    ip rule add from 192.168.2.128 lookup 5  
    ip route add default via 192.168.0.1 table 5  
    ip rule add from 192.168.2.0/24 lookup 6  
    ip rule add from 172.16.3.0/24 lookup 6  
    ip route add default via 192.168.1.1 table 6  
    ip route flush cache 
