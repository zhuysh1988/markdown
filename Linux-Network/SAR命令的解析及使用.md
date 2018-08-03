##SAR命令的解析及使用

>sar命令可以通过参数单独查看系统某个局部的使用情况

###sar 命令行的常用格式：

    sar [options] [-A] [-o file] t [n]

>在命令行中，n 和t 两个参数组合起来定义采样间隔和次数，t为采样间隔，是必须有的参数，n为采样次数，是可选的，默认值是1，-o file表示将命令结果以二进制格式存放在文件中，

####file 在此处不是关键字，是文件名。options 为命令行选项，sar命令的选项很多，下面只列出常用选项：

    -A：所有报告的总和。
    -u：CPU利用率
    -v：进程、I节点、文件和锁表状态。
    -d：硬盘使用报告。
    -r：没有使用的内存页面和硬盘块。
    -g：串口I/O的情况。
    -b：缓冲区使用情况。
    -a：文件读写情况。
    -c：系统调用情况。
    -R：进程的活动情况。
    -y：终端设备活动情况。
    -w：系统交换活动。
    -n: 记录网络使用情况

###默认监控: 
    (0) sar 5 5     //  CPU和IOWAIT统计状态 
    (1) sar -b 5 5        // IO传送速率
    (2) sar -B 5 5        // 页交换速率
    (3) sar -c 5 5        // 进程创建的速率
    (4) sar -d 5 5        // 块设备的活跃信息
    (5) sar -n DEV 5 5    // 网路设备的状态信息
    (6) sar -n SOCK 5 5   // SOCK的使用情况
    (7) sar -n ALL 5 5    // 所有的网络状态信息
    (8) sar -P ALL 5 5    // 每颗CPU的使用状态信息和IOWAIT统计状态 
    (9) sar -q 5 5        // 队列的长度（等待运行的进程数）和负载的状态
    (10) sar -r 5 5       // 内存和swap空间使用情况
    (11) sar -R 5 5       // 内存的统计信息（内存页的分配和释放、系统每秒作为BUFFER使用内存页、每秒被cache到的内存页）
    (12) sar -u 5 5       // CPU的使用情况和IOWAIT信息（同默认监控）
    (13) sar -v 5 5       // inode, file and other kernel tablesd的状态信息
    (14) sar -w 5 5       // 每秒上下文交换的数目
    (15) sar -W 5 5       // SWAP交换的统计信息(监控状态同iostat 的si so)
    (16) sar -x 2906 5 5  // 显示指定进程(2906)的统计信息，信息包括：进程造成的错误、用户级和系统级用户CPU的占用情况、运行在哪颗CPU上
    (17) sar -y 5 5       // TTY设备的活动状态
    (18) 将输出到文件(-o)和读取记录信息(-f)

###例1：
    oracle@oracle [/home/Oracle] sar -u 1 0 -e 16:00:00 >data.txt   
    每隔1秒记录CPU的使用情况，直到15点，数据将保存到data.txt文件中。(-e 参数表示结束时间，注意时间格式：必须为hh:mm:ss格式)

    Linux 2.6.18-194.el5 (oracle)   10/11/2011

    02:20:28 PM       CPU     %user     %nice   %system   %iowait    %steal     %idle
    02:20:29 PM       all      0.00      0.00      0.00      0.00      0.00    100.00
    02:20:30 PM       all      0.00      0.00      0.00      0.00      0.00    100.00
    02:20:31 PM       all      0.00      0.00      0.00      0.00      0.00    100.00
    02:20:32 PM       all      0.00      0.00      0.00      0.00      0.00    100.00
    02:20:33 PM       all      0.00      0.00      0.00      0.00      0.00    100.00
    02:20:34 PM       all      0.00      0.00      0.25      0.00      0.00     99.75
    02:20:35 PM       all      0.00      0.00      0.00      0.00      0.00    100.00
    02:20:36 PM       all      0.00      0.00      0.00      0.00      0.00    100.00
    02:20:37 PM       all      0.25      0.00      0.00      0.00      0.00     99.75
    02:20:38 PM       all      0.00      0.00      0.00      0.00      0.00    100.00
    Average:          all      0.02      0.00      0.02      0.00      0.00     99.95

#####在不使用参数的情况下，系统默认打印CPU使用情况

    %user：     CPU处在用户模式下的时间百分比。
    %system：CPU处在系统模式下的时间百分比。
    %iowait：   CPU等待输入输出完成时间的百分比。
    %idle：       CPU空闲时间百分比。
