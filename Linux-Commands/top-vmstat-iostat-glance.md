TOP/Vmstat/iostat/Glance 命令详解

 

#TOP命令详解

top命令和ps命令的基本作用是相同的，显示系统当前的进程和其他状况；
但是top是一个动态显示过程，即可以通过用户按键来不断刷新当前状态。
如? 前台执行该命令，它将独占前台，直到用户终止该程序为止。
比较准确的说，top命令提供了实时的对系统处理器的状态监视。
它将显示系统中CPU最“敏感”的任务列表。该命令可以按CPU使用。
内存使用和执行时间对任务进行排序；而且该命令的很多特性都可以通过交互式命令或者在个人定制文件中进行设定。在后面的介绍中将把命令参数和交互命令分开讲述。

 

 
下面是该命令的语法格式：

    top [-] [d delay] [q] [c] [s] [S] [i]
    
    d 指定每两次屏幕信息刷新之间的时间间隔。当然用户可以使用s交互命令来改变之。
    
    q 该选项将使top没有任何延迟的进行刷新。如果调用程序有超级用户权限，那么top将以尽可能高的优先级运行。
    
    S 指定累计模式。
    
    s 使top命令在安全模式中运行。这将去除交互命令所带来的潜在危险。
    
    i 使top不显示任何闲置或者僵死进程。
    
    c 显示整个命令行而不只是显示命令名
    
    top命令显示的项目很多，默认值是每5秒更新一次，当然这是可以设置的。显示的各项目为：
    
    uptime 该项显示的是系统启动时间、已经运行的时间和三个平均负载值（最近1秒，5秒，15秒的负载值）。
    
    processes 自最近一次刷新以来的运行进程总数。当然这些进程被分为正在运行的，休眠的，停止的等很多种类。进程和状态显示可以通过交互命令t来实现。
    
    CPU states 显示用户模式，系统模式，优先级进程（只有优先级为负的列入考虑）和闲置等各种情况所占用CPU时间的百分比。优先级进程所消耗的时间也被列入到用户和系统的时间中，所以总的百分比将大于100%。
    
    Mem 内存使用情况统计，其中包括总的可用内存，空闲内存，已用内存，共享内存和缓存所占内存的情况。
    
    Swap 交换空间统计，其中包括总的交换空间，可用交换空间，已用交换空间。
    
    PID 每个进程的ID。
    
    PPID 每个进程的父进程ID。
    
    UID 每个进程所有者的UID 。
    
    USER 每个进程所有者的用户名。
    
    PRI 每个进程的优先级别。
    
    NI 该进程的优先级值。
    
    SIZE 该进程的代码大小加上数据大小再加上堆栈空间大小的总数。单位是KB。
    
    TSIZE 该进程的代码大小。对于内核进程这是一个很奇怪的值。
    
    DSIZE 数据和堆栈的大小。
    
    TRS 文本驻留大小。
    
    D 被标记为“不干净”的页项目。
    
    LIB 使用的库页的大小。对于ELF进程没有作用。
    
    RSS 该进程占用的物理内存的总数量，单位是KB。
    
    SHARE 该进程使用共享内存的数量。
    
    STAT 该进程的状态。其中S代表休眠状态；D代表不可中断的休眠状态；R代表运行状态；Z代表僵死状态；T代表停止或跟踪状态。
    
    TIME 该进程自启动以来所占用的总CPU时间。如果进入的是累计模式，那么该时间还包括这个进程子进程所占用的时间。且标题会变成CTIME。
    
    %CPU 该进程自最近一次刷新以来所占用的CPU时间和总时间的百分比。
    
    %MEM 该进程占用的物理内存占总内存的百分比。
    
    COMMAND 该进程的命令名称，如果一行显示不下，则会进行截取。内存中的进程会有一个完整的命令行。
    
    下面介绍在top命令执行过程中可以使用的一些交互命令。从使用角度来看，熟练的掌握这些命令比掌握选项还重要一些。这些命令都是单字母的，如果在命令行选项中使用了s选项，则可能其中一些命令会被屏蔽掉。
    
    $#@60;空格立即刷新显示。
    
    Ctrl+L 擦除并且重写屏幕。
    
    h或者? 显示帮助画面，给出一些简短的命令总结说明。
    
    k 终止一个进程。系统将提示用户输入需要终止的进程PID，以及需要发送给该进程什么样的信号。一般的终止进程可以使用15信号；如果不能正常结束那就使用信号9强制结束该进程。默认值是信号15。在安全模式中此命令被屏蔽。
    
    i 忽略闲置和僵死进程。这是一个开关式命令。
    
    q 退出程序。
    
    r 重新安排一个进程的优先级别。系统提示用户输入需要改变的进程PID以及枰 柚玫慕 逃畔燃吨怠Ｊ淙胍桓稣 到 褂畔燃督档停 粗 蚩梢允垢媒 逃涤懈 叩挠畔热āＤ 现凳?0。
    
    S 切换到累计模式。
    
    s 改变两次刷新之间的延迟时间。系统将提示用户输入新的时间，单位为s。如果有小数，就换算成m s。输入0值则系统将不断刷新，默认值是5 s。需要注意的是如果设置太小的时间，很可能会引起不断刷新，从而根本来不及看清显示的情况，而且系统负载也会大大增加。
    
    f或者F 从当前显示中添加或者删除项目。
    
    o或者O 改变显示项目的顺序。
    
    l 切换显示平均负载和启动时间信息。
    
    m 切换显示内存信息。
    
    t 切换显示进程和CPU状态信息。
    
    c 切换显示命令名称和完整命令行。
    
    M 根据驻留内存大小进行排序。
    
    P 根据CPU使用百分比大小进行排序。
    
    T 根据时间/累计时间进行排序。
    
    W 将当前设置写入~/.toprc文件中。这是写top配置文件的推荐方法。

