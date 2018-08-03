>LInux原始的防火墙工具iptables由于过于繁琐,所以ubuntu系统默认提供了一个基于iptable之上的防火墙工具ufw。而UFW支持图形界面操作,只需在命令行运行ufw命令即能看到一系列的操作。接下来,就由专业运营香港服务器、美国服务器、韩国服务器等国外服务器的天下数据为大家介绍ubuntu系统防火墙的开启、关闭等常规操作命令。

##启用ufw
    sudo ufw enable
    sudo ufw default deny
>运行以上两条命令后,开启了防火墙,并在系统启动时自动开启。关闭所有外部对本机的访问,但本机访问外部正常。

##开启和禁用
    sudo ufw allow|deny [service]
##打开或关闭某个端口,例如:
    sudo ufw allow smtp 允许所有的外部IP访问本机的25/tcp (smtp)端口
    sudo ufw allow 22/tcp 允许所有的外部IP访问本机的22/tcp (ssh)端口
    sudo ufw allow 53 允许外部访问53端口(tcp/udp)
    sudo ufw allow from 192.168.1.100 允许此IP访问所有的本机端口
    sudo ufw allow proto udp 192.168.0.1 port 53 to 192.168.0.2 port 53
    sudo ufw deny smtp 禁止外部访问smtp服务
    sudo ufw delete allow smtp 删除上面建立的某条规则

##查看防火墙状态
    sudo ufw status

##允许某特定 IP
    sudo ufw allow from xxx.xxx.xx.xxx

##删除 smtp 端口的许可
    sudo ufw delete allow smtp


##USAGE用法
    [--dry-run]选项，仅显示运行结果而不实际运行


##启动\关闭\重启 
      ufw [--dry-run] enable|disable|reload


##默认策略 允许\拒绝\拒绝并提示 [进入\发出\路由 的数据] 
      ufw [--dry-run] default allow|deny|reject [incoming|outgoing|routed]


##日志 启动\关闭\级别 
      ufw [--dry-run] logging on|off|LEVEL


##重置 
      ufw [--dry-run] reset


##规则、状态 [详细\序号] 
      ufw [--dry-run] status [verbose|numbered]


##显示“报告” 
      ufw [--dry-run] show REPORT


##[删除][插入 第 行] 允许\拒绝\拒绝并提示\限制 [数据 进入\发出][记录\全记录] 端口[/协议] 
      ufw  [--dry-run]  [delete]   [insert   NUM]   allow|deny|reject|limit  [in|out]      [log|log-all] PORT[/PROTOCOL]


##[规则][删除][插入 第 行] 允许\拒绝\拒绝并提示\限制 [数据 进入\发出[网络接口]][记录\全记录] [协议 **][来自**[端口 **]][指向**[端口**] 
      ufw [--dry-run] [rule] [delete] [insert NUM] allow|deny|reject|limit [in|out [on INTERFACE]] [log|log-all]  [proto  PROTOCOL]  [from  ADDRESS  [port  PORT]]  [to  ADDRESS [port PORT]]


##路由[删除][插入 第 行] 允许\拒绝\拒绝并提示\限制 [数据 进入\发出[网络接口]][记录\全记录] [协议 **][来自**[端口 **]][指向**[端口**] 
      ufw  [--dry-run]  route [delete] [insert NUM] allow|deny|reject|limit [in|out on  INTERFACE] [log|log-all] [proto PROTOCOL] [from ADDRESS [port PORT]] [to ADDRESS [port PORT]]


##删除第*行规则 
      ufw [--dry-run] delete NUM


##应用名 列表\信息\默认策略\更新 
      ufw [--dry-run] app list|info|default|update