>在所有的显示中，我们应主要注意%iowait和%idle，%iowait的值过高，表示硬盘存在I/O瓶颈，%idle值高，表示CPU较空闲，如果%idle值高但系统响应慢时，有可能是CPU等待分配内存，此时应加大内存容量。%idle值如果持续低于10，那么系统的CPU处理能力相对较低，表明系统中最需要解决的资源是CPU。

>在多CPU Linux系统中，sar命令也可以为每个CPU分解该信息，
###采用如下命令：sar -u -P ALL 5 5

    oracle@oracle [/home/oracle] sar -u -P ALL 5 2
    Linux 2.6.18-194.el5 (oracle)   10/11/2011

    02:41:20 PM       CPU     %user     %nice   %system   %iowait    %steal     %idle
    02:41:25 PM       all      0.00      0.00      0.10      0.00      0.00     99.90
    02:41:25 PM         0      0.00      0.00      0.20      0.00      0.00     99.80
    02:41:25 PM         1      0.00      0.00      0.00      0.00      0.00    100.00
    02:41:25 PM         2      0.20      0.00      0.20      0.00      0.00     99.60
    02:41:25 PM         3      0.00      0.00      0.00      0.00      0.00    100.00

    02:41:25 PM       CPU     %user     %nice   %system   %iowait    %steal     %idle
    02:41:30 PM       all      0.00      0.00      0.05      0.00      0.00     99.95
    02:41:30 PM         0      0.00      0.00      0.00      0.00      0.00    100.00
    02:41:30 PM         1      0.00      0.00      0.00      0.00      0.00    100.00
    02:41:30 PM         2      0.00      0.00      0.00      0.00      0.00    100.00
    02:41:30 PM         3      0.00      0.00      0.00      0.00      0.00    100.0


##例2： 使用命令 sar -v t n 
    oracle@oracle [/home/oracle] sar -v 30 5       //进程、I节点、文件和锁表状态
    Linux 2.6.18-194.el5 (oracle)   10/11/2011

    02:28:45 PM dentunusd   file-sz  inode-sz  super-sz %super-sz  dquot-sz %dquot-sz  rtsig-sz %rtsig-sz
    02:29:15 PM      8675      9690      7119         0      0.00         0      0.00         0      0.00
    02:29:45 PM      8676      9690      7119         0      0.00         0      0.00         0      0.00
    02:30:15 PM      8677      9690      7119         0      0.00         0      0.00         0      0.00
    02:30:45 PM      8684      9690      7126         0      0.00         0      0.00         0      0.00
    02:31:15 PM      8685      9690      7126         0      0.00         0      0.00         0      0.00
    Average:         8679      9690      7122         0      0.00         0      0.00         0      0.00

    dentunusd:在缓冲目录条目中没有使用的条目数量.
    file-nr:被系统使用的文件句柄数量.
    inode-nr:使用的索引节点数量.
    pty-nr:使用的pty数量.

##例3： 使用命令 sar -d t n   

    oracle@oracle [/home/oracle] sar -d 30 2          //查看设备使用情况
    Linux 2.6.18-194.el5 (oracle)   10/11/2011

    02:30:33 PM       DEV       tps  rd_sec/s  wr_sec/s  avgrq-sz  avgqu-sz     await     svctm     %util
    02:31:03 PM    dev8-0     47.95  12099.97     58.38    253.56      0.08      1.74      1.03      4.95
    02:31:03 PM    dev8-1      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
    02:31:03 PM    dev8-2      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
    02:31:03 PM    dev8-3     47.95  12099.97     58.38    253.56      0.08      1.74      1.03      4.95

    02:31:03 PM       DEV       tps  rd_sec/s  wr_sec/s  avgrq-sz  avgqu-sz     await     svctm     %util
    02:31:33 PM    dev8-0     38.67   9648.00     62.93    251.14      0.07      1.75      1.01      3.89
    02:31:33 PM    dev8-1      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
    02:31:33 PM    dev8-2      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
    02:31:33 PM    dev8-3     38.67   9648.00     62.93    251.14      0.07      1.75      1.01      3.89

    DEV            磁盘设备
    用参数-p可以打印出sda,hdc等磁盘设备名称,如果不用参数-p,设备节点则有可能是dev8-0,dev22-0
    tps:每秒从物理磁盘I/O的次数.多个逻辑请求会被合并为一个I/O磁盘请求,一次传输的大小是不确定的.
    rd_sec/s:每秒读扇区的次数.
    wr_sec/s:每秒写扇区的次数.
    avgrq-sz:平均每次设备I/O操作的数据大小(扇区).
    avgqu-sz:磁盘请求队列的平均长度.
    await:从请求磁盘操作到系统完成处理,每次请求的平均消耗时间,包括请求队列等待时间,单位是毫秒(1秒=1000毫秒).
    svctm:系统处理每次请求的平均时间,不包括在请求队列中消耗的时间.
    %util:I/O请求占CPU的百分比,比率越大,说明越饱


