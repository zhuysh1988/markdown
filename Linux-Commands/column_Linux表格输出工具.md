## column 命令：

>有时，在你看到命令行执行的输出时，因为字符串过度拥挤（比如说 mount 命令的输出）导致输出内容难以识别。如果我们看到的内容是一张表格会如何呢？其实这是很容易做到的！

    mount | column –t

    [root@bogon ~]# mount |column -t
    sysfs                  on  /sys                             type  sysfs       (rw,nosuid,nodev,noexec,relatime)
    proc                   on  /proc                            type  proc        (rw,nosuid,nodev,noexec,relatime)
    devtmpfs               on  /dev                             type  devtmpfs    (rw,nosuid,size=1005080k,nr_inodes=251270,mode=755)
    securityfs             on  /sys/kernel/security             type  securityfs  (rw,nosuid,nodev,noexec,relatime)
    tmpfs                  on  /dev/shm                         type  tmpfs       (rw,nosuid,nodev)
    devpts                 on  /dev/pts                         type  devpts      (rw,nosuid,noexec,relatime,gid=5,mode=620,ptmxmode=000)
    tmpfs                  on  /run                             type  tmpfs       (rw,nosuid,nodev,mode=755)
    tmpfs                  on  /sys/fs/cgroup                   type  tmpfs       (ro,nosuid,nodev,noexec,mode=755)
    cgroup                 on  /sys/fs/cgroup/systemd           type  cgroup      (rw,nosuid,nodev,noexec,relatime,xattr,release_agent=/usr/lib/systemd/systemd-cgroups-agent,name=systemd)
    pstore                 on  /sys/fs/pstore                   type  pstore      (rw,nosuid,nodev,noexec,relatime)
    cgroup                 on  /sys/fs/cgroup/devices           type  cgroup      (rw,nosuid,nodev,noexec,relatime,devices)
    cgroup                 on  /sys/fs/cgroup/perf_event        type  cgroup      (rw,nosuid,nodev,noexec,relatime,perf_event)
    cgroup                 on  /sys/fs/cgroup/cpuset            type  cgroup      (rw,nosuid,nodev,noexec,relatime,cpuset)
    cgroup                 on  /sys/fs/cgroup/net_cls,net_prio  type  cgroup      (rw,nosuid,nodev,noexec,relatime,net_prio,net_cls)
    cgroup                 on  /sys/fs/cgroup/cpu,cpuacct       type  cgroup      (rw,nosuid,nodev,noexec,relatime,cpuacct,cpu)
    cgroup                 on  /sys/fs/cgroup/hugetlb           type  cgroup      (rw,nosuid,nodev,noexec,relatime,hugetlb)
    cgroup                 on  /sys/fs/cgroup/freezer           type  cgroup      (rw,nosuid,nodev,noexec,relatime,freezer)
    cgroup                 on  /sys/fs/cgroup/pids              type  cgroup      (rw,nosuid,nodev,noexec,relatime,pids)
    cgroup                 on  /sys/fs/cgroup/blkio             type  cgroup      (rw,nosuid,nodev,noexec,relatime,blkio)
    cgroup                 on  /sys/fs/cgroup/memory            type  cgroup      (rw,nosuid,nodev,noexec,relatime,memory)
    configfs               on  /sys/kernel/config               type  configfs    (rw,relatime)
    /dev/mapper/rhel-root  on  /                                type  xfs         (rw,relatime,attr2,inode64,noquota)
    systemd-1              on  /proc/sys/fs/binfmt_misc         type  autofs      (rw,relatime,fd=31,pgrp=1,timeout=300,minproto=5,maxproto=5,direct)
    hugetlbfs              on  /dev/hugepages                   type  hugetlbfs   (rw,relatime)
    debugfs                on  /sys/kernel/debug                type  debugfs     (rw,relatime)
    mqueue                 on  /dev/mqueue                      type  mqueue      (rw,relatime)
    /dev/sdb1              on  /var/lib/docker                  type  xfs         (rw,relatime,attr2,inode64,noquota)
    /dev/sda1              on  /boot                            type  xfs         (rw,relatime,attr2,inode64,noquota)
    /dev/sdb1              on  /var/lib/docker/devicemapper     type  xfs         (rw,relatime,attr2,inode64,noquota)
    tmpfs                  on  /run/user/0                      type  tmpfs       (rw,nosuid,nodev,relatime,size=203216k,mode=700)


>在此例中，由于内容中留了空格，所以输出的形式就美观了起来。 那如果想要的分隔符是别的什么符号，比如说冒号，又该怎么去做呢？ （例如，在 cat/etc/passwd 的输出内容中使用）

>这时候只需要使用 -s 参数指定分隔符就行了，像下面这样。

    [root@bogon ~]# cat /etc/passwd |column -t -s :
    root               x  0    0    root                                                             /root               /bin/bash
    bin                x  1    1    bin                                                              /bin                /sbin/nologin
    daemon             x  2    2    daemon                                                           /sbin               /sbin/nologin
    adm                x  3    4    adm                                                              /var/adm            /sbin/nologin
    lp                 x  4    7    lp                                                               /var/spool/lpd      /sbin/nologin
    sync               x  5    0    sync                                                             /sbin               /bin/sync
    shutdown           x  6    0    shutdown                                                         /sbin               /sbin/shutdown
    halt               x  7    0    halt                                                             /sbin               /sbin/halt
    mail               x  8    12   mail                                                             /var/spool/mail     /sbin/nologin
    operator           x  11   0    operator                                                         /root               /sbin/nologin
    games              x  12   100  games                                                            /usr/games          /sbin/nologin
    ftp                x  14   50   FTP User                                                         /var/ftp            /sbin/nologin
    nobody             x  99   99   Nobody                                                           /                   /sbin/nologin
    systemd-bus-proxy  x  999  997  systemd Bus Proxy                                                /                   /sbin/nologin
    systemd-network    x  192  192  systemd Network Management                                       /                   /sbin/nologin
    dbus               x  81   81   System message bus                                               /                   /sbin/nologin
    polkitd            x  998  996  User for polkitd                                                 /                   /sbin/nologin
    tss                x  59   59   Account used by the trousers package to sandbox the tcsd daemon  /dev/null           /sbin/nologin
    postfix            x  89   89                                                                    /var/spool/postfix  /sbin/nologin
    sshd               x  74   74   Privilege-separated SSH                                          /var/empty/sshd     /sbin/nologin




### column 帮助 

    [root@bogon ~]# column --help
    
    Usage:
     column [options] [file ...]
    
    Options:
     -c, --columns <width>    width of output in number of characters
     -t, --table              create a table
     -s, --separator <string> possible table delimiters
     -o, --output-separator <string>
                              table output column separator, default is two spaces
     -x, --fillrows           fill rows before columns
    
     -h, --help     display this help and exit
     -V, --version  output version information and exit
    
    For more details see column(1).