##OPTIONS选项
      --version
             show program's version number and exit
             显示程序版本并退出

      -h, --help
             show help message and exit
             显示帮助并退出

      --dry-run
             don't modify anything, just show the changes
             不进行更改，仅显示更改内容

      enable 
             reloads firewall and enables firewall on boot.
             重启防火墙，设置为开机启动

      disable
             unloads firewall and disables firewall on boot
             停止防火墙，禁止开机启动

      reload 
             reloads firewall
             重启防火墙

      default allow|deny|reject DIRECTION
             change the default policy for traffic going DIRECTION, where DIRECTION is
             one of incoming, outgoing or routed. Note that existing rules  will  have
             to be migrated manually when changing the default policy. See RULE SYNTAX
             for more on deny and reject.
             改变传入\传出\路由的默认策略。已存在的规则可能需要进行手动修改。关于deny|reject的区别参见 SYNTAX

      logging on|off|LEVEL
             toggle logging. Logged packets use the LOG_KERN syslog facility.  Systems
             configured for rsyslog support may also log to /var/log/ufw.log. Specify‐
             ing a LEVEL turns logging on for the specified  LEVEL.  The  default  log
             level is 'low'.  See LOGGING for details.
             切换记录。日志记录使用的是LOG_KERN系统设备。系统日志保存于/var/log/ufw.log。LEVEL指定不同的级别 ，默认级别是‘低’。参见LOGGING 
      reset 
            Disables  and resets firewall to installation defaults. Can also give the
             --force option to perform the reset without confirmation.
             关闭并重置防火墙至默认安装状态。使用--force选项，无需等待确认。

      status
             show status of firewall and ufw managed rules.  Use  status  verbose  for
             extra  information.  In  the status output, 'Anywhere' is synonymous with
             'any' and '0.0.0.0/0'. Note that when using status,  there  is  a  subtle
             difference when reporting interfaces. For example, if the following rules
             are added:
             显示防火墙状态及规则。使用status  verbose显示额外信息。显示信息中'Anywhere'等同于 'any'和'0.0.0.0/0'。


##需要注意的是报告有些微妙的差异。例如，加入以下规则： 

##允许来自192.168.0.0-192.168.255.255的数据通过eth0网卡进入主机 
               ufw allow in on eth0 from 192.168.0.0/16


##允许指向10.0.0.0-10.255.255.255的数据通过eth1网卡从本机发出 
               ufw allow out on eth1 to 10.0.0.0/8


##允许来自192.168.0.0-192.168.255.255通过eth0网卡收入的数据且指向10.0.0.0-10.255.255.255通过eth1网卡发出的数据经本机路由 
               ufw  route  allow  in  on  eth0  out  on  eth1   to   10.0.0.0/8   from 192.168.0.0/16

             ufw status will output:
             显示信息为：

               To                         Action      From
               --                         ------      ----
               Anywhere on eth0           ALLOW       192.168.0.0/16
               10.0.0.0/8                 ALLOW OUT   Anywhere on eth1
               10.0.0.0/8 on eth1         ALLOW FWD   192.168.0.0/16 on eth0

               指向                        行为        来自
               -----                        ------      ----
              任意地址，网络接口eth0        允许       192.168.0.0/16
               10.0.0.0/8           允许发出            任意地址，网络接口eth1
               10.0.0.0/8域，网络接口eth1       允许路由   192.168.0.0/16域，网络接口eth0

             For the input and output rules, the interface is reported relative to the
             firewall system as an endpoint, whereas with route rules,  the  interface
             is reported relative to the direction packets flow through the firewall.
             进入\发出 规则，（来自\指向）是以防火墙系统为终点的；路由规则，（来自\指向）是相对于通过防火墙的流向。

      show REPORT
             display information about the running firewall. See REPORTS
             显示运行中的防火墙信息。参见REPORTS

      allow ARGS
             add allow rule.  See RULE SYNTAX
             增加允许规则。参见 RULE SYNTAX

      deny ARGS
             add deny rule.  See RULE SYNTAX
             增加拒绝规则。参见 RULE SYNTAX

      reject ARGS
             add reject rule.  See RULE SYNTAX
             增加抵制规则。参见 RULE SYNTAX

      limit ARGS
             add limit rule.  Currently only IPv4 is supported.  See RULE SYNTAX
             增加限制规则。目前仅适用于IPv4。参见 RULE SYNTAX

      delete RULE|NUM
             deletes the corresponding RULE
             删除对应RULE

      insert NUM RULE
             insert the corresponding RULE as rule number NUM
             以规则号NUM插入对应RULE