##例4： 使用命令 sar -n t n 

    oracle@oracle [/home/oracle] sar -n ALL 5 2
    Linux 2.6.18-194.el5 (oracle)   10/11/2011

    02:52:49 PM     IFACE   rxpck/s   txpck/s   rxbyt/s   txbyt/s   rxcmp/s   txcmp/ s  rxmcst/s
    02:52:54 PM        lo      0.00      0.00      0.00      0.00      0.00      0.00      0.00
    02:52:54 PM      eth0    127.15    112.57  38894.41  20819.16      0.00      0.00      0.00
    02:52:54 PM      eth1      0.00      0.00      0.00      0.00      0.00      0.00      0.00
    02:52:54 PM      sit0      0.00      0.00      0.00      0.00      0.00      0.00      0.00

    02:52:49 PM     IFACE   rxerr/s   txerr/s    coll/s  rxdrop/s  txdrop/s  txcarr/s  rxfram/s  rxfifo/s  txfifo/s
    02:52:54 PM        lo      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
    02:52:54 PM      eth0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
    02:52:54 PM      eth1      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
    02:52:54 PM      sit0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00

    02:52:49 PM    call/s retrans/s    read/s   write/s  access/s  getatt/s
    02:52:54 PM      0.00      0.00      0.00      0.00      0.00      0.00

    02:52:49 PM   scall/s badcall/s  packet/s     udp/s     tcp/s     hit/s    miss/s   sread/s  swrite/s saccess/s sgetatt/s
    02:52:54 PM      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00

    02:52:49 PM    totsck    tcpsck    udpsck    rawsck   ip-frag
    02:52:54 PM       274        99        41         0         0

    02:52:54 PM     IFACE   rxpck/s   txpck/s   rxbyt/s   txbyt/s   rxcmp/s   txcmp/s  rxmcst/s
    02:52:59 PM        lo      0.40      0.40     20.00     20.00      0.00      0.00      0.00
    02:52:59 PM      eth0    139.00    120.60  47988.20  22587.00      0.00      0.00      0.00
    02:52:59 PM      eth1      0.00      0.00      0.00      0.00      0.00      0.00      0.00
    02:52:59 PM      sit0      0.00      0.00      0.00      0.00      0.00      0.00      0.00

    02:52:54 PM     IFACE   rxerr/s   txerr/s    coll/s  rxdrop/s  txdrop/s  txcarr/ s  rxfram/s  rxfifo/s  txfifo/s
    02:52:59 PM        lo      0.00      0.00      0.00      0.00      0.00      0.0 0      0.00      0.00      0.00
    02:52:59 PM      eth0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
    02:52:59 PM      eth1      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
    02:52:59 PM      sit0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00

    02:52:54 PM    call/s retrans/s    read/s   write/s  access/s  getatt/s
    02:52:59 PM      0.00      0.00      0.00      0.00      0.00      0.00

    02:52:54 PM   scall/s badcall/s  packet/s     udp/s     tcp/s     hit/s    miss/s   sread/s  swrite/s saccess/s sgetatt/s
    02:52:59 PM      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00

    02:52:54 PM    totsck    tcpsck    udpsck    rawsck   ip-frag
    02:52:59 PM       274        99        41         0         0

    Average:        IFACE   rxpck/s   txpck/s   rxbyt/s   txbyt/s   rxcmp/s   txcmp/ s  rxmcst/s
    Average:           lo      0.20      0.20      9.99      9.99      0.00      0.00      0.00
    Average:         eth0    133.07    116.58  43436.76  21702.20      0.00      0.00      0.00
    Average:         eth1      0.00      0.00      0.00      0.00      0.00      0.00      0.00
    Average:         sit0      0.00      0.00      0.00      0.00      0.00      0.00      0.00

    Average:        IFACE   rxerr/s   txerr/s    coll/s  rxdrop/s  txdrop/s  txcarr/s  rxfram/s  rxfifo/s  txfifo/s
    Average:           lo      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
    Average:         eth0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
    Average:         eth1      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
    Average:         sit0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00

    Average:       call/s retrans/s    read/s   write/s  access/s  getatt/s
    Average:         0.00      0.00      0.00      0.00      0.00      0.00

    Average:      scall/s badcall/s  packet/s     udp/s     tcp/s     hit/s    miss/s   sread/s  swrite/s saccess/s sgetatt/s
    Average:         0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00

    Average:       totsck    tcpsck    udpsck    rawsck   ip-frag
    Average:          274        99        41         0         0

