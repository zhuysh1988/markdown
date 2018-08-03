最近在优化nginx高并发，开始一直不明白这个awk什么什么意思，看到这个帖子不错，就分享了。

ss -an | awk '/^tcp/ {++state[$2]} END {for(key in state) print key,"\t",state[key]}'


netstat -n | awk '/^tcp/ {++state[$NF]} END {for(key in state) print key,"\t",state[key]}'
会得到类似下面的结果，具体数字会有所不同：

LAST_ACK         1
SYN_RECV         14
ESTABLISHED      79
FIN_WAIT1        28
FIN_WAIT2        3
CLOSING          5
TIME_WAIT        1669

也就是说，这条命令可以把当前系统的网络连接状态分类汇总。

状态：描述
CLOSED：无连接是活动的或正在进行
LISTEN：服务器在等待进入呼叫
SYN_RECV：一个连接请求已经到达，等待确认
SYN_SENT：应用已经开始，打开一个连接
ESTABLISHED：正常数据传输状态
FIN_WAIT1：应用说它已经完成
FIN_WAIT2：另一边已同意释放
ITMED_WAIT：等待所有分组死掉
CLOSING：两边同时尝试关闭
TIME_WAIT：另一边已初始化一个释放
LAST_ACK：等待所有分组死掉

下面解释一下为啥要这样写：

一个简单的管道符连接了netstat和awk命令。

------------------------------------------------------------------

先来看看netstat：

netstat -n

