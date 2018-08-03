##Linux NetHogs监控工具介绍

###NetHogs介绍

>NetHogs是一款开源、免费的，终端下的网络流量监控工具，它可监控Linux的进程或应用程序的网络流量。NetHogs只能实时监控进程的网络带宽占用情况。NetHogs支持IPv4和IPv6协议，支持本地网卡以及PPP链接。

###官方介绍如下：

>NetHogs is a small 'net top' tool. Instead of breaking the traffic down per protocol or per subnet, like most tools do, it groups bandwidth by process. NetHogs does not rely on a special kernel module to be loaded. If there's suddenly a lot of network traffic, you can fire up NetHogs and immediately see which PID is causing this. This makes it easy to indentify programs that have gone wild and are suddenly taking up your bandwidth.

 


###Ubuntu下NetHogs安装

    sudo apt-get install nethogs

###ReadHat下NetHogs安装

    [root@localhost tmp]# rpm -ivh nethogs-0.8.0-1.el6.x86_64.rpm 
    warning: nethogs-0.8.0-1.el6.x86_64.rpm: Header V3 RSA/SHA256 Signature, key ID 0608b895: NOKEY
    Preparing...                ########################################### [100%]
       1:nethogs                ########################################### [100%]


####NetHogs提供交互式控制指令：

    m : Cycle between display modes (kb/s, kb, b, mb) 切换网速显示单位

    r : Sort by received. 按接收流量排序

    s : Sort by sent. 按发送流量排序

    q : Quit and return to the shell prompt. 退出NetHogs命令工具


 

####NetHogs 命令行参数

####常用的参数：

    -d delay for refresh rate. 数据刷新时间 如nethogs -d 1 就是每秒刷新一次

    -h display available commands usage. 显示命名帮助、使用信息

    -p sniff in promiscious mode (not recommended).

    -t tracemode.

    -V prints Version info.

####演示例子：

    #5秒刷新一次数据

    nethogs -d 5

    #监控网卡eth0数据

    nethogs eth0

    #同时监视eth0和eth1接口

    nethogs eth0 eth1


    #将监控日志写入日志文件
    nethogs >>test.log