##RULE SYNTAX规则语法
      Users  can specify rules using either a simple syntax or a full syntax. The sim‐
      ple syntax only specifies the port and optionally the protocol to be allowed  or
      denied on the host. For example:
      用户可以使用简略或完全语法指定规则。简略语法仅指定端口、可选协议被主机允许\拒绝。例如：


##允许使用53端口 
        ufw allow 53

      This rule will allow tcp and udp port 53 to any address on this host. To specify
      a protocol, append '/protocol' to the port. For example:
      规则意为，允许本机通过53端口使用tcp udp协议指向任意地址的信息（一个物理网卡可以包含1或多个IP地址）。指定协议，在端口后加 / 即可。例如：


##允许使用通过tcp协议使用25端口 
        ufw allow 25/tcp

      This will allow tcp port 25 to any address on this host.  ufw  will  also  check
      /etc/services for the port and protocol if specifying a service by name.  Eg:
      规则意为，允许本机通过25端口使用tcp协议指向任意地址（进入）的信息。如果指定服务名称，ufw会通过检查/etc/services文件获得端口、协议信息。例如：


##允许smtp应用 
        ufw allow smtp

      ufw  supports both ingress and egress filtering and users may optionally specify
      a direction of either in or out for either incoming or outgoing traffic.  If  no
      direction is supplied, the rule applies to incoming traffic. Eg:
      ufw同时支持出、入过滤。用户可以使用in\out规定任意方向进出的数据。如果未指定方向，规则将应用于进入的数据。如：


##允许http应用数据进入本机 
        ufw allow in http


##拒绝并告知：拒绝从本机发出smtp应用数据 
        ufw reject out smtp

      Users  can  also  use  a  fuller  syntax,  specifying the source and destination
      addresses and ports. This syntax is loosely based on OpenBSD's  PF  syntax.  For
      example:
      用户也可以使用完整语法，指明来源\目标，地址，端口。该语法是OpenBSD PF语法的简约版。例如：


##拒绝指向任意地址使用80端口tcp协议的数据进入本机 
        ufw deny proto tcp to any port 80

      This will deny all traffic to tcp port 80 on this host. Another example:
      该规则：本机拒绝80端口使用tcp协议指向任意地址（进入）的信息。再如：


##拒绝来自10.0.0.0/8域tcp协议指向192.168.0.1端口25的数据进入本机 
        ufw deny proto tcp from 10.0.0.0/8 to 192.168.0.1 port 25

      This  will deny all traffic from the RFC1918 Class A network to tcp port 25 with
      the address 192.168.0.1.
      该规则将阻断（拒绝）所有来自RFC1918 A级网络（10.0.0.0-10.255.255.255）通过25端口使用tcp协议发送到192.168.0.1的信息。


##拒绝来自 2001:db8::/32域指向任意地址端口25的数据进入本机 
        ufw deny proto tcp from 2001:db8::/32 to any port 25

      This will deny all traffic from the IPv6 2001:db8::/32 to tcp port  25  on  this
      host. IPv6 must be enabled in /etc/default/ufw for IPv6 firewalling to work.
      该规则将拒绝本机接收所有来自IPv6 2001:db8::/32 通过25端口使用tcp（进入）的信息。/etc/default/ufw配置文件需开通IPv6功能。


##允许来自任意地址使用tcp协议指向任意地址使用端口80、443、8080-8090的数据进入本机 
        ufw allow proto tcp from any to any port 80,443,8080:8090

      The  above  will allow all traffic to tcp ports 80, 443 and 8080-8090 inclusive.
      When specifying multiple ports, the ports list must be numeric,  cannot  contain
      spaces  and  must  be  modified  as a whole. Eg, in the above example you cannot
      later try to delete just the '443' port. You cannot specify more than  15  ports
      (ranges count as 2 ports, so the port count in the above example is 4).
      该规则允许本机通过80、443，8080至8090端口使用tcp协议（进入）的信息。指定多个端口时，只能使用数字，且不能含空格。修改规则时需整条规则修改。在上面的例子中，你不能仅仅删除443端口。每次指定不能超过15个端口（端口区间视为2个端口，上面例子视为4个端口）

      Rules  for traffic not destined for the host itself but instead for traffic that
      should be routed/forwarded through the firewall should specify the route keyword
      before  the  rule (routing rules differ significantly from PF syntax and instead
      take into account netfilter FORWARD chain conventions). For example:
      规则中数据目标不是本机，是经本机防火墙路由\转发，规则前需加关键字route（路由规则与PF语法有明显的不同，替之以FORWARD链转换）。


