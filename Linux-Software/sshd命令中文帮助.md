sshd 中文手册
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
SSHD(8)                 OpenBSD System Manager's Manual                SSHD(8)

名称
     sshd - OpenSSH SSH 守护进程

语法
     sshd [-46Ddeiqt] [-b bits] [-f config_file] [-g login_grace_time]
          [-h host_key_file] [-k key_gen_time] [-o option] [-p port] [-u len]

描述
     sshd 是 OpenSSH SSH 守护进程。用于在不可信网络上提供安全的连接通道。

     sshd 守护进程通常由root用户启动，它监听来自客户端的连接，然后为每个连接派生一个子进程。
     子进程负责处理密钥交换、加密、认证、执行命令、数据交换等具体事务。

     sshd 的行为可以通过使用命令行选项和配置文件(默认是sshd_config(5))进行控制，但命令行选项会覆盖配置文件中的设置。
     sshd 会在收到 SIGHUP 信号后重新读取配置文件，但是最初启动的命令行选项仍然有效(仍会覆盖配置文件中的设置)。

     命令行选项说明：

     -4      强制 sshd 只使用 IPv4 地址

     -6      强制 sshd 只使用 IPv6 地址

     -b bits
             指定使用SSH-1协议时服务器密钥的长度，默认为768

     -D      将 sshd 作为前台进程运行，而不是脱离控制台成为后台守护进程。主要用于调试。

     -d      以调试模式运行。服务器将在前台运行并发送非常详细的调试日志信息，
             服务器将只允许接入一个连接，并且不派生出子进程。仅用于调试目的。
             使用多个 -d 选项可以输出更详细的调试信息(最多3个)。

     -e      将服务器日志消息发送到 stderr 而不是系统日志。

     -f config_file
             指定配置文件的绝对路径，默认值通常是 /etc/ssh/sshd_config 。
             如果配置文件不存在 sshd 将无法启动。

     -g login_grace_time
             要求客户端必须在这个指定的秒数内完成认证，默认为 120 秒。
             如果在指定时间内未完成认证，服务器将断开连接并退出子进程。
             设为零表示没有限制。

     -h host_key_file
             指定使用哪一个主机密钥文件。
             因为主机密钥一般只有root可以读取，所以在服务器以非root运行时通常必须设置此选项。
             对于SSH-1协议，默认值一般是：/etc/ssh/ssh_host_key
             对于SSH-2协议，默认值一般是：/etc/ssh/ssh_host_rsa_key 和 /etc/ssh/ssh_host_dsa_key

     -i      告诉 sshd 它是由 inetd 启动的。
             由于 sshd 在能够应答客户端之前可能需要数十秒来生成服务器密钥，所以一般不使用 inetd 来启动。
             如果每一次都生成新密钥，那么客户端每次都要等候很久。
             当然，如果密钥很短，比如只有512位，那么使用 inetd 也是可行的。

     -k key_gen_time
             指定运行于SSH-1协议时重新生成密钥的周期秒数，默认为3600秒。零表示永不重新生成。
             需要不停的重新生成密钥的原因在于SSH-1协议并未将密钥持久保存在某个地方。
             不断的重新生成密钥也可以降低窃听或主机被入侵等攻击造成的损害。

     -o option
             按照配置文件的格式("指令 值")在命令行上指定某些配置指令的值。
             可以通过多次使用此选项指定多个指令的值。
             有关更多配置指令的解释请查看 sshd_config(5) 手册页。

     -p port
             指定监听端口(默认为22)，可以多次使用此选项监听多个端口。
             如果在命令行上使用了此选项，那么配置文件中的 Port 指令将被忽略。
             但是配置文件中的 ListenAddress 指令又会覆盖这个命令行选项。

     -q      安静模式。不发送任何日志信息。默认情况下每个连接的启动、认证、结束都将被记录。

     -t      测试模式。仅检查配置文件和密钥的有效性。常用于修改过配置文件之后检查其正确性。

     -u len  指定utmp文件中远程主机名字段的最大字符数，如果远程主机名比这个长，那么将使用点分十进制ip地址。
             这就允许名字非常长的主机名也能得到唯一标识。指定"-u0"则表示仅记录点分十进制ip地址。
             "-u0"还能阻止 sshd 进行DNS反向查询，除非认证机制或配置文件要求必须进行DNS查询。
             配置文件中的 RhostsRSAAuthentication, HostbasedAuthentication 指令会要求进行DNS反向查询，
             密钥文件中使用 from="pattern-list" 选项也会要求进行DNS反向查询，
             配置文件中的 AllowUsers 或 DenyUsers 指令中包含 USER@HOST 模式时也会要求进行DNS反向查询。

