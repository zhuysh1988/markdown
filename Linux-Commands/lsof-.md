#1、lsof 简介

#####lsof 是 Linux 下的一个非常实用的系统级的监控、诊断工具。
#####它的意思是 List Open Files，很容易你就记住了它是 “ls + of”的组合~
#####它可以用来列出被各种进程打开的文件信息，记住：linux 下 “一切皆文件”，
#####包括但不限于 pipes, sockets, directories, devices, 等等。
#####因此，使用 lsof，你可以获取任何被打开文件的各种信息。

#####只需输入 lsof 就可以生成大量的信息，因为 lsof 需要访问核心内存和各种文件，所以必须以 root 用户的身份运行它才能够充分地发挥其功能。

###lsof 的示例输出:


#####root@YLinux:~/lab 0# lsof
    
    COMMAND     PID   TID       USER   FD      TYPE     DEVICE SIZE/OFF       NODE NAME
    
    systemd       1             root  cwd       DIR        8,6     4096          2 /
    
    systemd       1             root  rtd       DIR        8,6     4096          2 /
    
    systemd       1             root  txt       REG        8,6  2273340    1834909 /usr/lib/systemd/systemd
    
    systemd       1             root  mem       REG        8,6   210473    1700647 /lib/libnss_files-2.15.s


###2、lsof 常用用法

#####2.1 监控打开的文件、设备

#####查看文件、设备被哪些进程占用

###### lsof /dev/tty1
    
    COMMAND     PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
    3
    bash       1770 jian    0u   CHR    4,1      0t0 1045 /dev/tty1
    4
    bash       1770 jian    1u   CHR    4,1      0t0 1045 /dev/tty1
    5
    bash       1770 jian    2u   CHR    4,1      0t0 1045 /dev/tty1
    6
    bash       1770 jian  255u   CHR    4,1      0t0 1045 /dev/tty1
    7
    startx     1845 jian    0u   CHR    4,1      0t0 1045 /dev/tty1
    8
    startx     1845 jian    1u   CHR    4,1      0t0 1045 /dev/tty1
    9
    ...
###2.2 监控文件系统

#####指定目录、挂载点，可以看到有哪些进程打开了其下的文件：

##### lsof /data/
    
    COMMAND   PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
    3
    bash    15983 jian  cwd    DIR    8,5     4096 8252 /data/backup
    4
    ...
#####这在 umount 某个文件系统失败时非常有用（通常会报该 FS is busy）。
#####
#####列出某个目录（挂载点 如 /home 也行）下被打开的文件：
#####

##### lsof +D /var/log/



    COMMAND   PID   USER  FD   TYPE DEVICE SIZE/OFF   NODE NAME
    4
    rsyslogd  488 syslog   1w   REG    8,1     1151 268940 /var/log/syslog
    5
    rsyslogd  488 syslog   2w   REG    8,1     2405 269616 /var/log/auth.log
    6
    console-k 144   root   9w   REG    8,1    10871 269369 /var/log/ConsoleKit/history
#####列出被指定进程名打开的文件：


##### lsof -c ssh -c init

    COMMAND    PID   USER   FD   TYPE DEVICE SIZE/OFF   NODE NAME
    04
    init         1       root  txt    REG        8,1   124704  917562 /sbin/init
    05
    init         1       root  mem    REG        8,1  1434180 1442625 /lib/i386-linux-gnu/libc-2.13.so
    06
    init         1       root  mem    REG        8,1    30684 1442694 /lib/i386-linux-gnu/librt-2.13.so
    07
    ...
    08
    ssh-agent 1528 lakshmanan    1u   CHR        1,3      0t0    4369 /dev/null
    09
    ssh-agent 1528 lakshmanan    2u   CHR        1,3      0t0    4369 /dev/null
    10
    ssh-agent 1528 lakshmanan    3u  unix 0xdf70e240      0t0   10464 /tmp/ssh-sUymKXxw1495/agent.1495
###2.3 监控进程

#####指定进程号，可以查看该进程打开的文件：

##### lsof -p 2064

    COMMAND  PID USER   FD   TYPE     DEVICE SIZE/OFF    NODE NAME
    03
    firefox 2064 jian  cwd    DIR        8,6     4096 1571780 /home/jian
    04
    firefox 2064 jian  rtd    DIR        8,6     4096       2 /
    05
    firefox 2064 jian  txt    REG        8,6    44224 1985670 /usr/lib/firefox-12.0/firefox
    06
    firefox 2064 jian  mem    REG        8,6 14707012  925361 /usr/share/fonts/chinese/msyhbd.ttf
    07
    firefox 2064 jian  mem    REG        8,6 15067744  925362 /usr/share/fonts/chinese/msyh.ttf
    08
    firefox 2064 jian  mem    REG        8,6 16791251 1701681 /usr/share/fonts/wenquanyi/wqy-zenhei.ttc
    09
    firefox 2064 jian  mem    REG       0,16 67108904   10203 /dev/shm/pulse-shm-3021850167
    10
    ...
#####当你想要杀掉某个用户所有打开的文件、设备，你可以这样：


#####kill -9 `lsof -t -u lakshmanan`
#####此处 -t 的作用是单独的列出 进程 id 这一列。




###2.4 监控网络

#####查看指定端口有哪些进程在使用（lsof -i 列出所有的打开的网络连接）：

##### lsof -i:22

    COMMAND  PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
    3
    sshd    1569 root    3u  IPv4  10303      0t0  TCP *:ssh (LISTEN)
    4
    sshd    1569 root    4u  IPv6  10305      0t0  TCP *:ssh (LISTEN)