##允许经eth1进入，eth2发出的数据经本机路由 
        ufw route allow in on eth1 out on eth2

      This will allow all traffic routed to eth2 and coming in on eth1 to traverse the
      firewall.
      该规则允许数据由eth1网卡进入路由至eth2网卡发出。


##允许经eth0进入eth1发出指向 12.34.45.67使用80端口tcp的数据经本机路由 
        ufw route allow in on eth0 out on eth1 to 12.34.45.67 port 80 proto tcp

      This  rule  allows any packets coming in on eth0 to traverse the firewall out on
      eth1 to tcp port 80 on 12.34.45.67.
      该规则允许数据经eth0网卡进入路由至eth1网卡通过80端口使用tcp协议发送至IP12.34.45.56？

      In addition to routing rules and policy, you  must  also  setup  IP  forwarding.
      This may be done by setting the following in /etc/ufw/sysctl.conf:
      增加路由规则前必需设置IP转发。该配置文件/etc/ufw/sysctl.conf，配置内容应如下：

        net/ipv4/ip_forward=1
        net/ipv6/conf/default/forwarding=1
        net/ipv6/conf/all/forwarding=1

      then restarting the firewall:
      再使用以下命令重启防火墙：

        ufw disable
        ufw enable

      Be  aware  that  setting  kernel  tunables  is operating system specific and ufw
      sysctl settings may be overridden. See the sysctl manual page for details.
      请小心，该操作系统内核可调参数设置会覆盖ufw内核（sysctl）设置。参见sysctl手册。




      ufw supports connection rate limiting, which is useful  for  protecting  against
      brute-force  login  attacks.  When a limit rule is used, ufw will normally allow
      the connection but will deny connections if an IP address attempts to initiate 6
      or   more  connections  within  30  seconds.  See  http://www.debian-administra‐
      tion.org/articles/187 for details. Typical usage is:
      ufw支持连接次数限制。可用于对抗暴力登录攻击。启用限制规则后，ufw允许连接，但30秒内连接次数高于6次时拒绝该IP访问。参见http://www.debian-administration.org/articles/187。典型用法如下：


##限制ssh tcp协议连接本机次数 
        ufw limit ssh/tcp




      Sometimes it is desirable to let the sender know when traffic is  being  denied,
      rather than simply ignoring it. In these cases, use reject instead of deny.  For
      example:
      有时需要让发送数据者知道数据被拒绝而不是失踪。在下面例子中，用户使用reject替换deny。例如：




        ufw reject auth




      By default, ufw will apply rules to all available  interfaces.  To  limit  this,
      specify  DIRECTION  on INTERFACE, where DIRECTION is one of in or out (interface
      aliases are not supported).  For example, to allow all new incoming http connec‐
      tions on eth0, use:
      默认情况下，ufw将规则应用于所有可用网络接口。也可把规则指定到特定的网络接口，包括网络接口数据进出方向（不支持网络接口别名）。例如允许数据通过eth0网卡使用http协议进入主机，写法如下：



 ##允许通过eth0指向任意地址端口80协议tcp的数据进入本机 
        ufw allow in on eth0 to any port 80 proto tcp




      To  delete  a rule, simply prefix the original rule with delete. For example, if
      the original rule was:
      要删除一条规则，在原规则前加delete就可以了。例如：原规则是这样的

        ufw deny 80/tcp

      Use this to delete it:
      删除时就这样写：

        ufw delete deny 80/tcp

      You may also specify the rule by NUM, as seen in the status numbered output. For
      example, if you want to delete rule number '3', use:
      你也可以使用status numbered参数查看规则序号。比如你想删除第3条规则，这样写就行了：

        ufw delete 3

      If  you  have  IPv6 enabled and are deleting a generic rule that applies to both
      IPv4 and IPv6 (eg 'ufw allow 22/tcp'), deleting by rule number will delete  only
      the  specified  rule.  To delete both with one command, prefix the original rule
      with delete.
      如果IPv6启用，你想删除一条同时适用于IPv4、IPv6的规则（如ufw allow 22/tcp），使用序号删除规则只会删除其中一条。一次性删


