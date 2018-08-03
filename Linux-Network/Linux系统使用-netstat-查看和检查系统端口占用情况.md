##Linux系统使用 netstat 查看和检查系统端口占用情况
 

###使用 netstat 来查看端口占用情况

>在 Linux 使用过程中，如果需要了解当前系统开放了哪些端口，及这些端口的关联进程和用户，可以通过 netstat 命令进行查询。

####netstat 命令各参数说明如下：

    -t：指明显示 TCP 端口

    -u：指明显示 UDP 端口

    -l：仅显示监听套接字

    -p：显示进程标识符和程序名称，每一个套接字/端口都属于一个程序。

    -n：不进行 DNS 轮询，显示 IP （可以加速操作）

####常用的 netstat 命令组合

    netstat -na
    该命令将显示所有活动的网络连接。

    同时，还可以结合使用 grep、wc、sort 等 linux 命令来分析系统中连接情况，查看连接数状况，判断服务器是否被攻击。

     

    netstat -an | grep :80 | sort
    显示所有 80 端口的网络连接并排序。这里的 80 端口是 http 端口，所以可以用来监控 web 服务。如果看到同一个 IP 有大量连接，则判定该 IP 疑似存在单点流量攻击行为。

     

    netstat -n -p|grep SYN_REC | wc -l
    统计当前服务器有多少个活动的 SYNC_REC 连接数。正常来说这个值很小（小于 5）。

    说明：当有 DDos 攻击或时，该值可能会非常高。但有些并发很高的服务器，该值也确实很高，因此该很高并不能说明一定是被攻击所致。

     

    netstat -n -p | grep SYN_REC | sort -u
    列出所有连接过的 IP 地址。

     

    netstat -n -p | grep SYN_REC | awk '{print $5}' | awk -F: '{print $1}'
    列出所有发送 SYN_REC 连接节点的 IP 地址。

     

    netstat -ntu | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n
    计算每个主机连接到本机的连接数。

     

    netstat -anp |grep 'tcp|udp' | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n
    列出所有连接到本机的 UDP 或者 TCP 连接的 IP 数量。

     

    netstat -ntu | grep ESTAB | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -nr
    检查 ESTABLISHED 连接并且列出每个 IP 地址的连接数量。

     

    netstat -plan|grep :80|awk {'print $5'}|cut -d: -f 1|sort|uniq -c|sort -nk 1
    列出所有连接到本机 80 端口的 IP 地址及其连接数。80 端口一般是用来处理 HTTP 网页请求。

     

    netstat -antp | awk '$4 ~ /:80$/ {print $4" "$5}' | awk '{print $2}'|awk -F : {'print $1'} | uniq -c | sort -nr | head -n 10
    显示连接到 80 端口连接数排名前 10 的 IP，并显示每个 IP 的连接数。如果看到同一个 IP 有大量连接，则判定该 IP 疑似存在单点流量攻击行为。

    如何停止端口占用

    可以通过如下步骤来停止端口占用：

    查找端口占用的进程
    使用如下命令来查看（以查看9000端口为例）：

    netstat -antp | grep 9000
     

    可以看到 PID 为 1070 的进程占用了这个端口。

    停止相应进程即可。