从上面的介绍中可以看到，top命令是一个功能十分强大的监控系统的工具，尤其对于系统管理员而言更是如此。一般的用户可能会觉得ps命令其实就够用了，但是top命令的强劲功能确实提供了不少方便。下面来看看实际使用的情况。

[例23] 键入top命令查看系统状况

    $ top
    
    1：55pm up 7 min， 4 user， load average:0.07，0.09，0.06
    
    29 processes:28 sleeping， 1 running， 0 zombie， 0 stopped
    
    CPU states: 4.5% user， 3.6% system， 0.0% nice， 91.9% idle
    
    Mem: 38916K av， 18564K used， 20352K free， 11660K shrd， 1220K buff
    
    Swap: 33228K av， 0K used， 33228K free， 11820K cached
    
    PID USER PRI NI SIZE RSS SHARE STAT LIB %CPU %MEM TIME COMMAND
    
    363 root 14 0 708 708 552 R 0 8.1 1.8 0:00 top
    
    1 root 0 0 404 404 344 S 0 0.0 1.0 0:03 init
    
    2 root 0 0 0 0 0 SW 0 0.0 0.0 0:00 kflushd
    
    3 root -12 -12 0 0 0 SW$#@60; 0 0.0 0.0 0:00 kswapd
    
    4 root 0 0 0 0 0 SW 0 0.0 0.0 0:00 md_thread
    
    5 root 0 0 0 0 0 SW 0 0.0 0.0 0:00 md_thread
    
    312 root 1 0 636 636 488 S 0 0.0 1.6 0:00 telnet
    
    285 root 6 0 1140 1140 804 S 0 0.0 2.9 0.00 bash
    
    286 root 0 0 1048 1048 792 S 0 0.0 2.6 0.00 bash
    
    25 root 0 0 364 364 312 S 0 0.0 0.9 0.00 kerneld
    
    153 root 0 0 456 456 372 S 0 0.0 1.1 0.00 syslogd
    
    160 root 0 0 552 552 344 S 0 0.0 1.4 0.00 klogd
    
    169 daemon 0 0 416 416 340 S 0 0.0 1.0 0.00 atd
    
    178 root 2 0 496 496 412 S 0 0.0 1.2 0.00 crond
    
    187 bin 0 0 352 352 284 S 0 0.0 0.9 0.00 portmap
    
    232 root 0 0 500 500 412 S 0 0.0 1.2 0.00 rpc.mountd
    
    206 root 0 0 412 412 344 S 0 0.0 1.0 0.00 inetd
    
    215 root 0 0 436 436 360 S 0 0.0 1.1 0.00 icmplog