##除干净就只能使用原规则前加delete的办法。 
      To insert a rule, specify the new rule as normal, but prefix the rule  with  the
      rule  number  to  insert.  For  example, if you have four rules, and you want to
      insert a new rule as rule number three, use:
      为使用规则正常，你可以使用序号的方式插入新规则。例如，你有4条规则了，但你想把新规则放到第3的位置，可以这样写：把 拒绝来自 10.0.0.135协议tcp指向任意地址端口22的数据进入本机 指条命令插入到第3的位置 
        ufw insert 3 deny to any port 22 from 10.0.0.135 proto tcp

      To see a list of numbered rules, use:
      查询规则序号，使用命令：

        ufw status numbered




      ufw supports per rule logging. By default, no logging is performed when a packet
      matches  a  rule. Specifying log will log all new connections matching the rule,
      and log-all will log all packets matching the rule.  For example, to  allow  and
      log all new ssh connections, use:
      ufw支持规则运行状态日志。默认情况下符合规则的数据日志不显示。指定日志会记录下所有符合规则的数据、新连接。例如：允许并


##记录所有新ssh连接。命令如下 



        ufw allow log 22/tcp

      See LOGGING for more information on logging.
      参见LOGGING





##EXAMPLES例子
      Deny all access to port 53:


##拒绝所有通过53端口的数据 
        ufw deny 53




      Allow all access to tcp port 80:


##允许所有通过80端口使用tcp的数据 
        ufw allow 80/tcp




      Allow all access from RFC1918 networks to this host:


##允许所有来自RFC1918网络的数据进入本机 
        ufw allow from 10.0.0.0/8
        ufw allow from 172.16.0.0/12
        ufw allow from 192.168.0.0/16




      Deny access to udp port 514 from host 1.2.3.4:


##拒绝来自1.2.3.4主机通过514端口使用udp协议的数据 
        ufw deny proto udp from 1.2.3.4 to any port 514




      Allow access to udp 1.2.3.4 port 5469 from 1.2.3.5 port 5469:


##允许来自主机1.2.3.5端口5469的数据到达本机1.2.3.4使用端口5469协议udp 
        ufw allow proto udp from 1.2.3.5 port 5469 to 1.2.3.4 port 5469





##REMOTE MANAGEMENT远程管理
      When  running  ufw enable or starting ufw via its initscript, ufw will flush its
      chains. This is required so ufw can maintain a consistent state, but it may drop
      existing connections (eg ssh). ufw does support adding rules before enabling the
      firewall, so administrators can do:


        通过初始化脚本或命令启动ufw后，ufw将刷新连接。这是为了让ufw运行正常。但可能导致现有连接中断（如ssh）。ufw支持在启动前增加规则，在运行“ufw enable”命令前，管理者可以增加这个规则来进行远程管理： 
        ufw allow proto tcp from any to any port 22

      before running 'ufw enable'. The rules will still be flushed, but the  ssh  port
      will  be  open  after  enabling  the  firewall.  Please  note  that  once ufw is
      'enabled', ufw will not flush the chains when adding or removing rules (but will
      when  modifying  a  rule  or  changing the default policy). By default, ufw will
      prompt when enabling the firewall while running under ssh. This can be  disabled
      by using 'ufw --force enable'.


>所有规则将被激活，ssh连接在启用防火墙时依然开通。请注意只要ufw处于'enabled'状态，增加或删除规则，都不进行连接刷新（改变默认策略或修改规则时除外）。默认情况，ufw如果处于ssh远程连接下，规则影响到ssh连接时都需要确认。使用ufw --force enable命令时，就不需要确认了。 







