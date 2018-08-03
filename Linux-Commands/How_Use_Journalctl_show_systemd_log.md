 journalctl -u kubelet --no-pager -f -n 20



如何使用Journalctl查看和操作Systemd日志
一些systemd最引人注目的优势是那些参与到流程和系统日志。使用其他系统，日志通常分散在整个系统中，由不同的守护程序和工具处理的，并且可以是相当困难的，当他们跨越解释...

分类:日志 系统工具 开发工具 服务器

 2015-02-05 20:02:07
介绍
一些最引人注目的优势systemd是那些参与到流程和系统日志。 当使用其它工具，日志通常分散在整个系统中，由不同的守护程序和进程的处理，并且可以是相当困难的，当它们跨越多个应用来解释。 Systemd试图通过用于记录所有内核提供一个集中管理解决方案，以解决这些问题，并用户级进程。 收集和管理这些日志的系统称为日志。

该杂志是与实施journald守护程序，它处理所有的内核，initrd服务等。在本指南中产生的消息，我们将讨论如何使用journalctl实用工具，可用于访问和操纵数据在期刊内举行。

大概的概念
其中背后的驱动力的systemd刊物是集中日志的管理，无论哪里的消息发起的。 由于大部分的启动过程和服务管理是由处理systemd过程，是有意义的标准化的日志收集和访问的方式。 该journald守护在轻松和动态操作的二进制格式的所有可用资源，并将它们存储收集数据。

这给了我们一些显着的优势。 通过使用单个实用程序与数据交互，管理员能够根据其需要动态显示日志数据。 这可以像从三个引导之前查看引导数据一样简单，或者从两个相关服务顺序组合日志条目以调试通信问题。

以二进制格式存储日志数据还意味着数据可以根据您当前需要的任意输出格式显示。 例如，对于每天的日志管理您可以用于在标准查看日志syslog格式，但如果你决定以后图表服务中断，可以输出每一个条目作为JSON对象，使其耗到你的绘图服务。 由于数据未以纯文本形式写入磁盘，因此在需要不同的按需格式时不需要进行转换。

该systemd期刊既可以与现有使用syslog的实现，也可以更换syslog功能，根据您的需要。 而systemd杂志将涵盖大多数管理员的记录需求，它也可以补充现有的日志机制。 例如，你可能有一个集中的syslog ，你用来编译来自多个服务器的数据服务器，但你也不妨与交错在单个系统上从多个服务日志systemd杂志。 您可以通过组合这些技术来实现这两者。

设置系统时间
使用二进制日志进行日志记录的一个好处是能够以UTC或本地时间随意查看日志记录。 默认情况下， systemd将显示在当地时间结果。

因此，在我们开始使用期刊之前，我们将确保时区设置正确。 该systemd套房实际上带有一个工具，称为timedatectl ，可以帮助这一点。

首先，看看什么时区以list-timezones选项：

timedatectl list-timezones
这将列出您的系统上可用的时区。 如果您发现该位置匹配您的服务器的一个，你可以通过设置set-timezone选项：

sudo timedatectl set-timezone zone
为了确保您的机器现在使用正确的时间，用timedatectl单独命令，或使用status选项。 显示将是相同的：

timedatectl status
      Local time: Thu 2015-02-05 14:08:06 EST
  Universal time: Thu 2015-02-05 19:08:06 UTC
        RTC time: Thu 2015-02-05 19:08:06
       Time zone: America/New_York (EST, -0500)
     NTP enabled: no
NTP synchronized: no
 RTC in local TZ: no
      DST active: n/a
第一行应显示正确的时间。

基本日志查看
要看到，日志journald守护程序收集，使用journalctl命令。

单独使用时，每一个日记帐分录是系统将寻呼机（通常内显示less ），供您浏览。 最旧的条目将在顶部：

