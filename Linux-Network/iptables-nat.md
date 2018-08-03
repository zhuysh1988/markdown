##Linux系统中使用iptables实现nat地址转换

###iptables nat 原理
>同filter表一样，nat表也有三条缺省的"链"(chains)：

###PREROUTING:目的DNAT规则

        把从外来的访问重定向到其他的机子上，比如内部SERVER，或者DMZ。
        因为路由时只检查数据包的目的ip地址，所以必须在路由之前就进行目的PREROUTING DNAT;
        系统先PREROUTING DNAT翻译——>再过滤（FORWARD）——>最后路由。
        路由和过滤（FORWARD)中match 的目的地址，都是针对被PREROUTING DNAT之后的。
###POSTROUTING:源SNAT规则

        在路由以后在执行该链中的规则。
        系统先路由——>再过滤（FORWARD)——>最后才进行POSTROUTING SNAT地址翻译
        其match 源地址是翻译前的。
    
###OUTPUT:定义对本地产生的数据包的目的NAT规则

####内网访问外网 -J SNAT

####-j SNAT

        -j SNAT：源网络地址转换，SNAT就是重写包的源IP地址
        SNAT 只能用在nat表的POSTROUTING链里
        only valid in the nat table, in the POSTROUTING chain.
        -j SNAT --to-source ipaddr[-ipaddr][:port-port]
        ipaddr:
        a single new source IP address
        range of IP addresses
        or you can add several --to-source options. a simple round-robin takes place between these adresses.
        port range(only valid if the rule also specifies -p tcp or -p udp)
        If no port range is specified, then source ports below 512 will be
        mapped to other ports below 512
####-j MASQUERADE
#####用于外网口public地址是DHCP动态获取的（如ADSL）

    iptables -t nat -A POSTROUTING –o eth1 –s 192.168.1.0/24 –j MASQUERADE
    iptables -t nat -A POSTROUTING -o ppp0 -j MASQUERADE MASQUERADE --to-ports port[-port]
    only valid if the rule also specifies -p tcp or -p udp.
####固定public 地址（外网接口地址）的最基本内访外SNAT

    iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -o eth0 -j SNAT --to 你的eth0地址 多个内网段SNAT,就是多条SNAT语句即可
    iptables -t nat -A POSTROUTING -s 192.168.100.0/24 -o eth0 -j MASQUERADE
    iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -o eth0 -j MASQUERADE
    iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -o eth0 -j MASQUERADE 非外网口地址为NAT用，必须先要绑定到接口上，如eth0 :1,eth0 :2
####外网访问内网 –J DNAT

        DNAT
        only valid in PREROUTING
        --to-destination ipaddr[-ipaddr][:port-port]
        DNAT：目的网络地址转换，重写包的目的IP地址
###典型的DNAT的例子

        外部接口ip：210.83.2.206
        内部接口ip：192.168.1.1 ftp服务器　：　ip 192.168.1.3
        web服务器　：　ip 192.168.1.4
        iptables -t nat -A PREROUTING -d 210.83.2.206 -p tcp --dport 21 -j DNAT --to 192.168.1.3
        iptables -t nat -A PREROUTING -d 210.83.2.206 -p tcp --dport 80 -j DNAT --to 192.168.1.4 DNAT静态映射
#####IPTABLES没有CISCO那种static map
#####DNAT用于内部SERVER的load-balance（即CISCO的rotery）

        iptables –t nat –A PREROUTING –d 219.142.217.161 –j DNAT --to-destination 192.168.1.24-192.168.1.25 DNAT 带端口映射(改变SERVER的端口)