##APPLICATION INTEGRATION应用集成(强烈推荐此方法)
      ufw   supports   application   integration   by   reading  profiles  located  in
      /etc/ufw/applications.d. To list the names of application profiles known to ufw,
      use:


>ufw支持查询/etc/ufw/applications.d文件完成应用集成。查看ufw已知应用集成（其它端口，由ubuntu在安装软件时自动定义，一般不需要自己新建。具体端口参见/etc/services），命令： 
        ufw app list

      Users  can  specify  an application name when adding a rule (quoting any profile
      names with spaces). For example, when using the simple syntax, users can use:


##用户在增加规则时能使用应用名（引用带有空格的任何配置文件名称）。例如，使用如下简单语法： 
        ufw allow <name>

      Or for the extended syntax:


##或完整语法: 
        ufw allow from 192.168.0.0/16 to any app <name>

      You should not specify the protocol with either syntax, and  with  the  extended
      syntax, use app in place of the port clause.


##使用应用名代替端口时，语法中不能指定协议 
      Details on the firewall profile for a given application can be seen with:


##查看关于应用名的具体内容，使用如下命令。 
        ufw app info <name>

      where  '<name>'  is  one  of  the  applications  seen with the app list command.
      User's may also specify all to see the profiles for all known applications.
      app list命令可以显示有哪些应用名。使用all代替应用名时，上面的命令会例出所有已知程序详细情况。

      After creating or editing an application profile, user's can run:


##增加或编辑了应用名相关内容，请使用下面命刷新： 
        ufw app update <name>

      This command will automatically update the firewall with updated profile  infor‐
      mation.  If  specify  'all' for name, then all the profiles will be updated.  To
      update a profile and add a new rule to the firewall  automatically,  user's  can
      run:


##该命令将自动更新配置应用名。应用名为all时，会更新所有应用名。如果需要更新应用名配置且作为新规则加入防火墙，请使用下面的命令。 
        ufw app update --add-new <name>

      The behavior of the update --add-new command can be configured using:


    --add-new 命令参数进行更新时，其行为方式可由下面的命令指定 
        ufw app default <policy>

      The  default  application  policy is skip, which means that the update --add-new
      command will do nothing. Users may also specify a policy of allow or deny so the
      update --add-new command may automatically update the firewall.  WARNING: it may
      be a security to risk to use a default allow policy  for  application  profiles.
      Carefully  consider the security ramifications before using a default allow pol‐
      icy.


    默认应用策略是跳过，也就意味着 --add-new 命令参数实际上没设定策略。用户能指定策略为allow或deny, 那之后--add-new 参数将自动更新防火墙。警告：使用allow策略作为应用策略将有安全风险。使用默认允许的政策之前，要仔细考虑的安全后果。 




##LOGGING日志
      ufw supports multiple logging levels. ufw defaults to a loglevel of 'low' when a
      loglevel is not specified. Users may specify a loglevel with:


##ufw支持多种日志级别。默认为“低”。用户可使用下面的命令指定日志级别： 
        ufw logging LEVEL

      LEVEL  may  be 'off', 'low', 'medium', 'high' and 'full'. Log levels are defined
      as:


    级别分为 关闭\低\中\高\完全。区别如下： 
      off    disables ufw managed logging


##关闭 关闭日志记录 
      low    logs all blocked packets not matching the default policy (with rate  lim‐
             iting), as well as packets matching logged rules


    低 记录所有被默认策略阻止的数据（速率限制），以及符合规则的数据。 
      medium log  level low, plus all allowed packets not matching the default policy,
             all INVALID packets, and all new connections.  All logging is  done  with
             rate limiting.


    中 低级别+不符合默认策略是数据+无效数据+所有新连接。所有记录在速率限制下进行。 
      high   log level medium (without rate limiting), plus all packets with rate lim‐
             iting


    高 中级（取消速率限制）+速率限制下的所有数据包 
      full   log level high without rate limiting


    完全 高级无速率限制。 



      Loglevels above medium generate a lot of logging output, and may quickly fill up
      your  disk.  Loglevel medium may generate a lot of logging output on a busy sys‐
      tem.


    中级别以可能产生大量日志，有可能快速填满硬盘。对繁忙的系统而言，中级别就会有大量日志产生。 
      Specifying 'on' simply enables logging at log level 'low'  if  logging  is  cur‐
      rently not enabled.


    on参数在没启用日志时，默认指定为低级别。 