认证
     OpenSSH 同时支持SSH-1和SSH-2协议，但是可以在配置文件中使用 Protocol 指令指定只支持其中一种或两种都支持。
     SSH-2同时支持RSA和DSA密钥，但是SSH-1仅支持RSA密钥。
     无论哪种协议，每个主机都有一个特定的密钥(默认2048位)用于标识自身。

     对于SSH-1，服务器在启动的时候会生成一个额外的临时密钥(默认768位，不在硬盘保存)，并且通常每小时重新生成一次。
     当客户端发起连接的时候，守护进程使用它的主机公钥应答，客户端将此公钥与先前存储的公钥进行对比，看看是否有变化。
     客户端接着生成一个256位的随机数，并用刚才获得的服务器公钥加密，然后将结果发回给服务器。
     此后双方就使用这个256位的随机数(会话密钥)加密本次会话的所有内容。
     具体的加密算法由客户端在服务器提供的所有可用算法中选择，默认为3DES算法。

     对于SSH-2，则使用 Diffie-Hellman 密钥交换协议商定会话密钥。随后的会话将使用商定的密钥加密，
     具体的加密算法由客户端在服务器提供的所有可用算法中选择(比如AES-256)。
     此外，还使用由双方商定的摘要算法(hmac-md5, hmac-sha1, umac-64, hmac-ripemd160)对数据完整性进行校验。

     接着，客户端将使用服务器认可的认证方法(基于主机的认证、公钥认证、质疑-应答认证、密码认证)之一进行身份认证。

     认证成功后就进入了预备会话的状态，客户端可能会要求分配一个伪终端、X11转发、TCP转发、认证代理转发等。

     然后，客户端可能会要求取得一个shell或执行一个命令，双方进入会话模式，可以在任何时候发送任何数据。
     这些数据将在服务器端的shell或命令与客户终端之间传递。

     当会话结束时，服务器将向客户端发送会话终止信号，双方退出。

登录过程
     当某个用户成功登录后，sshd 将会按照下列顺序做一系列动作：

           1.   如果在一个 tty 登录，并且没有指定执行任何命令，那么将打印上次登录时间和 /etc/motd 的内容。
                /etc/motd 的内容可以通过配置文件或者 ~/.hushlogin 禁止，具体参见下面的"文件"小节。

           2.   如果在一个 tty 登录，那么记录登录时间。

           3.   如果存在 /etc/nologin 文件，并且登录用户不是root，那么打印 /etc/nologin 文件的内容并结束。

           4.   切换身份至非特权用户运行

           5.   设置基本环境变量

           6.   如果配置文件允许用户修改环境变量，则处理 ~/.ssh/environment 文件并设置相应的环境变量
                细节参见 sshd_config(5) 手册页中的 PermitUserEnvironment 指令。

           7.   切换到该用户的家目录

           8.   如果存在 ~/.ssh/rc 文件则运行它，否则运行 /etc/ssh/sshrc (如果存在)。
                如果上面两个都不存在则运行 xauth 程序。参见下面的"SSHRC"小节。

           9.   启动用户的 shell 或运行指定的命令。

SSHRC
     如果存在 ~/.ssh/rc 文件，那么在读取并设置环境变量之后、运行用户shell或命令之前，将会使用sh运行这个文件。
     这个文件不能在 stdout 上产生任何输出，而只能在 stderr 上产生输出。
     如果使用 X11 转发，那么此脚本将从标准输入上收到"proto cookie"对(包含 DISPLAY 环境变量)。
     该脚本必须调用 xauth ，因为 sshd 不会自动运行 xauth 来添加 X11 cookies

     这个文件的主要目的是在访问用户的家目录之前进行一些必要的初始化工作，比如在使用 AFS 的时候。

     这个文件可能会包含类似下面这样的初始化代码：

        if read proto cookie && [ -n "$DISPLAY" ]; then
                if [ `echo $DISPLAY | cut -c1-10` = 'localhost:' ]; then
                        # X11UseLocalhost=yes
                        echo add unix:`echo $DISPLAY |
                            cut -c11-` $proto $cookie
                else
                        # X11UseLocalhost=no
                        echo add $DISPLAY $proto $cookie
                fi | xauth -q -
        fi

     如果此文件不存在，那么将运行 /etc/ssh/sshrc 文件；
     如果 /etc/ssh/sshrc 文件也不存在，那么将使用 xauth 添加 cookie