journalctl
-- Logs begin at Tue 2015-02-03 21:48:52 UTC, end at Tue 2015-02-03 22:29:38 UTC. --
Feb 03 21:48:52 localhost.localdomain systemd-journal[243]: Runtime journal is using 6.2M (max allowed 49.
Feb 03 21:48:52 localhost.localdomain systemd-journal[243]: Runtime journal is using 6.2M (max allowed 49.
Feb 03 21:48:52 localhost.localdomain systemd-journald[139]: Received SIGTERM from PID 1 (systemd).
Feb 03 21:48:52 localhost.localdomain kernel: audit: type=1404 audit(1423000132.274:2): enforcing=1 old_en
Feb 03 21:48:52 localhost.localdomain kernel: SELinux: 2048 avtab hash slots, 104131 rules.
Feb 03 21:48:52 localhost.localdomain kernel: SELinux: 2048 avtab hash slots, 104131 rules.
Feb 03 21:48:52 localhost.localdomain kernel: input: ImExPS/2 Generic Explorer Mouse as /devices/platform/
Feb 03 21:48:52 localhost.localdomain kernel: SELinux:  8 users, 102 roles, 4976 types, 294 bools, 1 sens,
Feb 03 21:48:52 localhost.localdomain kernel: SELinux:  83 classes, 104131 rules

. . .
你将有可能页和数据页来滚动，它可以是几万或几十万排长队，如果systemd已经在系统上很长一段时间。 这将显示日志数据库中有多少数据可用。

该格式将是熟悉的那些谁是用来标准syslog日志记录。 然而，这实际上收集来自多个来源的数据，比传统syslog实现有能力的。 它包括来自早期引导过程，内核，initrd和应用程序标准错误的日志。 这些都在期刊上可用。

您可能会注意到，显示的所有时间戳都是本地时间。 这对于每个日志条目都可用，现在我们的本地时间在我们的系统上正确设置。 使用此新信息显示所有日志。

如果你想显示UTC时间戳，您可以使用--utc标志：

journalctl --utc
日志按时间过滤
虽然访问这样大量的数据集合是绝对有用的，但是这样大量的信息可能难以或不可能在精神上检查和处理。 正因为如此，的最重要的特点之一journalctl是其过滤选项。

显示当前引导的日志
最基本的这些，你可能每天都在使用，是-b标志。 这将显示自最近重新引导以来收集的所有日记帐分录。

journalctl -b
这将帮助您识别和管理与您当前环境相关的信息。

在您不使用此功能，并正在显示的靴子一天以上的情况下，你会看到journalctl插入了一行，看起来像这样每次系统崩溃：

. . .

-- Reboot --

. . .
这可以用于帮助您将信息逻辑地分为引导会话。

过去靴子
虽然你通常想显示当前引导的信息，但是有时候过去的引导也会有帮助。 该杂志可以节省许多以前的靴子信息，因此journalctl可以做成很容易地显示信息。

某些分发版本可以在默认情况下保存以前的引导信息，而其他分发版则禁用此功能。 要启用持久启动信息，您可以键入以下命令来创建存储日志的目录：

sudo mkdir -p /var/log/journal
或者，您可以编辑日志配置文件：

sudo nano /etc/systemd/journald.conf
根据[Journal]部分，设置了Storage=选项“老大难”启用日志记录持续：

/etc/systemd/journald.conf
. . .
[Journal]
Storage=persistent
当保存先前的靴子是您的服务器上启用， journalctl提供了一些命令来帮助你靴子划分的单位工作。 要看到，靴子journald知道，使用--list-boots带选项journalctl ：

journalctl --list-boots
-2 caf0524a1d394ce0bdbcff75b94444fe Tue 2015-02-03 21:48:52 UTC—Tue 2015-02-03 22:17:00 UTC
-1 13883d180dc0420db0abcb5fa26d6198 Tue 2015-02-03 22:17:03 UTC—Tue 2015-02-03 22:19:08 UTC
 0 bed718b17a73415fade0e4e7f4bea609 Tue 2015-02-03 22:19:12 UTC—Tue 2015-02-03 23:01:01 UTC
这将为每次引导显示一行。 第一列的偏移量，可以用来很容易地与参考引导的引导journalctl 。 如果需要绝对引用，则引导标识位于第二列。 您可以通过结束时列出的两个时间规格来判断引导会话所指的时间。

要显示来自这些引导的信息，您可以使用第一列或第二列中的信息。

例如，看杂志，从先前的引导，使用-1相对终场前的-b标志：

journalctl -b -1
您还可以使用引导ID从引导回调数据：

journalctl -b caf0524a1d394ce0bdbcff75b94444fe
时间窗口
通过引导查看日志条目非常有用，通常您可能希望请求与系统引导不匹配的时间窗口。 在处理长时间运行的服务器并且正常运行时间很长时，这可能尤其如此。

可以通过使用任意的时间限制进行过滤--since和--until选项，分别限制之后，或者给定时间之前所显示的那些条目。

时间值可以有多种格式。 对于绝对时间值，应使用以下格式：

YYYY-MM-DD HH:MM:SS
例如，我们可以看到所有的条目从2015年1月10日下午5:15通过键入：

journalctl --since "2015-01-10 17:15:00"
如果上述格式的组件保持关闭，将应用一些默认值。 例如，如果省略日期，则将假定当前日期。 如果时间组件丢失，将替换“00:00:00”（午夜）。 秒字段也可以关闭，默认为“00”：

journalctl --since "2015-01-10" --until "2015-01-11 03:00"
日志还理解一些相对值和命名快捷方式。 例如，您可以使用“昨天”，“今天”，“明天”或“现在”字样。 你通过在一个编号的值前面加上“ - ”或“+”或者在句子结构中使用像“”“这样的词来做相对的时间。

要从昨天获取数据，您可以键入：

journalctl --since yesterday
如果您收到服务中断的报告，从上午9:00开始并持续到一个小时前，您可以键入：

journalctl --since 09:00 --until "1 hour ago"
正如你所看到的，定义灵活的时间窗口来过滤你想要看到的条目是相对容易的。

按消息兴趣过滤
我们在上面学习了一些方法，可以使用时间约束来过滤日志数据。 在本节中，我们将讨论如何根据你是什么服务或组件兴趣进行过滤。该systemd杂志提供了多种这样的方法。

按单位
也许过滤的最有效的方法是你感兴趣的单位。我们可以用-u选项以这种方式来过滤。

例如，要查看我们系统上的Nginx单元的所有日志，我们可以键入：

journalctl -u nginx.service
通常，您可能希望按时间进行过滤，以便显示您感兴趣的行。例如，要检查当前服务是如何运行的，您可以键入：

journalctl -u nginx.service --since today
当您利用期刊的交叉记录从各种单位的能力时，这种类型的重点变得非常有用。 例如，如果您的Nginx进程连接到一个PHP-FPM单元来处理动态内容，您可以通过指定两个单位按时间顺序合并条目：

journalctl -u nginx.service -u php-fpm.service --since today
这可以使得更容易发现不同程序和调试系统之间的交互，而不是单个进程。

按进程，用户或组ID
一些服务产生了各种子进程来做工作。 如果你已经搜索出你感兴趣的过程的确切PID，你也可以过滤它。

要做到这一点，我们可以通过指定过滤_PID领域。 例如，如果我们感兴趣的PID是8088，我们可以键入：

journalctl _PID=8088
在其他时间，您可能希望显示从特定用户或组记录的所有条目。 这可以通过完成_UID或_GID滤波器。 例如，如果你的Web服务器下运行www-data的用户，你可以找到通过键入用户ID：

id -u www-data
33
之后，您可以使用返回的ID过滤日志结果：

journalctl _UID=33 --since today
该systemd轴颈具有许多领域，可以用于过滤。 其中的一些从该过程被传递的被记录和一些被施加journald用它从系统的日志的时间收集信息。

领先的下划线表示该_PID字段是后一种类型。 日志自动记录和索引正在记录以供以后过滤的进程的PID。 您可以通过键入以下内容找到所有可用的日记字段：

man systemd.journal-fields
我们将在本指南中讨论其中的一些。 现在，我们将讨论与这些字段过滤有关的一个更有用的选项。 该-F选项可用于显示所有可用的值对于给定的杂志领域。

例如，看哪个组ID的systemd杂志有，你可以输入的条目：

journalctl -F _GID
32
99
102
133
81
84
100
0
124
87
这将显示日志为组ID字段存储的所有值。 这可以帮助您构建过滤器。

按组件路径
我们还可以通过提供路径位置进行过滤。

如果该路径指向一个可执行文件， journalctl将显示所有涉及问题的可执行文件中的条目。 例如，为了找到那些涉及条目bash可执行文件，您可以键入：

journalctl /usr/bin/bash
通常，如果一个单元可用于可执行文件，该方法更干净，并提供更好的信息（来自相关子进程的条目等）。 然而，有时，这是不可能的。

显示内核消息
内核消息，这些通常是在发现dmesg输出，可以从日志以及检索。

要只显示这些消息，我们可以添加-k或--dmesg标志来我们的命令：

journalctl -k
默认情况下，这将显示当前引导的内核消息。 您可以使用前面讨论的正常引导选择标志来指定备用引导。 例如，要从五个靴子之前获取消息，您可以键入：

journalctl -k -b -5
优先级
系统管理员经常感兴趣的一个过滤器是消息优先级。 虽然在非常详细的级别上记录信息通常是有用的，但是当实际消化可用信息时，低优先级日志可能分散注意力和混乱。

您可以使用journalctl通过显示一个指定的优先级或以上的只有消息-p选项。 这允许您过滤掉较低优先级的邮件。

例如，要仅显示在错误级别或更高级别记录的条目，您可以键入：

journalctl -p err -b
这将显示标记为错误，重要，警报或紧急情况的所有邮件。 该杂志实现了标准syslog消息级别。 您可以使用优先级名称或其相应的数值。 按照从高到低的顺序，这些是：

0：出现
1：警报
2：暴击
3：错误
4：警告
5：通知
6：info
7：调试
上面的数字或名称可以互换的使用-p选项。 选择优先级将显示标记在指定级别及其上方的消息。

修改日志显示
上面，我们通过过滤展示了入口选择。 还有其他方法，我们可以修改输出。 我们可以调整journalctl显示，以适应各种需求。

截断或展开输出
我们可以调整journalctl告诉它缩小或扩大输出显示数据。

默认情况下， journalctl将显示在寻呼机整个条目，使条目落后关闭到屏幕的右侧。 可以通过按向右箭头键访问此信息。

如果你宁愿输出截断，插入其中，信息已被删除省略号，你可以使用--no-full选项：

journalctl --no-full
. . .

Feb 04 20:54:13 journalme sshd[937]: Failed password for root from 83.234.207.60...h2
Feb 04 20:54:13 journalme sshd[937]: Connection closed by 83.234.207.60 [preauth]
Feb 04 20:54:13 journalme sshd[937]: PAM 2 more authentication failures; logname...ot
你也可以走在相反的方向与此并告诉journalctl ，以显示它的所有信息，无论是否包括不可打印的字符。 我们可以用做-a标志：

journalctl -a
输出到标准输出
缺省情况下， journalctl显示在寻呼机的输出更容易消耗。 如果您在处理文本处理工具的数据计划，但是，你可能希望能够输出到标准输出。

你可以用做--no-pager选项：

journalclt --no-pager
这可以立即管道到处理实用程序或重定向到磁盘上的文件，根据您的需要。

输出格式
如果你正在处理日记帐分录，如上面提到的，你很可能将有一个更容易的分析数据，如果它是在一个更耗格式。 幸运的是，期刊可以根据需要以各种格式显示。 您可以使用做到这一点-o与格式说明选项。

例如，您可以通过输入以下内容在JSON中输出日记帐分录：

journalctl -b -u nginx -o json
{ "__CURSOR" : "s=13a21661cf4948289c63075db6c25c00;i=116f1;b=81b58db8fd9046ab9f847ddb82a2fa2d;m=19f0daa;t=50e33c33587ae;x=e307daadb4858635", "__REALTIME_TIMESTAMP" : "1422990364739502", "__MONOTONIC_TIMESTAMP" : "27200938", "_BOOT_ID" : "81b58db8fd9046ab9f847ddb82a2fa2d", "PRIORITY" : "6", "_UID" : "0", "_GID" : "0", "_CAP_EFFECTIVE" : "3fffffffff", "_MACHINE_ID" : "752737531a9d1a9c1e3cb52a4ab967ee", "_HOSTNAME" : "desktop", "SYSLOG_FACILITY" : "3", "CODE_FILE" : "src/core/unit.c", "CODE_LINE" : "1402", "CODE_FUNCTION" : "unit_status_log_starting_stopping_reloading", "SYSLOG_IDENTIFIER" : "systemd", "MESSAGE_ID" : "7d4958e842da4a758f6c1cdc7b36dcc5", "_TRANSPORT" : "journal", "_PID" : "1", "_COMM" : "systemd", "_EXE" : "/usr/lib/systemd/systemd", "_CMDLINE" : "/usr/lib/systemd/systemd", "_SYSTEMD_CGROUP" : "/", "UNIT" : "nginx.service", "MESSAGE" : "Starting A high performance web server and a reverse proxy server...", "_SOURCE_REALTIME_TIMESTAMP" : "1422990364737973" }

. . .
这对于使用实用程序进行解析很有用。 你可以使用json-pretty格式，其传递给消费者JSON之前得到的数据结构，更好地处理：

journalctl -b -u nginx -o json-pretty
{ "__CURSOR" : "s=13a21661cf4948289c63075db6c25c00;i=116f1;b=81b58db8fd9046ab9f847ddb82a2fa2d;m=19f0daa;t=50e33c33587ae;x=e307daadb4858635", "__REALTIME_TIMESTAMP" : "1422990364739502", "__MONOTONIC_TIMESTAMP" : "27200938", "_BOOT_ID" : "81b58db8fd9046ab9f847ddb82a2fa2d", "PRIORITY" : "6", "_UID" : "0", "_GID" : "0", "_CAP_EFFECTIVE" : "3fffffffff", "_MACHINE_ID" : "752737531a9d1a9c1e3cb52a4ab967ee", "_HOSTNAME" : "desktop", "SYSLOG_FACILITY" : "3", "CODE_FILE" : "src/core/unit.c", "CODE_LINE" : "1402", "CODE_FUNCTION" : "unit_status_log_starting_stopping_reloading", "SYSLOG_IDENTIFIER" : "systemd", "MESSAGE_ID" : "7d4958e842da4a758f6c1cdc7b36dcc5", "_TRANSPORT" : "journal", "_PID" : "1", "_COMM" : "systemd", "_EXE" : "/usr/lib/systemd/systemd", "_CMDLINE" : "/usr/lib/systemd/systemd", "_SYSTEMD_CGROUP" : "/", "UNIT" : "nginx.service", "MESSAGE" : "Starting A high performance web server and a reverse proxy server...", "_SOURCE_REALTIME_TIMESTAMP" : "1422990364737973" }

. . .
以下格式可用于显示：

猫 ：只显示消息字段本身。
出口 ：适合传输或备份二进制格式。
JSON：标准的JSON，每行一个条目。
JSON-漂亮 ：JSON格式的更好的人类可读性
JSON-SSE：JSON格式的输出包装以使兼容添加服务器发送的事件
总之 ：默认的syslog风格输出
短期ISO：增强显示ISO 8601挂钟时间标记的默认格式。
短单调 ：用单调的时间戳的默认格式。
短精确 ：与微秒级精度的默认格式
详细 ：显示了可用于进入每一个领域的杂志，包括那些通常隐藏在内部。
这些选项允许您以最适合您当前需要的任何格式显示日记帐分录。

活动进程监视
该journalctl命令模仿多少管理员使用tail监视活动或近期活动。 此功能内置到journalctl ，允许您访问这些功能，而不必管到另一个工具。

显示最近的日志
要显示的记录集量，则可以使用-n选项，它的工作原理完全一样tail -n 。

默认情况下，它将显示最近的10个条目：

journalctl -n
您可以指定希望看到与后一个数字的条目数-n ：

journalctl -n 20
跟随日志
要积极跟踪日志，因为他们正在写的，你可以使用-f标志。 同样，这个工作，如果你使用有经验，你可能期望tail -f ：

journalctl -f
日志维护
你可能想知道成本是存储我们迄今为止看到的所有数据。 此外，你可能有兴趣清理一些旧的日志和释放空间。

正在查找当前磁盘使用情况
你可以找到的，该杂志目前使用占用的磁盘空间量--disk-usage标志：

journalctl --disk-usage
Journals take up 8.0M on disk.
删除旧日志
如果你想缩小你的日记，你可以在两种不同的方式（可带systemd版218及更高版本）。

如果使用--vacuum-size选项，您可以通过指示尺寸的缩小你的日记。 这将删除旧条目，直到磁盘上占用的总日志空间为所请求的大小：

sudo journalctl --vacuum-size=1G
你可以收缩杂志的另一种方式是提供一个截止时间与--vacuum-time选项。 超过该时间的任何条目将被删除。 这允许您保留在特定时间之后创建的条目。

例如，要保留上一年的条目，您可以键入：

sudo journalctl --vacuum-time=1years
限制日志扩展
您可以配置服务器以限制日志可占用的空间量。 这可以通过编辑来完成/etc/systemd/journald.conf文件。

以下项目可用于限制日记帐增长：

SystemMaxUse= ：指定可以通过在持久存储轴颈使用的最大的磁盘空间。
SystemKeepFree=指定的空间添加日记帐分录到持久性存储时，杂志应该把可用的容量。
SystemMaxFileSize= ：控制大个人日志文件如何被旋转前增长到永久存储。
RuntimeMaxUse= ：指定可以在易失性存储中使用的最大的磁盘空间（内/run文件系统）。
RuntimeKeepFree= ：指定的空间量，以留出用于其他用途写入数据时，以非易失性存储被设置（在内/run文件系统）。
RuntimeMaxFileSize= ：指定一个单独的日志文件可以在易失性存储占用的空间量（内/run旋转前的文件系统）。
通过设置这些值，可以控制如何journald消耗你的服务器上保留空间。