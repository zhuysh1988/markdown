## Systemd 日志系统
# 一、前言
```
昨天写了一篇文章，内容为：Systemd 常规操作与彩蛋，参考了 ArchLinux 官方文档并结合培训中的思路进行了部分修改补充。如果你懂得了基础的管理，那必然还需要做维护和审计。这时候就需要 Redhat7 中的systemd 架构下的——systemd-journald。

下有俩例子对比 init.d 和 systemd ：

service daemon ---> rsyslog ---> /var/log

systemd --> systemd-journald --> ram DB --> rsyslog -> /var/log

当 systemd 启动后，systemd-journald 也会立即启动。将日志存入RAM中，当rsyslog 启动后会读取该RAM并完成筛选分类写入目录 /var/log 。所以牵扯到DB，操作就会很舒服。
```
# 二、基础知识
```
描述RHEL7的基本系统日志（syslog）架构
进程和操作系统内核需能够为发生的事件记录日志
日志内容可用于系统审计和故障排除
默认日志存储在 /var/log 目录中
RHEL的日志系统基于 syslog 协议，许多程序使用此系统记录事件，并将齐整理到日志
文件中
RHEL7的日志系统由systemd-journald和 rsyslog 两服务组成
systemd-journald和rsyslog：
一种改进的日志管理服务，是 syslog 的补充，收集来自内核、启动过程早期阶段、标
准输出、系统日志，守护进程启动和运行期间错误的信息
将消息写入到结构化的事件日志中（数据库），默认情况下重启后删除
syslog 的信息也可以由 systemd-journald 转发到 rsyslog 中进一步处理
默认情况下，systemd 的日志保存在 /run/log/journal 中，系统重启就会清除，这是RHEL7的新特性。通过新建 /var/log/journal 目录，日志会自动记录到这个目录中，并永久存储。
rsyslog 服务随后根据优先级排列日志信息，将它们写入到 /var/log目录中永久保存
```

# 三、常规操作
```
systemd提供了自己的日志系统（logging system），称为 journal。使用 systemd 日志，无需额外安装日志服务（syslog）。读取日志的命令：

# journalctl 
​ 重要：显示所有的日志信息，notice或warning以粗体显示，红色显示error级别以上的信息
```
# 显示最后行数的日志：
```
# journalctl -n
```
# 显示最详细信息：
```
# journalctl -f
​ 提示：其实它很像tailf命令，默认显示十行。随着匹配日志的增长而持续输出。
```
# 只显示错误、冲突和重要告警信息
```
# journalctl -p err..alert
​ 提示：也可以使用数字表示哟。
```
# 显示指定单元的所有消息：
```
# journalctl -u netcfg
​ 重要：一般 -u 参数是 systemctl status 调用的参数之一（journalctl -l 可查看所有）

​ 提示：如果希望显示 kernel 的信息需要使用 journalctl -k 进行内核环缓存消息查询。
```
# 显示从某个时间 ( 例如 20分钟前 ) 的消息:
```
# journalctl --since "20 min ago"
# journalctl --since today
# journalctl --until YYYY-MM-DD 
```
# 显示本次启动后的所有日志：
```
# journalctl -b
不过，一般大家更关心的不是本次启动后的日志，而是上次启动时的（例如，刚刚系统崩溃了）。可以使用 -b 参数：

journalctl -b -0 显示本次启动的信息
journalctl -b -1 显示上次启动的信息
journalctl -b -2 显示上上次启动的信息
journalctl -b -2 只显示错误、冲突和重要告警信息
```

# 显示特定进程的所有消息:
```
# journalctl _PID=1
1. _COMM 显示特定程序的所有消息，例如：journalctl /usr/lib/systemd/systemd
2. _EXE 进程的可执行文件的路径
3. _PID 进程的PID
4. _UID 运行该进程用户的UID
5. _SYSTEMD_UNIT 启动该进程的 systemd 单元

​ 提示：以上筛选条件可组合使用，例如：journalctl _SYSTEMD_UNIT=sshd.service _PID=1182
```
# 显示更多输出方案：
```
# journalctl -o short|short-iso|short-percise|short-monotonic|verbose|export|json|json-pretty|json-sse|cat
```

## 四、一些其他
```
Q：你说有RAM的DB文件，在哪里？
A：文件位于 /run/log/joutmal ，下附命令。
➜  ~ cd /run/log/journal 
➜  journal ll
total 0
drwxr-s---+ 2 root systemd-journal 60 Aug 27 02:08 b30db55783924f1ea633ca636730d409
➜  b30db55783924f1ea633ca636730d409 cat system.journal 
```
```
Q：那 joutnal 有配置文件吗，有的话在哪呢？
A：有的。容量定义文件位于 /etc/systemd/journald.conf ，日志调整文件位于 /etc/logrotate.conf。
日志系统同样会进行轮转，每月触发。默认情况下，日志大小不能超过所处文件系统的10%，也不可使所处文件系统空间低于15%。在 /etc/systemd/journald.conf 可进行大小容量上的调节；而在 /etc/logrotate.conf 则定义了那些日志文件记录、怎么记录、记录多少。
```
```
Q：那你说到了日志轮询，在哪里实现呢？
A：在计划任务实现。
➜  ~ sudo cat /etc/cron.daily/logrotate
\#!/bin/sh

/usr/sbin/logrotate -s /var/lib/logrotate/logrotate.status /etc/logrotate.conf
EXITVALUE=$?
if [ $EXITVALUE != 0 ]; then
    /usr/bin/logger -t logrotate "ALERT exited abnormally with [$EXITVALUE]"
fi
exit 0
```
```
Q：在 journalctl -p 一节说可以使用数字表达，有详细吗？
A：如下。但是建议使用英文表达，因为不同发行版本可能编码有不同，而英文是标准是通用。
编码	优先级	严重性
0	emerg	系统不可用
1	alert	必须立即采取措施
2	crit	严重状况
3	err	非严重错误状况
4	warning	警告状况
5	notice	正常但重要的事件
6	info	信息性事件
7	debug	调试级别消息
```