AUTHORIZED_KEYS 文件格式
     AuthorizedKeysFile 指令指定了用于公钥认证的公钥文件(默认 ~/.ssh/authorized_keys)位置，每行一个公钥。
     此文件中空行和以'#'开头的行将被当作注释忽略。

     SSH-1公钥文件由以下字段组成：选项,位数,exponent(指数),modulus(模数),注释。
     SSH-2公钥文件由以下字段组成：选项,公钥类型,base64编码后的公钥,注释。

     "选项"字段是可选的，取决于该行是否由数字开头("选项"字段不可能由数字开头)。
     "公钥类型"字段的值可以是"ssh-dss"和"ssh-rsa"之一。

     这个文件中允许的最大DSA密钥长度是8192，允许的最大RSA密钥长度是16384位。sshd 强制RSA密钥的最小长度是768位。
     你不需要手工输入这么长的字符串，正确的做法是从 identity.pub, id_dsa.pub或id_rsa.pub 文件中复制。

     "选项"字段由逗号分隔的选项组成，不允许出现任何空格(除非出现在双引号内)。
     当前所有可用的选项及其解释如下：

     command="command"
             指定当这个公钥用于认证时需要额外运行的命令(必须使用引号界定)，如果要在命令中含有引号可以通过反斜杠转义。
             使用这个选项后，由用户提供的命令将被忽略。
             如果客户端请求一个pty，那么这个命令将会在pty上运行，否则将以无终端方式运行。
             如果必须使用8-bit clean(清除字节最高位)通道，那么就不能请求pty或者只能以无终端方式运行。
             这个选项常用来让某个特定的公钥执行特定的任务。比如仅仅将某一个公钥用于执行备份任务。
             需要注意的是，客户端可以指定TCP和/或X11转发，除非它们已经被明确禁止了。
             这个命令最初是由客户端的 SSH_ORIGINAL_COMMAND 环境变量支持的。
             这个选项可以用于在 shell/命令/子系统 中执行。

     environment="NAME=value"
             指定当使用这个公钥登录时，将 NAME 环境变量的值设为 value 。用这种方式设置的环境变量将会覆盖默认的环境变量。
             可以多次使用这个选项指定多个环境变量。
             默认禁止处理环境变量，不过可以通过 PermitUserEnvironment 配置指令进行更改。
             如果启用了 UseLogin ，那么这个选项将被自动禁止。

     from="pattern-list"
             指定在公钥认证之外，远程主机的规范名称还必须被列在"pattern-list"里面。pattern-list 是逗号分隔的主机名列表。
             这个选项的目的主要是为了增加安全性。
             参见ssh_config(5)手册页"模式"小节获取更多模式信息。

     no-agent-forwarding
             当这个公钥用于认证的时候，禁止使用认证代理转发。

     no-port-forwarding
             当这个公钥用于认证的时候，禁止使用TCP转发。任何客户端的端口转发请求都会被拒绝。
             比如在使用 command 选项的时候，就很可能同时需要使用这个选项。

     no-pty  禁止分配终端(客户端要求分配终端的请求将会失败)。

     no-X11-forwarding
             当这个公钥用于认证的时候，禁止使用X11转发(客户端要求X11转发的请求将会失败)。

     permitopen="host:port"
             限制本地"ssh -L"端口转发，这样就只能连接到特定的主机和端口。
             IPv6 地址也可以通过"host/port"这个特别的语法进行指定。
             可以使用多个 permitopen 选项。
             不允许在指定主机名时使用模式匹配，它们必须是精确的域名或ip地址。

     tunnel="n"
             在服务器上强制指定一个 tun(4) 设备。
             没有这个选项的话，当客户端请求一个通道的时候，将会使用下一个可用的设备。

     一个 authorized_keys 文件示范：

        # 这是注释
        ssh-rsa AAAAB3Nza...LiPk== user@example.net
        from="*.sales.example.net,!pc.sales.example.net"    ssh-rsa  AAAAB2...19Q==  john@example.net
        command="dump /home",no-pty,no-port-forwarding      ssh-dss  AAAAC3...51R==  example.net
        permitopen="192.0.2.1:80",permitopen="192.0.2.2:25" ssh-dss  AAAAB5...21S==
        tunnel="0",command="sh /etc/netstart tun0"          ssh-rsa  AAAAE6...6DR==  jane@example.net