#####列出被某个进程打开所有的网络文件：


    lsof -i -a -p 234或者

    lsof -i -a -c ssh

#####列出所有 tcp、udp 连接：

    lsof -i tcp;

    lsof -i udp;
###列出所有 NFS 文件：


    lsof -N -u lakshmanan -a
#####查看指定网口有哪些进程在使用：


### lsof -i@192.168.1.91
    2
    COMMAND     PID USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
    3
    skype      1909 jian   54u  IPv4   9116      0t0  TCP 192.168.1.91:40640->64.4.23.153:40047 (ESTABLISHED)
    4
    pidgin     1973 jian    7u  IPv4   6599      0t0  TCP 192.168.1.91:59311->hx-in-f125.1e100.net:https (ESTABLISHED)
    5
    pidgin     1973 jian   13u  IPv4   9260      0t0  TCP 192.168.1.91:54447->by2msg3010511.phx.gbl:msnp (ESTABLISHED)
    6
    ...
#3、更多使用技巧

###3.1 监控用戶

#####查看指定用戶打开的文件（lsof -u ^lakshmanan 可以排除某用户）：

##### lsof -u messagebus
    2
    COMMAND    PID       USER   FD   TYPE     DEVICE SIZE/OFF    NODE NAME
    3
    dbus-daem 1805 messagebus  cwd    DIR        8,6     4096       2 /
    4
    dbus-daem 1805 messagebus  rtd    DIR        8,6     4096       2 /
    5
    dbus-daem 1805 messagebus  txt    REG        8,6  1235361 1834948 /usr/bin/dbus-daemon
    6
    dbus-daem 1805 messagebus  mem    REG        8,6   210473 1700647 /lib/libnss_files-2.15.so
    7
    dbus-daem 1805 messagebus  mem    REG        8,6   190145 1700642 /lib/libnss_nis-2.15.so
    8
    dbus-daem 1805 messagebus  mem    REG        8,6   490366 1700636 /lib/libnsl-2.15.so
    9
    ...
###3.2 监控应用程序

查看指定程序打开的文件：

##### lsof -c firefox
    2
    COMMAND  PID USER   FD   TYPE     DEVICE SIZE/OFF    NODE NAME
    3
    firefox 2064 jian  cwd    DIR        8,6     4096 1571780 /home/jian
    4
    firefox 2064 jian  rtd    DIR        8,6     4096       2 /
    5
    firefox 2064 jian  txt    REG        8,6    44224 1985670 /usr/lib/firefox-12.0/firefox
    6
    firefox 2064 jian  mem    REG        8,6 14707012  925361 /usr/share/fonts/chinese/msyhbd.ttf
    7
    firefox 2064 jian  mem    REG        8,6 15067744  925362 /usr/share/fonts/chinese/msyh.ttf
    8
    firefox 2064 jian  mem    REG        8,6 16791251 1701681 /usr/share/fonts/wenquanyi/wqy-zenhei.ttc
    9
    ...
#4、命令模式技巧

###4.1 组合逻辑查询条件

#####只有多个查询条件都满足， 用 "-a" 参数，默认是 -o 。

##### lsof -a -c bash -u root

    COMMAND  PID USER   FD   TYPE DEVICE SIZE/OFF    NODE NAME
    3
    bash    1986 root  cwd    DIR    8,6     4096 1701593 /root/lab
    4
    bash    1986 root  rtd    DIR    8,6     4096       2 /
    5
    bash    1986 root  txt    REG    8,6  1994157 1700632 /bin/bash
    6
    bash    1986 root  mem    REG    8,6  9690800  405214 /usr/lib/locale/locale-archive
    7
    bash    1986 root  mem    REG    8,6   210473 1700647 /lib/libnss_files-2.15.so
###4.2 lsof 命令的重复执行模式：

#####基于给定的参数延时多少秒重复执行 lsof
#####
#####+r 表示 当没有文件被打开的时候，repeat mode 将自行结束。
#####
#####-r 表示 不管文件是否存在或者被打开，它都将执行，直到你中断它。
#####
#####每个循环的输出使用 ‘=======’ 做分隔符，你也可以用 ‘-r’ | ‘+r’ 指定延时时间。
#####


##### lsof -u lakshmanan -c init -a -r5
    02

    03
    =======
    04
    =======
    05
    COMMAND   PID       USER   FD   TYPE DEVICE SIZE/OFF    NODE NAME
    06
    inita.sh 2971 lakshmanan  cwd    DIR    8,1     4096  393218 /home/lakshmanan
    07
    inita.sh 2971 lakshmanan  rtd    DIR    8,1     4096       2 /
    08
    inita.sh 2971 lakshmanan  txt    REG    8,1    83848  524315 /bin/dash
    09
    inita.sh 2971 lakshmanan  mem    REG    8,1  1434180 1442625 /lib/i386-linux-gnu/libc-2.13.so
    10
    inita.sh 2971 lakshmanan  mem    REG    8,1   117960 1442612 /lib/i386-linux-gnu/ld-2.13.so
    11
    inita.sh 2971 lakshmanan    0u   CHR  136,4      0t0       7 /dev/pts/4
    12
    inita.sh 2971 lakshmanan    1u   CHR  136,4      0t0       7 /dev/pts/4
    13
    inita.sh 2971 lakshmanan    2u   CHR  136,4      0t0       7 /dev/pts/4
    14
    inita.sh 2971 lakshmanan   10r   REG    8,1       20  393578 /home/lakshmanan/inita.sh
    15
    =======
以上输出是前 5 秒没有输出，然后 “inita.sh” 启动后，开始有了输出。