#####一个FTP SERVER从内部192.168.100.125:21映射到216.94.87.37:2121的例子

    iptables -t nat -A PREROUTING -p tcp -d 216.94.87.37 --dport 2121 -j DNAT --to-destination 192.168.100.125:21 
    通常外网DNAT访问内网SERVER，内网SERV ER回包的源地址是经过另一个单独的SNAT进程的。而不属于DNAT STATIC进程的一部分。
    这样对于P-t-P的网络应用，就必须另设一个和DNAT相适应的SNAT。
    对于穿过NAT，被NAT映射改变端口号的应用，也必须用一个单独的SNAT对回包的端口进行映射
    iptables -t nat -A POSTROUTING -p tcp -s 192.168.100.125 --sport 21 -j SNAT --to-source 216.94.87.37:2121 不这样做的话，FTP SERVER会返回21到外网的客户机，外网用户发出一个to 2121的FTP request,收到一个from 21的，会不认
##上面的好象不必，做过实验了：

        /sbin/iptables -t nat -A POSTROUTING -s 10.4.0.0/16 -o $WAN_INT -j SNAT --to 124.126.86.137
        /sbin/iptables -t nat -A PREROUTING -d 124.126.86.138 -p tcp --dport 2022 -j DNAT --to-destination 10.4.3.150:22 DNAT照样要做RULE，DNAT只是翻译，仍要做ACCEPT。（而且注意是FORWARD，不是INPUT）
        /sbin/iptables -A FORWARD -i $WAN_INT -m state --state NEW -p tcp --dport 9000 -j ACCEPT
        /sbin/iptables -A FORWARD -i $WAN_INT -m state --state NEW -p tcp --dport 9001 -j ACCEPT
        /sbin/iptables -A FORWARD -i $WAN_INT -m state --state NEW -p tcp --dport 22 -j ACCEPT ##########NAT CHAIN###############
        /sbin/iptables -t nat -A POSTROUTING -s 10.4.0.0/16 -o $WAN_INT -j SNAT --to 124.126.86.137
        /sbin/iptables -t nat -A PREROUTING -d 124.126.86.138 -p tcp --dport 2022 -j DNAT --to-destination 10.4.3.150:22
        /sbin/iptables -t nat -A PREROUTING -d 124.126.86.138 -p tcp --dport 9001 -j DNAT --to-destination 10.4.3.150:9001
        /sbin/iptables -t nat -A PREROUTING -d 124.126.86.138 -p tcp --dport 9000 -j DNAT --to-destination 10.4.3.150:9000
        DNAT的FORWARD RULE总是出错，原来：DNAT RULE是在PREROUTING语句之后执行的，即DNAT RULE要match翻译过来的新接口号
        一开始按翻译前的原始接口做RULE，发觉9000和9001都通过，但2022总通不过
        /sbin/iptables -A FORWARD -i $WAN_INT -m state --state NEW -p tcp --dport 9000 -j ACCEPT
        /sbin/iptables -A FORWARD -i $WAN_INT -m state --state NEW -p tcp --dport 9001 -j ACCEPT
        /sbin/iptables -A FORWARD -i $WAN_INT -m state --state NEW -p tcp --dport 2022 -j ACCEPT ##########NAT CHAIN###############
        /sbin/iptables -t nat -A POSTROUTING -s 10.4.0.0/16 -o $WAN_INT -j SNAT --to 124.126.86.137
        /sbin/iptables -t nat -A PREROUTING -d 124.126.86.138 -p tcp --dport 2022 -j DNAT --to-destination 10.4.3.150:22
        /sbin/iptables -t nat -A PREROUTING -d 124.126.86.138 -p tcp --dport 9001 -j DNAT --to-destination 10.4.3.150:9001
        /sbin/iptables -t nat -A PREROUTING -d 124.126.86.138 -p tcp --dport 9000 -j DNAT --to-destination 10.4.3.150:9000
        后来发现原来9000和9001都是端口不变的翻译，只有2022是由2022到22的翻译。
        而FORWARD是在PREROUTING执行后执行的，此时2022已经被翻译成22了，当然不匹配2022那个rule了
        改正：
        /sbin/iptables -A FORWARD -i $WAN_INT -m state --state NEW -p tcp --dport 9000 -j ACCEPT
        /sbin/iptables -A FORWARD -i $WAN_INT -m state --state NEW -p tcp --dport 9001 -j ACCEPT
        /sbin/iptables -A FORWARD -i $WAN_INT -m state --state NEW -p tcp --dport 22 -j ACCEPT ==============================NAT troubleshooting===================================
