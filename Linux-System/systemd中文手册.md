systemd 中文手册
译者：金步国
版权声明
本文译者是一位开源理念的坚定支持者，所以本文虽然不是软件，但是遵照开源的精神发布。

无担保：本文译者不保证译文内容准确无误，亦不承担任何由于使用此文档所导致的损失。
自由使用：任何人都可以自由的阅读/链接/打印此文档，无需任何附加条件。
名誉权：任何人都可以自由的转载/引用/再创作此文档，但必须保留译者署名并注明出处。
其他作品
本文译者十分愿意与他人分享劳动成果，如果你对我的其他翻译作品或者技术文章有兴趣，可以在如下位置查看现有的作品集：

金步国作品集 [ http://www.jinbuguo.com/ ]
联系方式
由于译者水平有限，因此不能保证译文内容准确无误。如果你发现了译文中的错误(哪怕是错别字也好)，请来信指出，任何提高译文质量的建议我都将虚心接纳。

Email(QQ)：70171448在QQ邮箱
手册索引 . 指令索引systemd-235
名称
systemd, init — systemd 系统与服务管理器

大纲
systemd [OPTIONS...]

init [OPTIONS...] {COMMAND}

描述
systemd 是一个专用于 Linux 操作系统的系统与服务管理器。 当作为启动进程(PID=1)运行时，它将作为初始化系统运行， 也就是启动并维护各种用户空间的服务。

为了与传统的 SysV 兼容，如果将 systemd 以 init 名称启动，并且"PID≠1"，那么它将执行 telinit 命令并将所有命令行参数原封不动的传递过去。 这样对于普通的登录会话来说，无论是调用 init 还是调用 telinit 都是等价的。 详见 telinit(8) 手册。

当作为系统实例运行时， systemd 将会按照 system.conf 配置文件 以及 system.conf.d 配置目录中的指令工作； 当作为用户实例运行时，systemd 将会按照 user.conf 配置文件 以及 user.conf.d 配置目录中的指令工作。详见 systemd-system.conf(5) 手册。

选项
能够识别的命令行选项如下：

--test
检测并输出启动序列，然后退出。 仅用于调试目的。

--dump-configuration-items
输出一个单元(unit)列表。 此列表简明且完整的列出了 所有单元文件中定义的"unit"。

--unit=
设置启动时默认启动的单元(unit)。 默认值是 default.target

--system, --user
--system 表示强制作为系统实例运行(即使"PID≠1")， --user 表示强制作为用户实例运行(即使"PID=1")。 通常不应该使用此选项。 此选项仅用于调试目的， 而且 --system 仅在与 --test 一起使用时才有实际意义。

--dump-core
在崩溃时进行内存转储。 当作为用户实例运行时，此选项没有实际意义。 此选项还可以通过内核引导选项 systemd.dump_core= 开启 (参见"内核引导选项"小节)。

--crash-vt=VT
在崩溃时切换到指定的虚拟控制台(VT)。 当作为用户实例运行时，此选项没有实际意义。 可以设为一个 1–63 之间的整数或布尔值。 若设为整数则切换到指定编号的虚拟控制台； 若设为 yes 则表示使用内核消息所使用的虚拟控制台； 若设为 no 则表示不切换到任何虚拟控制台。 此选项还可以通过内核引导选项 systemd.crash_vt= 设置 (参见"内核引导选项"小节)。

--crash-shell
在崩溃时启动一个 shell 。 当作为用户实例运行时，此选项没有实际意义。 此选项还可以通过内核引导选项 systemd.crash_shell= 开启 (参见"内核引导选项"小节)。

--crash-reboot
在崩溃时自动重启系统。 当作为用户实例运行时，此选项没有实际意义。 此选项还可以通过内核引导选项 systemd.crash_reboot= 开启 (参见"内核引导选项"小节)。

--confirm-spawn
在派生新进程时进行确认提示。 当作为用户实例运行时，此选项没有实际意义。

--show-status=
设置是否显示单元状态信息。接受一个布尔值或特殊值 auto 。 设为 yes 表示在系统启动与关闭的过程中，在控制台上显示简明的单元状态信息。 设为 no 表示不显示这些信息。 设为 auto 与 no 类似，不同之处在于，一旦遇见单元失败或启动流程出现重大延迟，立即自动切换为 yes 设置。 当作为用户实例运行时，此选项没有实际意义。此选项将会覆盖内核引导选项 systemd.show_status=(见后文) 以及配置文件中 ShowStatus= 的设置。参见 systemd-system.conf(5) 手册。

--log-target=
设置日志的目标，其参数必须是 console, journal, kmsg, journal-or-kmsg, null 之一(小写)。

--log-level=
设置日志的等级， 其参数必须是一个数字或者 符合 syslog(3) 习惯的 emerg, alert, crit, err, warning, notice, info, debug 之一(小写)。

--log-color=
高亮重要的日志信息，其参数必须是一个表示真假的布尔值， 若未指定则相当于设为 yes

--log-location=
在日志中包含代码的位置， 其参数必须是一个表示真假的布尔值， 若未指定则相当于设为 yes 。仅用于调试目的。

--default-standard-output=, --default-standard-error=
为所有的 service 与 socket 设置默认的标准输出与标准错误， 相当于设置 StandardOutput= 与 StandardError= 指令的值(参见 systemd.exec(5) 手册)。其参数必须是 inherit, null, tty, journal, journal+console, syslog, syslog+console, kmsg, kmsg+console 之一(小写)。 --default-standard-output= 的默认值是 journal ；而 --default-standard-error= 的默认值是 inherit

--machine-id=
覆盖文件系统上的 machine-id 设置， 常用于网络启动或容器。 禁止设为全零的值。

-h, --help
显示简短的帮助信息并退出。

--version
显示简短的版本信息并退出。

概念
systemd 将各种系统启动和运行相关的对象， 表示为各种不同类型的单元(unit)， 并提供了处理不同单元之间依赖关系的能力。 大部分单元都静态的定义在单元文件中 (参见 systemd.unit(5) 手册)， 但是有少部分单元则是动态自动生成的： 其中一部分来自于其他传统的配置文件(为了兼容性)， 而另一部分则动态的来自于系统状态或可编程的运行时状态。 单元既可以处于活动(active)状态也可以处于停止(inactive)状态， 当然也可以处于启动中(activating)或停止中(deactivating)的状态。 还有一个特殊的失败(failed)状态， 意思是单元以某种方式失败了 (进程崩溃了、或者触碰启动频率限制、或者退出时返回了错误代码、或者遇到了操作超时之类的故障)。 当进入失败(failed)状态时， 导致故障的原因将被记录到日志中以方便日后排查。 需要注意的是， 不同的单元可能还会有各自不同的"子状态"， 但它们都被映射到上述五种状态之一。

各种不同的单元类型如下：

service 单元。用于封装一个后台服务进程。 参见 systemd.service(5) 手册。

socket 单元。 用于封装一个系统套接字(UNIX)或互联网套接字(INET/INET6)或FIFO管道。 相应的服务在第一个"连接"进入套接字时才会被启动。 有关套接字单元的详情，参见 systemd.socket(5) 手册；有关基于套接字或其他方式的启动，参见 daemon(7) 手册。

target 单元。 用于将多个单元在逻辑上组合在一起。参见 systemd.target(5) 手册。

device 单元。用于封装一个设备文件，可用于基于设备的启动。 并非每一个设备文件都需要一个 device 单元， 但是每一个被 udev 规则标记的设备都必须作为一个 device 单元出现。参见 systemd.device(5) 手册。

mount 单元。 用于封装一个文件系统挂载点(也向后兼容传统的 /etc/fstab 文件)。参见 systemd.mount(5) 手册。

automount 单元。 用于封装一个文件系统自动挂载点，也就是仅在挂载点确实被访问的情况下才进行挂载。 它取代了传统的 autofs 服务。参见 systemd.automount(5) 手册。

timer 单元。 用于封装一个基于时间触发的动作。它取代了传统的 atd, crond 等任务计划服务。参见 systemd.timer(5) 手册。

swap 单元。 用于封装一个交换分区或者交换文件。 它与 mount 单元非常类似。参见 systemd.swap(5) 手册。

path 单元。 用于根据文件系统上特定对象的变化来启动其他服务。参见 systemd.path(5) 手册。

slice 单元。 用于控制特定 CGroup 内(例如一组 service 与 scope 单元)所有进程的总体资源占用。 参见 systemd.slice(5) 手册。

scope 单元。它与 service 单元类似，但是由 systemd 根据 D-bus 接口接收到的信息自动创建， 可用于管理外部创建的进程。参见 systemd.scope(5) 手册。

单元的名称由单元文件的名称决定， 某些特定的单元名称具有特殊的含义，详情参见 systemd.special(7) 手册。

systemd 能够处理各种类型的依赖关系， 包括依赖与冲突(也就是 Requires= 与 Conflicts= 指令)， 以及先后顺序(也就是 After= 与 Before= 指令)。 注意， 上述两种类型的依赖关系(依赖与冲突、先后顺序)之间是相互独立的(无关的)。 举例来说，假定 foo.service 依赖于(Requires) bar.service 但并未指定先后顺序， 那么这两个服务将被同时并行启动。 不过在两个单元之间既存在依赖关系也存在先后顺序的情形也很常见。 另外需要注意的是， 大多数依赖关系都是由 systemd 隐式创建和维护的， 因此没有必要额外手动创建它们。

应用程序和单元(透过依赖关系)可能会查询其他单元的状态变化。 在 systemd 中， 这种查询被包装为"任务"(job)并被作为"任务队列"进行管理。 任务的执行结果可能成功也可能失败， 但是任务的执行顺序是依照任务所属单元之间的先后顺序确定的。

在系统启动时，systemd 默认启动 default.target 单元， 该单元中应该包含所有你想在开机时默认启动的单元。 但实际上，它通常只是一个指向 graphical.target (图形界面) 或 multi-user.target (命令行界面，常用于嵌入式或服务器环境， 一般是 graphical.target 的一个子集)的符号连接。 详见 systemd.special(7) 手册。

systemd 依赖于内核提供的 cgroups 特性控制进程的派生， 从而确保可以追踪到所有子进程。 cgroups 信息由内核负责维护， 并且可以通过 /sys/fs/cgroup/systemd/ 接口进行访问。此外，还可以通过 systemd-cgls(1) 或 ps(1) 之类的工具进行查看 (ps xawf -eo pid,user,cgroup,args)

systemd 几乎完全兼容传统的 SysV init 系统： SysV init 脚本可以作为另一种配置文件格式被识别； 提供与 SysV 兼容的 /dev/initctl 接口； 提供各种 SysV 工具的兼容实现； 依然兼容例如 /etc/fstab 或者 utmp 之类传统的 Unix 特性。

systemd 还有一个小型的事务系统： 如果要启动或关闭一个单元， 那么该单元所依赖的 所有其他单元都会被一起加入到同一个临时事务中。 这样，就可以校验整个事务的一致性， 也就是检查是否存在循环依赖。 如果存在循环依赖， 那么 systemd 将会尝试通过 去掉弱依赖(want)来解决这个问题， 如果最终实在无法解决循环依赖的问题， 那么 systemd 将会报错。

systemd 内置了许多系统启动过程中必需的操作， 例如，设置 hostname 以及配置 loopback 网络设备， 以及挂载 /sys 和 /proc 文件系统。

想要了解更多有关设计 systemd 系统背后的思想，可以看看 Original Design Document 文档。

想要了解 systemd 提供的某些编程接口，可以看看 Interface Stability Promise 文档。

在系统启动或者执行 systemctl reload … 时， systemd 可以根据其他配置文件或者内核引导选项动态生成单元，参见 systemd.generator(7) 手册。

如果要从容器中调用 systemd 那么必须遵守 Container Interface 规范。 如果要从 initrd 中调用 systemd 那么必须遵守 initrd Interface 规范。

目录
系统单元目录
systemd 会从多个优先级不同的系统单元目录中读取系统单元， 软件包应该将系统单元文件安装在 pkg-config systemd --variable=systemdsystemunitdir 命令所返回的系统单元目录中(通常是 /usr/lib/systemd/system)。 此外， systemd 还会读取优先级较高的 /usr/local/lib/systemd/system 目录以及优先级较低的 /usr/lib/systemd/system 目录中的系统单元文件。 优先级最高的系统单元目录是 pkg-config systemd --variable=systemdsystemconfdir 命令所返回的目录(通常是 /etc/systemd/system)。 注意，软件包应该仅使用 systemctl(1) 的 enable 与 disable 命令修改上述目录中的内容。 完整的目录列表参见 systemd.unit(5) 手册。

用户单元目录
用户单元目录所遵守的规则与系统单元目录类似， 软件包应该将用户单元文件安装在 pkg-config systemd --variable=systemduserunitdir 命令所返回的用户单元目录中(通常是/usr/lib/systemd/user)。 此外，因为用户单元目录还遵守 XDG Base Directory specification 规范， 所以 systemd 还会读取 $XDG_DATA_HOME/systemd/user(仅在已设置 $XDG_DATA_HOME 的情况下) 或 ~/.local/share/systemd/user(仅在未设置 $XDG_DATA_HOME 的情况下) 目录中的用户单元。 全局用户单元目录(针对所有用户)是 pkg-config systemd --variable=systemduserconfdir 命令所返回的目录(通常是/etc/systemd/user)。 注意，软件包应该仅使用 systemctl(1) 的 enable 与 disable 命令修改上述目录中的内容。 无论这种修改是全局的(针对所有用户)、还是私有的(针对单个用户)。 完整的目录列表参见 systemd.unit(5) 手册。

SysV启动脚本目录(不同发行版之间差别可能很大)
如果 systemd 找不到指定服务所对应的单元文件， 那么就会到SysV启动脚本目录中 去寻找同名脚本(去掉 .service 后缀)。

SysV运行级目录(不同发行版之间差别可能很大)
systemd 在决定是否启用一个服务的时候， 会参照SysV运行级目录对该服务的设置。 注意， 这个规则不适用于那些已经拥有原生单元文件的服务。

信号
SIGTERM
systemd 系统实例将会保存其当前状态， 然后重新执行它自身，再恢复到先前保存的状态。 基本上相当于执行 systemctl daemon-reexec 命令。

systemd 用户实例将会启动 exit.target 单元。 基本上相当于执行 systemctl --user start exit.target --job-mode=replace-irreversible 命令。

SIGINT
systemd 系统实例将会启动 ctrl-alt-del.target 单元。 基本上相当于执行 systemctl start ctl-alt-del.target --job-mode=replace-irreversible 命令。 在控制台上按 Ctrl-Alt-Del 组合键即可触发这个信号。 但是，如果在2秒内连续收到超过7次这个信号，那么将会不顾一切的立即强制重启。 因此，如果系统在重启过程中僵死， 那么可以通过快速连按7次 Ctrl-Alt-Del 组合键来强制立即重启。

systemd 用户实例处理此信号的方式与 SIGTERM 相同。

SIGWINCH
systemd 系统实例将会启动 kbrequest.target 单元。 基本上相当于执行 systemctl start kbrequest.target 命令。

systemd 用户实例将会完全忽略此信号。

SIGPWR
systemd 将会启动 sigpwr.target 单元。 基本上相当于执行 systemctl start sigpwr.target 命令。

SIGUSR1
systemd 将会尝试重新连接到 D-Bus 总线。

SIGUSR2
systemd 将会以人类易读的格式将其完整的状态记录到日志中。 日期的格式与 systemd-analyze dump 的输出格式相同。

SIGHUP
重新加载守护进程的配置文件。 基本上相当于执行 systemctl daemon-reload 命令。

SIGRTMIN+0
进入默认模式，启动 default.target 单元。 基本上相当于执行 systemctl isolate default.target 命令。

SIGRTMIN+1
进入救援模式，启动 rescue.target 单元。 基本上相当于执行 systemctl isolate rescue.target 命令。

SIGRTMIN+2
进入紧急维修模式，启动 emergency.target 单元。 基本上相当于执行 systemctl isolate emergency.target 命令。

SIGRTMIN+3
关闭系统，启动 halt.target 单元。 基本上相当于执行 systemctl start halt.target --job-mode=replace-irreversible 命令。

SIGRTMIN+4
关闭系统并切断电源，启动 poweroff.target 单元。 基本上相当于执行 systemctl start poweroff.target --job-mode=replace-irreversible 命令。

SIGRTMIN+5
重新启动，启动 reboot.target 单元。 基本上相当于执行 systemctl start reboot.target --job-mode=replace-irreversible 命令。

SIGRTMIN+6
通过内核的 kexec 接口重新启动，启动 kexec.target 单元。 基本上相当于执行 systemctl start kexec.target --job-mode=replace-irreversible 命令。

SIGRTMIN+13
立即关闭机器

SIGRTMIN+14
立即关闭机器并切断电源

SIGRTMIN+15
立即重新启动

SIGRTMIN+16
立即通过内核的 kexec 接口重新启动

SIGRTMIN+20
在控制台上显示状态消息。 相当于使用 systemd.show_status=1 内核引导选项。

SIGRTMIN+21
禁止在控制台上显示状态消息。 相当于使用 systemd.show_status=0 内核引导选项。

SIGRTMIN+22, SIGRTMIN+23
将日志等级设为 "debug"(22) 或 "info"(23)。 相当于使用 systemd.log_level=debug 或 systemd.log_level=info 内核引导选项。

SIGRTMIN+24
立即退出 systemd 用户实例(也就是仅对 --user 实例有效)。

SIGRTMIN+26, SIGRTMIN+27, SIGRTMIN+28
将日志目标设为 "journal-or-kmsg"(26) 或 "console"(27) 或 "kmsg"(28)。 相当于使用 systemd.log_target=journal-or-kmsg 或 systemd.log_target=console 或 systemd.log_target=kmsg 内核引导选项。

环境变量
$SYSTEMD_LOG_LEVEL
systemd 日志等级。 可以被 --log-level= 选项覆盖。

$SYSTEMD_LOG_TARGET
systemd 日志目标。 可以被 --log-target= 选项覆盖。

$SYSTEMD_LOG_COLOR
systemd 是否应该高亮重要的日志信息。 可以被 --log-color= 选项覆盖。

$SYSTEMD_LOG_LOCATION
systemd 是否应该在日志信息中包含代码位置(code location)。 可以被 --log-location= 选项覆盖。

$XDG_CONFIG_HOME, $XDG_DATA_HOME
systemd 用户实例根据 XDG Base Directory specification 规范使用这些变量加载单元文件及其 .{d,wants,requires}/ 目录。

$SYSTEMD_UNIT_PATH
单元目录

$SYSTEMD_SYSVINIT_PATH
SysV启动脚本目录

$SYSTEMD_SYSVRCND_PATH
SysV运行级目录

$SYSTEMD_COLORS
是否使用彩色显示输出内容。 必须设为一个布尔值。明确设置此环境变量将会覆盖 systemd 根据 $TERM 变量的值以及所连接的控制台自动作出的判断。

$LISTEN_PID, $LISTEN_FDS, $LISTEN_FDNAMES
在基于套接字启动的过程中由 systemd 设置此变量， 以供管理程序使用。详见 sd_listen_fds(3) 手册。

$NOTIFY_SOCKET
由 systemd 设置此变量， 以报告状态以及提供启动完毕的通知，以供管理程序使用。详见 sd_notify(3) 手册。

内核引导选项
当作为系统实例运行的时候， systemd 能够接受下面列出的内核引导选项。[1]

systemd.unit=, rd.systemd.unit=
设置默认启动的单元。 默认值是 default.target 。 可用于临时修改启动目标(例如 rescue.target 或 emergency.target )。详情参见 systemd.special(7) 手册。 有 "rd." 前缀的参数专用于 initrd(initial RAM disk) 环境， 而无前缀的参数则用于常规环境。

systemd.dump_core
既可以明确设为一个布尔值，也可以仅使用此选项而不设置任何参数(相当于设为 yes )。 设为 yes 表示 systemd(PID=1) 将会在崩溃时进行内存转储，否则不进行任何转储。 默认值是 yes 。

systemd.crash_chvt
既可以明确设为一个布尔值，也可以明确设为一个 1-63 之间的整数， 还可以仅使用此选项而不设置任何参数(相当于设为 yes )。 设为整数表示 systemd(PID=1) 将在崩溃时切换到指定编号的虚拟控制台； 设为 yes 表示切换到内核消息所使用的虚拟控制台； 设为 no 表示不切换到任何虚拟控制台。 默认值是 no 。

systemd.crash_shell
既可以明确设为一个布尔值，也可以仅使用此选项而不设置任何参数(相当于设为 yes )。 设为 yes 表示 systemd(PID=1) 将在自身崩溃10秒后启动一个 shell ； 默认值 no 表示即使崩溃也不启动任何 shell 。 由于被启动的 shell 不需要任何密码认证，所以使用这个特性时需要注意其带来的安全隐患。

systemd.crash_reboot
既可以明确设为一个布尔值，也可以仅使用此选项而不设置任何参数(相当于设为 yes )。 设为 yes 表示 systemd(PID=1) 将在自身崩溃10秒后自动重启整个系统； 默认值 no 表示即使崩溃也不重启(无限制的死在那里)，这样可以避免进入循环重启。 如果与 systemd.crash_shell 一起使用， 那么系统将在退出 shell 之后重启。

systemd.confirm_spawn
既可以明确设为一个布尔值，也可以明确设为一个虚拟控制台设备， 还可以仅使用此选项而不设置任何参数(相当于设为 yes )。 设为 yes 表示 systemd(PID=1) 在使用 /dev/console 派生新进程时必须进行确认提示。 默认值 no 表示不作任何提示。 若设为一个控制台设备的路径或者名称(例如"ttyS0")， 则表示仅在这些指定的设备上派生新进程时，才会显示确认提示信息。

systemd.show_status
用于设置是否显示单元状态信息。 既可以明确设为一个布尔值，也可以明确设为特殊值 auto， 还可以仅使用此选项而不设置任何参数(相当于设为 yes )。 设为 yes 表示在系统启动与关闭的过程中，在控制台上显示简明的单元状态信息。 设为 no 表示不显示这些信息。 auto 与 no 类似，不同之处在于， 一旦遇见单元失败或启动流程出现重大延迟，立即自动切换为 yes 设置。 当使用了内核引导选项 quiet 时，此选项的默认值是 auto ，否则默认值是 yes 。 此选项将会覆盖 systemd 配置文件中 ShowStatus= 的设置，参见 systemd-system.conf(5) 手册。 注意，命令行选项 --show-status= 的优先级最高， 它会覆盖内核引导选项以及 systemd 配置文件中的设置。

systemd.log_target=, systemd.log_level=, systemd.log_location=, systemd.log_color
用于控制日志输出，含义与之前的 $SYSTEMD_LOG_TARGET, $SYSTEMD_LOG_LEVEL, $SYSTEMD_LOG_LOCATION, $SYSTEMD_LOG_COLOR 环境变量相同。 直接使用 systemd.log_color 而不设置任何参数， 相当于明确将其设为 yes 。

systemd.default_standard_output=, systemd.default_standard_error=
设置服务的默认标准输出与标准错误， 含义与相应的 --default-standard-output= 和 --default-standard-error= 命令行选项相同。

systemd.setenv=
接受"VARIABLE=VALUE"格式的字符串， 可用于为派生的子进程设置默认环境变量。 可以多次使用以设置多个变量。

systemd.machine_id=
接受一个32字符表示的16进制值， 用作该主机的 machine-id 。 主要用于网络启动，以确保每次启动都能得到相同的 machine-id 值。

systemd.unified_cgroup_hierarchy
设置是否使用单一层次资源控制接口(cgroups-v2)。 既可以明确设为一个布尔值，也可以仅使用此选项而不设置任何参数(相当于设为 yes )。 设为 yes 表示明确仅使用新式的 cgroups-v2 ， 设为 no 表示当 cgroups-v2 不可用时可以回退到使用 cgroups-v1 (也就是可以混合使用 v1 与 v2)。

此选项的默认值取决于编译时 --with-default-hierarchy= 的设置。 如果内核版本低于Linux-4.5(完全不支持 v2)， 那么将无条件的完全使用 cgroups-v1 (无视此处的设置)。

systemd.legacy_systemd_cgroup_controller
此选项仅在上一个选项值为 no 时有意义。 既可以明确设为一个布尔值， 也可以仅使用此选项而不设置任何参数(相当于设为 yes )。 设为 yes 表示禁止混合使用 cgroups-v1 与 cgroups-v2 ， 也就是必须完全仅仅使用老旧的 cgroups-v1 。 设为 no 表示允许混合使用 cgroups-v1 与 cgroups-v2 。

此选项的默认值取决于编译时 --with-default-hierarchy= 的设置。 如果内核版本低于Linux-4.5(完全不支持 v2)， 那么将无条件的完全使用 cgroups-v1 (无视此处的设置)。

quiet
关闭启动过程中的状态输出。相当于 systemd.show_status=no 的效果。 注意，因为此选项也同样被内核所识别， 并用于禁止输出内核日志， 所以使用此选项会导致同时关闭内核与 systemd 的输出。

debug
开启调试输出， 等价于设置了 systemd.log_level=debug 。 注意，因为此选项也同样被内核所识别， 并用于开启内核的调试输出， 所以使用此选项会导致同时开启内核与 systemd 的调试输出。

emergency, rd.emergency, -b
启动到紧急维修模式。等价于设置了 systemd.unit=emergency.target 或 rd.systemd.unit=emergency.target

rescue, rd.rescue, single, s, S, 1
启动到救援模式。等价于设置了 systemd.unit=rescue.target 或 rd.systemd.unit=rescue.target

2, 3, 4, 5
启动到对应的 SysV 运行级。 等价于设置了对应的 systemd.unit=runlevel2.target, systemd.unit=runlevel3.target, systemd.unit=runlevel4.target, systemd.unit=runlevel5.target,

locale.LANG=, locale.LANGUAGE=, locale.LC_CTYPE=, locale.LC_NUMERIC=, locale.LC_TIME=, locale.LC_COLLATE=, locale.LC_MONETARY=, locale.LC_MESSAGES=, locale.LC_PAPER=, locale.LC_NAME=, locale.LC_ADDRESS=, locale.LC_TELEPHONE=, locale.LC_MEASUREMENT=, locale.LC_IDENTIFICATION=
设置相应的系统 locale ， 会覆盖 /etc/locale.conf 中的设置。 参见 locale.conf(5) 与 locale(7) 手册。

更多内核引导选项的解释， 参见 kernel-command-line(7) 手册。

Sockets 与 FIFOs
/run/systemd/notify
通知守护进程状态的 UNIX socket 文件， 用于实现 sd_notify(3) 中实现的守护进程通知逻辑。

/run/systemd/private
仅被 systemctl(1) 工具内部用于与 systemd 进程通信的 UNIX socket 文件。 其他进程不应该使用它。

/dev/initctl
由 systemd-initctl.service 单元提供的与传统 SysV 兼容的客户端接口(FIFO)。 这是一个即将被废弃的接口，尽量不要使用它。

参见
systemd Homepage, systemd-system.conf(5), locale.conf(5), systemctl(1), journalctl(1), systemd-notify(1), daemon(7), sd-daemon(3), systemd.unit(5), systemd.special(5), pkg-config(1), kernel-command-line(7), bootup(7), systemd.directives(7)


[1] 当 systemd 在 Linux 容器中运行的时候， 这些参数可以直接在 systemd 命令行上传递(放置在所有命令行选项之后)， 当 systemd 不在 Linux 容器中运行的时候， 这些参数将从 /proc/cmdline 中获取。