##REPORTS报告
      The  following  reports are supported. Each is based on the live system and with
      the exception of the listening report, is in raw iptables format:


###支持如下报告。它们均基于活动系统排外的监听报告，属于原始的iptable形式。 
        raw
        builtins
        before-rules
        user-rules
        after-rules
        logging-rules
        listening
        added

      The raw report shows the complete firewall, while the others show  a  subset  of
      what is in the raw report.


    raw显示完整报告。其它级别在此基础上精简。 
      The  listening report will display the ports on the live system in the listening
      state for tcp and the open state for udp, along with the address of  the  inter‐
      face  and  the  executable listening on the port. An '*' is used in place of the
      address of the interface when the executable is bound to all interfaces on  that
      port. Following this information is a list of rules which may affect connections
      on this port. The rules are listed in the order they are evaluated by  the  ker‐
      nel, and the first match wins. Please note that the default policy is not listed
      and tcp6 and udp6 are shown only if IPV6 is enabled.


    报告显示活动系统监听下的tcp upd状态及地址 网络接口，以及可监听的端口。*号代表该端口绑定到网络接口。该信息之下是所有能影响到该端口连接的规则。规则的监听由内核、第1匹配wins排序。注意默认策略未被监听，tcp6 udp6只有在IPv6启用的情况下有效。 
      The added report displays the list of rules as  they  were  added  on  the  com‐
      mand-line.  This  report  does  not show the status of the running firewall (use
      'ufw status' instead). Because rules are normalized by ufw, rules may look  dif‐
      ferent  than the originally added rule. Also, ufw does not record command order‐
      ing, so an equivalent ordering is used which lists IPv6-only rules  after  other
      rules.


    新增报告将显示规则加入时的命令列表。报告不显示防火墙此时的运行状态（请使用ufw status命查询）。因为规则已被ufw标准化，看起来与加入时原规则不同了。此外，UFW不记录命令排序，所以等效排序，仅IPv6的规则位于其他规则后。 




##NOTES注意
      On  installation,  ufw  is  disabled  with  a default incoming policy of deny, a
      default forward policy of deny, and a default outgoing  policy  of  allow,  with
      stateful  tracking  for  NEW connections for incoming and forwarded connections.
      In addition to the above, a default ruleset is put in place that does  the  fol‐
      lowing:


##安装后，ufw不启动，默认策略：进入数据拒绝，转发拒绝，发出数据允许。默认策略跟踪进入\转发的新连接。除此外还增加了下列默认规则集： 
      - DROP packets with RH0 headers


##丢弃含RH0头的数据 
      - DROP INVALID packets


##丢弃无效数据 
      -  ACCEPT  certain  icmp  packets  (INPUT and FORWARD): destination-unreachable,
      source-quench, time-exceeded, parameter-problem, and echo-request for IPv4. des‐
      tination-unreachable,   packet-too-big,  time-exceeded,  parameter-problem,  and
      echo-request for IPv6.


##接受部分ICMP数据包（进入\转发）：IPv4：目的地不可达，源结束，超过时间，参数问题，回声请求。IPv6：目的地不可达，分组太大而，超过时间，参数问题，回声请求。 
      - ACCEPT icmpv6 packets for stateless autoconfiguration (INPUT)


##接受ICMPv6报文的无状态自动配置（进入） 
      - ACCEPT ping replies from IPv6 link-local (ffe8::/10) addresses (INPUT)


##接受IPv6链路本地地址（ffe8::/10）ping应答（进入） 
      - ACCEPT DHCP client traffic (INPUT)


##接受DHCP客户端数据（进入） 
      - DROP non-local traffic (INPUT)


##丢弃非本地通讯（进入） 
      - ACCEPT mDNS (zeroconf/bonjour/avahi 224.0.0.251  for  IPv4  and  ff02::fb  for
      IPv6) for service discovery (INPUT)