SSH_KNOWN_HOSTS 文件格式
     /etc/ssh/ssh_known_hosts 和 ~/.ssh/known_hosts 文件包含所有已知的主机公钥，每行一个公钥。
     全局文件应当由系统管理员维护，每个用户的文件则是自动维护的：
     当用户从一个未知主机连接成功，这个未知主机的公钥将被自动添加到 ~/.ssh/known_hosts 文件中。

     这个文件中的字段格式可以有两种，分别对应SSH-1和SSH-2两种协议。
     SSH-1：主机名,位数,exponent,modulus,注释
     SSH-2：主机名,公钥类型,base64编码后的公钥,注释。
     这些字段之间使用空白符分隔。而以'#'开头的行和空白行都会被当作注释忽略。

     "主机名"字段是一个逗号分隔的模式列表('*'和'?'可以用作通配符)。
     当对客户端进行认证的时候，将使用客户端的规范化主机名按次序对每个模式进行匹配；
     当对服务器进行认证的时候，将使用用户提供的名称按次序对每个模式进行匹配。
     每个模式前都可以加上'!'表示否定：如果某个主机名匹配一个否定模式，那么即使它能够匹配其后的其它模式也会被拒绝。
     主机名或地址还可以使用'['和']'进行界定，并在其后跟随一个':'和一个非标准的端口号。

     "主机名"字段的内容还可以使用散列值存储，以便于隐藏真实的主机名或地址，以增强安全性。
     使用'|'字符开头就表示主机名已经经过散列计算。
     每一行最多只允许出现一个经过散列的主机名，并且不允许对散列值使用前面提到过的通配符(*,?)或否定匹配(!)。

     "位数,exponent,modulus"或"公钥类型,base64编码后的公钥"直接取自RSA主机密钥，
     比如从 /etc/ssh/ssh_host_key.pub 中直接复制。
     可选的"注释"字段并没有什么实际用途，仅仅是为了帮助说明此公钥的相关信息。

     在进行主机认证时，只要有一行匹配就可以通过认证。
     这样同一个主机拥有多个公钥，或者拥有多个主机名(长名、短名)。
     但这个特性也可能会导致该文件中包含相互冲突的信息，而只要有一行匹配就可以通过认证。

     文件中的每一行都很长，你最好直接从 /etc/ssh/ssh_host_key.pub 文件中复制，然后在前面加上主机名。

     下面是一个 ssh_known_hosts 文件的示例：

        # 这是注释
        closenet,...,192.0.2.53 1024 37 159...93 closenet.example.net
        cvs.example.net,192.0.2.10 ssh-rsa AAAA1234.....=
        # 下面是一个经过散列的主机名
        |1|JfKTdBh7rNbXkVAQCRp4OQoPfmI=|USECr3SWf1JUPsms5AqfD5QfxkM=  ssh-rsa  AAAA1234.....=