Active Internet connections (w/o servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State
tcp        0      0 123.123.123.123:80      234.234.234.234:12345   TIME_WAIT

你实际执行这条命令的时候，可能会得到成千上万条类似上面的记录，不过我们就拿其中的一条就足够了。

------------------------------------------------------------------

再来看看awk：

/^tcp/
滤出tcp开头的记录，屏蔽udp, socket等无关记录。

state[]相当于定义了一个名叫state的数组

NF
表示记录的字段数，如上所示的记录，NF等于6

$NF
表示某个字段的值，如上所示的记录，$NF也就是$6，表示第6个字段的值，也就是TIME_WAIT

state[$NF]表示数组元素的值，如上所示的记录，就是state[TIME_WAIT]状态的连接数

++state[$NF]表示把某个数加一，如上所示的记录，就是把state[TIME_WAIT]状态的连接数加一

END
表示在最后阶段要执行的命令

for(key in state)
遍历数组

print key,"\t",state[key]打印数组的键和值，中间用\t制表符分割，美化一下。 


netstat -n | awk '/^tcp/ {++state[$NF]} END {for(key in state) print key,"\t",state[key]}'

状态：描述
CLOSED：无连接是活动的或正在进行
LISTEN：服务器在等待进入呼叫
SYN_RECV：一个连接请求已经到达，等待确认
SYN_SENT：应用已经开始，打开一个连接
ESTABLISHED：正常数据传输状态
FIN_WAIT1：应用说它已经完成
FIN_WAIT2：另一边已同意释放
ITMED_WAIT：等待所有分组死掉
CLOSING：两边同时尝试关闭
TIME_WAIT：另一边已初始化一个释放
LAST_ACK：等待所有分组死掉


如发现系统存在大量TIME_WAIT状态的连接，通过调整内核参数解决，
vim /etc/sysctl.conf
编辑文件，加入以下内容：
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_fin_timeout = 30
然后执行 /sbin/sysctl -p 让参数生效。

net.ipv4.tcp_syncookies = 1 表示开启SYN cookies。当出现SYN等待队列溢出时，启用cookies来处理，可防范少量SYN攻击，默认为0，表示关闭；
net.ipv4.tcp_tw_reuse = 1 表示开启重用。允许将TIME-WAIT sockets重新用于新的TCP连接，默认为0，表示关闭；
net.ipv4.tcp_tw_recycle = 1 表示开启TCP连接中TIME-WAIT sockets的快速回收，默认为0，表示关闭。
net.ipv4.tcp_fin_timeout 修改系�默认的 TIMEOUT 时间

下面附上TIME_WAIT状态的意义：

客户端与服务器端建立TCP/IP连接后关闭SOCKET后，服务器端连接的端口
状态为TIME_WAIT

是不是所有执行主动关闭的socket都会进入TIME_WAIT状态呢？
有没有什么情况使主动关闭的socket直接进入CLOSED状态呢？

主动关闭的一方在发送最后一个 ack 后
就会进入 TIME_WAIT 状态 停留2MSL（max segment lifetime）时间
这个是TCP/IP必不可少的，也就是“解决”不了的。

也就是TCP/IP设计者本来是这么设计的
主要有两个原因
1。防止上一次连接中的包，迷路后重新出现，影响新连接
（经过2MSL，上一次连接中所有的重复包都会消失）
2。可靠的关闭TCP连接
在主动关闭方发送的最后一个 ack(fin) ，有可能丢失，这时被动方会重新发
fin, 如果这时主动方处于 CLOSED 状态 ，就会响应 rst 而不是 ack。所以
主动方要处于 TIME_WAIT 状态，而不能是 CLOSED 。

TIME_WAIT 并不会占用很大资源的，除非受到攻击。

还有，如果一方 send 或 recv 超时，就会直接进入 CLOSED 状态
来源：http://www.51testing.com/?uid-11 ... space-itemid-219725






系统连接状态篇：
1.查看TCP连接状态
netstat -nat |awk '{print $6}'|sort|uniq -c|sort -rn
netstat -n |awk '/^tcp/ {++S[$NF]};END {for(a in S) print a, S[a]}'
netstat -n |
awk '/^tcp/ {++state[$NF]} END {for(key in state) print 
/^tcp/
滤出tcp开头的记录，屏蔽udp,
socket等无关记录。state[]
相当于定义了一个名叫state的数组NF
表示记录的字段数，如上所示的记录，NF等于6$NF
表示某个字段的值，如上所示的记录，$NF也就是$6，表示第6个字段的值，也就是TIME_WAITstate[$NF]
表示数组元素的值，如上所示的记录，就是state[TIME_WAIT]状态的连接数++state[$NF]
表示把某个数加一，如上所示的记录，就是把state[TIME_WAIT]状态的连接数加一END
表示在最后阶段要执行的命令for(key in
state)
遍历数组print
key,"\t",state[key]
打印数组的键和值，中间用\t制表符分割，美化一下。netstat -n |awk '/^tcp/ {++state[$NF]}; END {for(key in state) print key,"\t",state[key]}'netstat -n |awk '/^tcp/ {++arr[$NF]};END {for(k in arr) print k,"\t",arr[k]}'netstat -n |awk '/^tcp/ {print $NF}'|sort|uniq -c|sort -rn
netstat -ant |awk '{print $NF}'|grep -v '[a-z]'|sort |uniq -c
netstat -ant|awk '/ip:80/{split($5,ip,":");++S[ip[1]]}END{for (a in S) print S[a],a}'|sort -n
netstat -ant|awk '/:80/{split($5,ip,":");++S[ip[1]]}END{for (a in S) print S[a],a}'|sort -rn|head -n 10awk 'BEGIN{printf ("http_code\tcount_num\n")}{COUNT[$10]++}END{for (a in COUNT) printf a"\t\t"COUNT[a]"\n"}'




2.查找请求数请20个IP（常用于查找攻来源）：
netstat -anlp|grep 80|grep tcp|awk '{print $5}'|awk -F:'{print $1}'|sort|uniq -c|sort -nr|head -n20
netstat -ant |awk '/:80/{split($5,ip,":");++A[ip[1]]}END{for(i in A) print A,i}'|sort -rn|head -n20
3.用tcpdump嗅探80端口的访问看看谁最高
tcpdump -i eth0 -tnn dst port 80-c 1000|awk -F"."'{print $1"."$2"."$3"."$4}'|sort |uniq -c |sort -nr |head -20
4.查找较多time_wait连接
netstat -n|grep TIME_WAIT|awk '{print $5}'|sort|uniq -c|sort -rn|head -n20
5.找查较多的SYN连接
netstat -an |grep SYN |awk '{print $5}'|awk -F:'{print $1}'|sort |uniq -c |sort -nr |more
6.根据端口列进程
netstat -ntlp |grep 80|awk '{print $7}'|cut -d/-f1
网站日志分析篇1（Apache）：
1.获得访问前10位的ip地址
cat access.log|awk '{print $1}'|sort|uniq -c|sort -nr|head -10cat access.log|awk '{counts[$(11)]+=1}; END {for(url in counts) print counts[url], url}'
2.访问次数最多的文件或页面,取前20
cat access.log|awk '{print $11}'|sort|uniq -c|sort -nr|head -20
3.列出传输最大的几个exe文件（分析下载站的时候常用）
cat access.log |awk '($7~/\.exe/){print $10 " " $1 " " $4 " " $7}'|sort -nr|head -20
4.列出输出大于200000byte(约200kb)的exe文件以及对应文件发生次数
cat access.log |awk '($10 > 200000 && $7~/\.exe/){print $7}'|sort -n|uniq -c|sort -nr|head -100
5.如果日志最后一列记录的是页面文件传输时间，则有列出到客户端最耗时的页面
cat access.log |awk '($7~/\.php/){print $NF " " $1 " " $4 " " $7}'|sort -nr|head -100
6.列出最最耗时的页面(超过60秒的)的以及对应页面发生次数
cat access.log |awk '($NF > 60 && $7~/\.php/){print $7}'|sort -n|uniq -c|sort -nr|head -100
7.列出传输时间超过 30 秒的文件
cat access.log |awk '($NF > 30){print $7}'|sort -n|uniq -c|sort -nr|head -20
8.统计网站流量（G)
cat access.log |awk '{sum+=$10} END {print sum/1024/1024/1024}'
9.统计404的连接
awk '($9 ~/404/)'access.log |awk '{print $9,$7}'|sort
10. 统计http status.
cat access.log |awk '{counts[$(9)]+=1}; END {for(code in counts) print code, counts[code]}'cat access.log |awk '{print $9}'|sort|uniq -c|sort -rn
11.每秒并发：
awk '{if($9~/200|30|404/)COUNT[$4]++}END{for( a in COUNT) print a,COUNT[a]}'|sort -k 2-nr|head -n10
12.带宽统计
cat apache.log |awk '{if($7~/GET/) count++}END{print "client_request="count}'cat apache.log |awk '{BYTE+=$11}END{print "client_kbyte_out="BYTE/1024"KB"}'
13.统计对象数量及对象平均大小
cat access.log |awk '{byte+=$10}END{ print byte/NR/1024,NR}'cat access.log |awk '{if($9~/200|30/)COUNT[$NF]++}END{for( a in COUNT) print a,COUNT
[a],NR,COUNT[a]/NR*100"%"}
14.取5分钟日志
if[$DATE_MINUTE !=$DATE_END_MINUTE ];then#则判断开始时间戳与结束时间戳是否相等START_LINE=`sed -n "/$DATE_MINUTE/=" $APACHE_LOG|head -n1`#如果不相等，则取出开始时间戳的行号，与结束时间戳的行号#END_LINE=`sed -n "/$DATE_END_MINUTE/=" $APACHE_LOG|tail -n1`END_LINE=`sed -n "/$DATE_END_MINUTE/=" $APACHE_LOG|head -n1`sed -n "${START_LINE},${END_LINE}p"$APACHE_LOG >$MINUTE_LOG ##通过行号，取出5分钟内的日志内容 存放到 临时文件中GET_START_TIME=`sed -n "${START_LINE}p" $APACHE_LOG|awk -F '[' '{print $2}' |awk '{print $1}'|
sed 's#/# #g'|sed 's#:# #'`#通过行号获取取出开始时间戳GET_END_TIME=`sed -n "${END_LINE}p" $APACHE_LOG|awk -F '[' '{print $2}' |awk '{print $1}'|sed
's#/# #g'|sed 's#:# #'`#通过行号获取结束时间戳
10.蜘蛛分析
查看是哪些蜘蛛在抓取内容。
/usr/sbin/tcpdump -i eth0 -l -s 0-w -dst port 80|strings |grep -i user-agent |grep -i -E 'bot|crawler|slurp|spider'
网站日分析2(Squid篇）
2.按域统计流量
zcat squid_access.log.tar.gz|awk '{print $10,$7}'|awk 'BEGIN{FS="[ /]"}{trfc[$4]+=$1}END{for
(domain in trfc){printf "%s\t%d\n",domain,trfc[domain]}}'效率更高的perl版本请到此下载:http://docs.linuxtone.org/soft/tools/tr.pl
数据库篇
1.查看数据库执行的sql
/usr/sbin/tcpdump -i eth0 -s 0-l -w -dst port 3306|strings |egrep -i 'SELECT|UPDATE|DELETE|INSERT|SET|COMMIT|ROLLBACK|CREATE|DROP|ALTER|CALL'
系统Debug分析篇
1.调试命令
strace -p pid
2.跟踪指定进程的PID
gdb -p pid