第一行的项目依次为当前时间、系统启动时间、当前系统登录用户数目、平均负载。第二行为进程情况，依次为进程总数、休眠进程数、运行进程数、僵死进程数、终止进程数。第三行为CPU状态，依次为用户占用、系统占用、优先进程占用、闲置进程占用。第四行为内存状态，依次为平均可用内存、已用内存、空闲内存、共享内存、缓存使用内存。第五行为交换状态，依次为平均可用交换容量、已用容量、闲置容量、高速缓存容量。然后下面就是和ps相仿的各进程情况列表了。

总的来说，top命令的功能强于ps，但需要长久占用前台，所以用户应该根据自己的情况来使用这个命令。

##Vmstat详细解释 
vmstat:报告关于内核进程,虚拟内存,磁盘,cpu的的活动状态的工具 
主要有几个用法: 
#1.vmstat 间隔 测试数量 
输出如下 
    
    kthr memory page faults cpu 
    ----- ----------- ------------------------ ------------ ----------- 
    r b avm fre re pi po fr sr cy in sy cs us sy id wa 
    0 0 26258 18280 0 0 0 7 20 0 127 227 64 1 2 96 1 
其中: 
    
    kthr--内核进程的状态 
    --r 运行队列中的进程数,在一个稳定的工作量下,应该少于5 （r <5）
    --b 等待队列中的进程数(等待I/O),通常情况下是接近0的. （b=0）
    memory--虚拟和真实内存的使用信息 
    --avm 活动虚拟页面,在进程运行中分配到工作段的页面空间数. 
    --fre 空闲列表的数量.一般不少于120,当fre少于120时,系统开始自动的kill进程去释放 
    free list 
    page--页面活动的信息 
    --re 页面i/o的列表 
    --pi 从页面输入的页（一般不大于5) 
    --po 输出到页面的页 
    --fr 空闲的页面数(可替换的页面数) 
    --sr 通过页面置换算法搜索到的页面数 
    --cy 页面置换算法的时钟频率 
    faults--在取样间隔中的陷阱及中断数 
    --in 设备中断 
    --sy 系统调用中断 
    --cs 内核进程前后交换中断 
    cpu--cpu的使用率 
    --us 用户进程的时间 
    --sy 系统进程的时间 
    --id cpu空闲的时间 
    --wa 等待i/o的时间 
    一般us+sy 在单用户系统中不大于90,在多用户系统中不大于80. 
    wa时间一般不大于40. 

#2.vmstat -s 
现实系统自初始化以来的页面信息.

iostat结果解释


    iostat –xtcP <以秒计频率>列出系统i/o负载.每一个分区或NFS装载打印一行. “kr/s”和”kw/s”行显示以千字节/秒为单位的读写吞吐量. 若”svc_t”大于100表明那磁盘用于磁头(?)分配的时间多过数据传送的时间. 
    iostat输出结果解释（原文没有，RACE注） 
    tin每秒输入的字符数 
    tout每秒输出的字符数 
    kps每秒传输的千字符数 
    tps每秒传输的操作次数 
    serv以毫秒计的的平均服务时间 
    最后一组报告了CPU使用率： 
    us用户状态所占百分比 
    sy系统状态所占百分比 
    wt等待状态所占百分比 
    id空闲时间所占百分比 
    us用户状态所占百分比 
    ni用于运行nice或renice的进程的时间所占百分比 
    sy系统状态所占百分比 
    id空闲时间所占百分比 
    r/s每秒的读传输操作 
    w/s每秒的写传输操作 
    kr/s每秒的千字节数 
    kw/s每秒写的千字节数 
    wait在设备队列中等待命令的平均数目 
    actv在处理中的命令的平均数目 
    svc_t服务时间（* 是指为一条命令服务的平均时间，这里包括为等待在处理队列中前面的命令所耗费的时间） 
    %w在队列等待时间的百分比 
    %b设备忙的时间的百分比

#Glance监控命令在HP UX上的使用

Glance监控命令在HP UX上的使用
Glance监控工具是HP-UX系统中一个强大且易用的在线监控工具，它有两种版本，一种
是gpm，图形模式,另一个就是glance，文本模式。
几乎可以在任何终端和工作站上使用，占用资源很少。
任何一个版本都可以提供丰富的系统性能信息。
默认的进程列表会列出有关系统资源和活动进程的常规信息，更多详细信息包括：

    CPU, Memory, Disk IO, Network, NFS,system Calls, Swap, and system table。