文件
     ~/.hushlogin
             就算 PrintLastLog 和 PrintMotd 配置指令被开启，
             但是如果这个文件存在，那么也不会打印上次登录时间和 /etc/motd 文件的内容。
             不过它不会阻止打印 Banner 指令要求显示的内容。

     ~/.rhosts
             这个文件用于基于主机的认证(参见 ssh(1) 以获取更多信息)，里面列出允许登录的主机/用户对。
             在某些情况下这个文件可能需要被全局可读，比如用户的家目录位于一个NFS分区上的时候。
             这个文件的属主必须是这个对应的用户，且不能允许其它用户写入。
             大多数情况下推荐的权限是"600"。

     ~/.shosts
             这个文件的用法与 .rhosts 完全一样，只是在允许做基于主机的认证同时防止 rlogin/rsh 登录。

     ~/.ssh/authorized_keys
             存放该用户可以用来登录的 RSA/DSA 公钥。这个文件的格式上面已经描述过了。
             这个文件的内容并不需要十分的保密，但是推荐的权限仍然是"600"。
             如果这个文件、或者其所在目录(~/.ssh)、或者用户的家目录，可以被其他用户写入，
             那么这个文件就可能会被其它未认证用户改写。
             如果权限不对，sshd 默认将不允许使用这个文件进行认证，除非 StrictModes 指令被设为 no 。
             可以通过下面的命令设置合格的权限：chmod go-w ~/ ~/.ssh ~/.ssh/authorized_keys

     ~/.ssh/environment
             这个文件(如果存在)含有在登录时附加定义的环境变量。这个文件的格式很简单：
             空白行和'#'开头的行被忽略，有效行的按照"name=value"的格式每行定义一个变量。
             这个文件的权限也应当是"600"。
             默认是禁止使用这个文件处理环境变量的，但是可以通过 PermitUserEnvironment 配置指令开启。

     ~/.ssh/known_hosts
             包含没有在 /etc/ssh/ssh_known_hosts 中列出的、该用户登录过的主机的公钥。
             这个文件的格式参见前面的内容。这个文件正确的权限应当是"600"。

     ~/.ssh/rc
             在读取并设置环境变量之后、运行用户shell或命令之前，所要执行的初始化动作。
             这个文件正确的权限应当是"600"。

     /etc/hosts.allow
     /etc/hosts.deny
             tcp-wrappers 用于根据源地址执行访问控制，这是其配置文件。更多细节参见 hosts_access(5) 手册页。

     /etc/hosts.equiv
             用于基于主机的认证(参见 ssh(1))。它应当只允许root写入。

     /etc/ssh/moduli
             包含用于"Diffie-Hellman Group Exchange"的 Diffie-Hellman groups 。
             此文件的格式在 moduli(5) 手册页描述。

     /etc/motd
             "motd"的意思是"message of the day"(今日消息)。常用于广播系统范围的重要事件。
             一般在登录系统后、执行登录shell前，由 login 显示其中的内容。
             但如果登录用户的家目录下有 .hushlogin 文件则不显示。

     /etc/nologin
             如果存在这个文件，sshd 将拒绝任何非root用户的登录，并向被拒绝的用户显示此文件的内容。
             此文件必须确保全局可读。

     /etc/shosts.equiv
             这个文件的用法与 hosts.equiv 完全相同，不同仅在于不允许使用 rsh/rlogin 。

     /etc/ssh/ssh_host_key
     /etc/ssh/ssh_host_dsa_key
     /etc/ssh/ssh_host_rsa_key
             这三个文件包含了主机私钥，其属主必须是root，权限应该是"600"。
             如果权限不对，sshd 根本就会拒绝启动。

     /etc/ssh/ssh_host_key.pub
     /etc/ssh/ssh_host_dsa_key.pub
     /etc/ssh/ssh_host_rsa_key.pub
             这三个文件包含了主机公钥，其属主必须是root，权限应该是"644"。
             这些文件中包含的内容必须与相应的私钥文件匹配。
             这些文件事实上并没有被使用，只是为了用户方便才提供这些文件的。
             比如，将公钥添加到 ~/.ssh/authorized_keys 和 /etc/ssh/ssh_known_hosts 文件中。
             这些文件是使用 ssh-keygen(1) 创建的。

     /etc/ssh/ssh_known_hosts
             全局范围的已知主机公钥列表。系统管理员应该把所需主机公钥保存在这个文件中。
             这个文件的格式上文已经有了详细介绍。这个文件的属主应当是root，权限应当是"644"。

     /etc/ssh/sshd_config
             sshd 的全局配置文件。文件格式和可用的配置指令在 sshd_config(5) 手册页介绍。

     /etc/ssh/sshrc
             类似于 ~/.ssh/rc ，但是针对全局有效。这个文件的属主应当是root，权限应当是"644"。

     /var/empty
             sshd 在预认证阶段进行特权分离时，将要切换到的虚根目录。
             此目录当中不能包含任何文件，并且其属主应当是root，权限应当是"000"。

     /var/run/sshd.pid
             存储着 sshd 主监听进程的进程号。
             如果有多个在不同端口监听的主进程，那么这个文件只包含最后一个启动的监听进程的进程号。
             这个文件的内容并不很重要，可以设为全局可读。

参见
     scp(1), sftp(1), ssh(1), ssh-add(1), ssh-agent(1), ssh-keygen(1),
     ssh-keyscan(1), chroot(2), hosts_access(5), login.conf(5), moduli(5),
     sshd_config(5), inetd(8), sftp-server(8)

OpenBSD 4.2                      June 7, 2007                                9