###-i ，-o 参数在NAT中的用途

    对于PREROUTING链，只能用-i,通常是外网口
    对于POSTROUTING和OUTPUT，只能用-o，通常也是外网口

>linux iptables通常都用外网口地址做NAT public地址
用非外网口的同网段地址做DNAT public地址，失败
失败原因是，非外网口地址为DNAT用，必须要绑定到接口上，如eth0 :1,eth0 :2

###连续public 地址SNAT （也要先绑定到子接口上eth0:x）

        iptables –t nat –A POSTROUTING –s 192.168.1.0 –j SNAT --to-source 219.142.217.161-219.142.217.166 一段连续的地址，这样可以实现负载平衡。每个流会被随机分配一个IP。
>不存在所谓的PAT。理由：没有PAT相关的RFC
PAT是CISCO自己的概念
Linux实现的就是完整的NAT和NAPT（可以进行端口替换，参见RFC3022）
但是端口并没有bind到本地协议栈上。所以不受本地端口资源65535的限制。

###源端口必须>1024

        iptables –t nat –A POSTROUTING -p tcp,udp –s 192.168.1.0 –j SNAT --to-source 219.142.217.161:1024-32000 这样包的源端口就被限制在1024-32000了
###端口转换限定

    iptables –A POSTROUTING –o eth1 –s 192.168.1.0/24 –j MASQUERADE --to-ports 1024-30000 只转换1024以上低于30000的源端口
###对于”内网访问内网SERVER在外网的地址”的特殊处理

        o 网内客户机10.4.3.119发起一个访问请求给映射后的地址124.126.86.138（10.4.3.150）
        o 防火墙收到这个向124.126.86.138请求后根据策略表匹配发现是一个对内部服务器10.4.3.150映射，防火墙会通过纯路由的方式将数据包转发给服务器 10.4.3.150
        o 服务器10.4.3.150收到请求后，发现源地址为10.4.3.119的客户机发来了一个请求，并且这台主机与自己在同一个网段内，于是直接将回应包SYN+ACK发送给主机10.4.3.119（就不再经过FW）
        o 10.4.3.119收到这个包后会感觉很奇怪，因为它从来就没有给10.4.3.150发送过连接请求报文（他只给124.126.86.138)发送过，所以就会将回应报文丢弃
###解决：增加一个朝向内部网10.4.3.150访问的POSTROUTING SNAT

        /sbin/iptables -t nat -A POSTROUTING -s 10.4.0.0/16 -o $WAN_INT -j SNAT --to 124.126.86.137
        /sbin/iptables -t nat -A PREROUTING -d 124.126.86.138 -p tcp --dport 2022 -j DNAT --to-destination 10.4.3.150:22
        /sbin/iptables -t nat -A PREROUTING -d 124.126.86.138 -p tcp --dport 9001 -j DNAT --to-destination 10.4.3.150:9001
        /sbin/iptables -t nat -A PREROUTING -d 124.126.86.138 -p tcp --dport 9000 -j DNAT --to-destination 10.4.3.150:9000
        /sbin/iptables -t nat -A POSTROUTING -d 10.4.3.150 -j SNAT --to 10.4.0.198
>把发往内部server ip 10.4.3.150的包的源地址改成FW内网口地址10.4.0.198
这样就能从内部访问内部SERVER的外部地址 上例的另一种情况：禁止server在内网访问他自己在外网的公有地址

        iptables -t nat -A PREROUTING -d 219.142.217.161 -j DNAT --to 192.168.1.24
        iptables -t nat -A PREROUTING -d 210.83.2.206 -s ! 192.168.1.24 -p tcp --dport 21 -j DNAT --to 192.168.1.24
        -s !内网SERVER地址 DNAT --to 内网server地址
###NAT表删除 iptables -t nat -F