语法：
    
    glance [-j interval] [-p [dest]] [-f dest] [-maxpages numpages]
      [-command] [-nice nicevalue] [-nosort] [-lock]
      [-adviser_off] [-adviser_only] [-bootup]
      [-iterations count] [-syntax filename] [-all_trans]
      [-all_instances] [-disks ;] [-kernel ;] [-nfs ;]
      [-pids ;] [-no_fkeys]
选项说明：
    -j interval 设置屏幕刷新的时间间隔，单位为秒，默认值为5秒，数值许可范围：1~32767
    -p [dest] 这个选项可以启用连续打印，对于屏幕刷新间隔很长时的打印很有效，
             输出会被定向到一个默认的本地打印机，除非需要输入设备参数。一旦
             运行开始，可以用p命令终止该操作
    -f dest     这个选项可以启用连续打印，对于屏幕刷新间隔很长时的打印很有效，
             输出会被定向到一个给定的文件。一旦运行开始，可以用p命令终止该操
    作
    -maxpages numpages 当用-p命令，-maxpages选项可以改变打印的最大页数，默认的是200页
    -command 这个选项是用来设置进程列表不同的屏幕显示,这个键值设置会显示不同
             的信息，详细命令见下面的-command选项，仅有一个命令可以选择
    -nice nicevalue       这个选项允许你调整glance进程的优先级别，默认值为-10
    -nosort     这个选项设置后，屏幕不用将进程排序显示，这样可以减少Glance进
    程的CPU开销
    -lock    这个选项允许你将Glance锁入内存，这样可以大大提高响应时间，但有
    可能会收到错误提示：”Unable to allocate memory/swap   space”，那样又必须取消此选项重新运行
       -adviser_off          允许你关闭建议模式运行glance
       -adviser_only 这个选项允许glace在终端无屏幕显示下运行，仅建议提示会运行，并将结果发送到标准输出。建议提示模式可以在后台运行，可以把结果重定向到一个文件，但必须要和-bootup选项联合使用
       -bootup    和-adviser_only一块儿使用,启动时就开启建议模式
       -iterations count    这个选项可以在Glance运行时限制间隔的数字，这个选项
    和-adviser_only选项在无终端显示时联合使用。Glance执行给定次数后，迭代列入清单后退出
       -syntax filename        应用这个选项启用自定义的建议文件
       -all_trans              这个选项允许Glance列出系统中所有注册的任务。如果没有指明，glance仅仅列出经过滤得项
       -all_instances       这个选项允许glance显示所有操作记录示例
       -disks ;          监控磁盘
       -kernel ;           监控系统kernel
       -nfs ;    监控NFS使用
       -pids ;              监控指定进程
    以上四个命令选项值会直接传入Midaemon（惠普的性能监控接口守护进程）和调整Midaemon的启动参数，如果Midaemon已经在运行，那样这些选项设置将不被理睬
    -no_fkeys    这个选项可以屏蔽操作屏幕显示的功能键.
    -command选项列表
          
    Command          Screen Displayed / Description       
    a CPU By Processor                               
    c CPU Report                                     
    d Disk Report                                     
    g Process List                                  
    i IO By File system                               
    l Network By Interface                            
    m Memory Report                                  
    n NFS By system                                  
    t system Tables Report                            
    u IO By Disk                                     
    v IO By Logical Volume                            
    w Swap Space                                     
    A Application List                               
    B Global Waits                                  
    D DCE Global Activity                            
    G Process Threads                               
    H Alarm History                                  
    I Thread Resource                               
    J Thread Wait                                     
    K DCE Process List                               
    N NFS Global Activity                            
    P PRM Group List                            
    T Transaction Tracker                         
    Y Global system Calls                         
    Z Global Threads                               
    ? Commands菜单                                  
      
    glance运行时的键盘命令    
    S 选择 system/Disk/Application/Trans/Thread
    s 选择查看进程                
    F 进程打开的文件                            
    L 进程系统调用                   
    M 进程内存                   
    R 进程资源                      
    W 进程等待状态                     
    
    屏幕显示控制命令
    b 下一页 
    f 前一页    
    h 在线帮助          
    j 调节屏幕刷新间隔
    o 调整进程阈值  
    p 输出打印终止             
       e/q    退出glance          
    r 刷新当前屏幕
    y 重新设置进程的nice值          
    z 将统计信息清零