##接受mDNS服务（zeroconf/bonjour/avahi 等协议使用，IPv4 224.0.0.251,IPv6 ff02::fb）（进入） 
      -  ACCEPT  UPnP (239.255.255.250 for IPv4 and ff02::f for IPv6) for service dis‐
      covery (INPUT)


##接受UPnP服务(IPv4：239.255.255.250 ，IPv6：ff02::f ) （进入） 



      Rule ordering is important and the  first  match  wins.  Therefore  when  adding
      rules, add the more specific rules first with more general rules later.


##规则的顺序很重要，依次匹配执行。因此先添加针对性强的规则，再添加影响广泛的规则。 
      ufw  is  not intended to provide complete firewall functionality via its command
      interface, but instead provides an easy way to add or remove simple rules.


##UFW不打算通过自身命令提供完整的防火墙功能，而是提供了一种简单的方法来添加或删除简单的规则。 
      The status command shows basic information about the state of the  firewall,  as
      well as rules managed via the ufw command. It does not show rules from the rules
      files in /etc/ufw. To see the complete state of the firewall, users can ufw show
      raw.  This displays the filter, nat, mangle and raw tables using:


##status命令显示防火墙的状态及通过UFW命令管理的基本信息规则。它不显示/ etc/ UFW文件的规则。要查看防火墙的完整状态，用户可以UFW显示原料。这将显示过滤，NAT，损坏和原始表，命令如下： 
    iptables -n -L -v -x -t <table>
    ip6tables -n -L -v -x -t <table>
      See the iptables and ip6tables documentation for more details.


##更多信息查看iptables ip6tables 
      If  the default policy is set to REJECT, ufw may interfere with rules added out‐
      side of the ufw framework. See README for details.


##如果默认策略设置为REJECT，UFW可能会干扰UFW框架之外添加的规则。 
      IPV6 is allowed by default. To change this behavior to only accept IPv6  traffic
      on  the loopback interface, set IPV6 to 'no' in /etc/default/ufw and reload ufw.
      When IPv6 is enabled, you may specify rules in the same way as for  IPv4  rules,
      and  they will be displayed with ufw status. Rules that match both IPv4 and IPv6
      addresses apply to both IP versions. For example, when IPv6 is enabled, the fol‐
      lowing rule will allow access to port 22 for both IPv4 and IPv6 traffic:


####IPv6是默认允许。改变这种行为，只接受在回环接口上的IPv6数据，在/ etc/default/ UFW将IPv6设置为“no”，并重新加载UFW。 
####当启用IPv6，则可以以相同的方式针对IPv4规则指定的规则，它们将在ufw status命令下被显示。同时匹配IPv4和IPv6地址的规则适用于两个IP版本。
####例如，当启用IPv6，下面的规则将同时允许IPv4和IPv6访问端口22为： 
        ufw allow 22

      IPv6  over  IPv4  tunnels  and  6to4  are supported by using the 'ipv6' protocol
      ('41'). This protocol can only be used with the full syntax. For example:


####IPv4借用IPv6进行封装时，需使用第41号协议。书写时使用proto ipv6，并且使用完整语法。例如： 
        ufw allow to 10.0.0.1 proto ipv6
        ufw allow to 10.0.0.1 from 10.4.0.0/16 proto ipv6

      IPSec is supported by using the 'esp' ('50') and 'ah'  ('51')  protocols.  These
      protocols can only be used with the full syntax. For example:


####支持使用“Internet 协议安全性 (IPSec)”协议，协议书写为esp \ ah（分别是50号\51号协议）。语法必需使用完整结构。例如： 



        ufw allow to 10.0.0.1 proto esp
        ufw allow to 10.0.0.1 from 10.4.0.0/16 proto esp
        ufw allow to 10.0.0.1 proto ah
        ufw allow to 10.0.0.1 from 10.4.0.0/16 proto ah

      In  addition  to the command-line interface, ufw also provides a framework which
      allows administrators to modify default behavior as well as take full  advantage
      of netfilter. See the ufw-framework manual page for more information.


####除了命令行界面，UFW还提供了一个框架，允许管理员修改默认的行为，达到对网络过滤功能充分利用。见UFW-framework手册页了解更多信息。