>sar提供四种不同的语法选项来显示网络信息。-n选项使用四个不同的开关：DEV、EDEV、SOCK和FULL。DEV显示网络接口信 息，EDEV显示关于网络错误的统计数据，SOCK显示套接字信息，

>FULL显示所有三个开关。它们可以单独或者一起使用。          

    字段          说明 
    IFACE        LAN接口 
    rxpck/s      每秒钟接收的数据包
    txpck/s      每秒钟发送的数据包
    rxbyt/s       每秒钟接收的字节数
    txbyt/s       每秒钟发送的字节数
    rxcmp/s    每秒钟接收的压缩数据包
    txcmp/s    每秒钟发送的压缩数据包
    rxmcst/s   每秒钟接收的多播数据包

    后面的只针对每一个命令做解释，不做测试

##例5：   sar -r 5 5       // 内存和swap空间使用情况
    kbmemfree:这个值和free命令中的free值基本一致,所以它不包括buffer和cache的空间.
    kbmemused:这个值和free命令中的used值基本一致,所以它包括buffer和cache的空间.
    %memused:这个值是kbmemused和内存总量(不包括swap)的一个百分比.
    kbbuffers和kbcached:这两个值就是free命令中的buffer和cache.
    kbcommit:保证当前系统所需要的内存,即为了确保不溢出而需要的内存(RAM+swap).
    %commit:这个值是kbcommit与内存总量(包括swap)的一个百分比.

##例6：   sar -B 5 5        // 页交换速率
    pgpgin/s:表示每秒从磁盘或SWAP置换到内存的字节数(KB)
    pgpgout/s:表示每秒从内存置换到磁盘或SWAP的字节数(KB)
    fault/s:每秒钟系统产生的缺页数,即主缺页与次缺页之和(major + minor)
    majflt/s:每秒钟产生的主缺页数.
    pgfree/s:每秒被放入空闲队列中的页个数
    pgscank/s:每秒被kswapd扫描的页个数
    pgscand/s:每秒直接被扫描的页个数
    pgsteal/s:每秒钟从cache中被清除来满足内存需要的页个数
    %vmeff:每秒清除的页(pgsteal)占总扫描页(pgscank+pgscand)的百分比

##例7： sar -q 5 5        // 队列的长度（等待运行的进程数）和负载的状态
    runq-sz:处于运行或就绪的进程数量
    plist-sz:现在进程的总数(包括线程).
    ldavg-1:最近一分钟的负载.
    ldavg-5:最近五分钟的负载.
    ldavg-15:最近十分钟的负载.
    平均负载和队列的数据来源于/proc/loadavg

##例8： sar -n NFS 5 5  //NFS客户端的监控
    call/s:每秒成功的RPC调用都会使call/s的值增长,比如对NFS的一次读/写.
    retrans/s:每秒重传的RPC次数,比如因为服务器的问题,产生timeout,这时客户端需要重新传输.
    read/s:每秒从NFS服务端读取的次数.
    write/s:每秒写入到NFS服务端的次数.
    access/s:每秒访问NFS的次数,比如从NFS服务端COPY文件.
    getatt/s:每秒获取NFS服务端文件属性的次数,比如ls -l /NFSSERVER/,如果NFSSERVER有300个文件,将产生300次这样的请求.

##例9： sar -b 5 5        // IO传送速率
    tps:每秒从物理磁盘I/O的次数.多个逻辑请求会被合并为一个I/O磁盘请求,一次传输的大小是不确定的.
    rtps:每秒的读请求数
    wtps:每秒的写请求数
    bread/s:每秒读磁盘的数据块数(in blocks  1 block = 512B, 2.4以后内核)
    bwrtn/s:每秒写磁盘的数据块数(in blocks  1 block = 512B, 2.4以后内核)
    一般情况下tps=(rtps+wtps)


>sar也可以监控非实时数据，通过cron周期的运行到指定目录下
##例如:我们想查看本月27日,从0点到23点的内存资源.
    sa27就是本月27日,指定具体的时间可以通过-s(start)和-e(end)来指定.
    sar -f /var/log/sa/sa27 -s 00:00:00 -e 23:00:00 -r
