mount.cifs 中文手册
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
mount.cifs(8)                                    System Administration                                   mount.cifs(8)


名称
       mount.cifs - 挂载通用网际文件系统(Common Internet File System)


语法
       mount.cifs {service} {mount-point} [-o options]


描述
       这个工具是 samba(7) 软件包的一部分。

       mount.cifs 用于挂载 CIFS 文件系统。它通常由使用"-t cifs"选项的 mount(8) 命令间接调用。
       这个命令只能在支持 CIFS 文件系统的Linux内核上使用。CIFS 协议是 SMB 协议的替代版本，
       它被包括 Windows 在内的几乎所有操作系统所以及 NAS(Network Attached Storage)应用和Samba服务器所支持。

       mount.cifs 可以将 service 表示的 UNC 名称挂载到本地的 mount-point 挂载点上。
       service 使用 //server/share 语法，其中的"server"是主机名或者 IP 地址，而 "share" 是共享名。

       mount.cifs 的选项是用逗号分隔的 key=value 列表。
       除了下面列出的选项外，还可以使用其他选项，只要 cifs 文件系统内核模块(cifs.ko)支持即可。
       不能被 cifs 文件系统内核模块(cifs.ko)识别的选项将会被记录到内核日志中。

       mount.cifs 将会启动一个名为 cifsd 的进程，并保持运行直到该资源被卸载(通常是通过 umount 工具)。

       mount.cifs -V 会显示该程序的版本信息。

       modinfo cifs 会显示 cifs 模块的版本信息。


选项

       user=arg
       username=arg
              指定连接时使用的用户名。如果没有在这里指定，那么将使用环境变量 USER 的值。
              此选项还可以接受"user%pass"或"workgroup/user"或"workgroup/user%pass"的格式，
              以便在指定用户名的同时一起指定口令和工作组。

       pass=arg
       password=arg
              指定连接时使用的口令。如果没有在这里指定，那么将使用环境变量 PASSWD 的值。
              如果没有在命令行参数中给出口令，mount.cifs 将会在挂载时提示用户输入口令。
              需要注意的是，如果口令中含有逗号(,)，那么将不能在命令行参数中指定，因为会发生解析错误。
              不过在环境变量 PASSWD 和 cred 文件(见下文)中可以安全的使用逗号，或者在提示输入口令时也可以安全的输入。

       dom=arg
       domain=arg
              指定user所属的域(工作组)。

       cred=filename
       credentials=filename
              指定一个包含用户名、密码、域(工作组)的文件，可以包含三者之一、之二，或全部包含。该文件的格式如下：

                           username=value
                           password=value
                           domain=value

              这样做比直接在诸如 /etc/fstab 这样的共享文件中以明文方式写出密码要安全的多。请确保该cred文件的安全。

       guest
              不提示输入密码，而以来宾身份登录。

       sec={none|krb5|krb5i|ntlm|ntlmi|ntlmv2|ntlmv2i}
              选择安全模型：
                  none 尝试以空用户连接(不提供用户名)
                  krb5 使用 Kerberos version 5 认证
                  krb5i 使用 Kerberos version 5 和包签名(packet signing)认证
                  ntlm 使用 NTLM 口令散列认证(默认值)
                  ntlmi 使用 NTLM 签名口令散列认证
                         (如果 /proc/fs/cifs/PacketSigningEnabled 被开启或者服务器端要求必须签名时，这个将成为默认值)
                  ntlmv2 使用 NTLMv2 口令散列认证
                  ntlmv2i 使用 NTLMv2 签名口令散列认证

       uid=arg
              如果被挂载的文件系统服务器没有提供文件和目录的UID信息，那么就使用这里的设置。
              arg 可以是字符串形式的用户名或着是数字形式的uid值。默认值是数字'0'。
              更多信息参见下面的“文件和目录的属主及权限”小节。

       forceuid
              忽略服务器提供的文件和目录的UID信息，强制使用 uid= 选项设置的值。
              更多信息参见下面的“文件和目录的属主及权限”小节。

       gid=arg
              如果被挂载的文件系统服务器没有提供文件和目录的GID信息，那么就使用这里的设置。
              arg 可以是字符串形式的组名或着是数字形式的gid值。默认值是数字'0'。
              更多信息参见下面的“文件和目录的属主及权限”小节。

       forcegid
              忽略服务器提供的文件和目录的GID信息，强制使用 gid= 选项设置的值。
              更多信息参见下面的“文件和目录的属主及权限”小节。

       file_mode=0nnn
              如果服务器端不支持 CIFS Unix扩展，那么就使用这里设置的值替代默认的文件权限模式。
              这里的 nnn 是八进制的权限模式，且前导零不能省略。

       dir_mode=0nnn
              如果服务器端不支持 CIFS Unix扩展，那么就使用这里设置的值替代默认的目录权限模式。
              这里的 nnn 是八进制的权限模式，且前导零不能省略。

       setuids
              如果服务器端支持 CIFS Unix扩展，那么客户端将会在新建的文件/目录/设备上为本地进程设置有效UID/GID(effective uid/gid)。
              如果服务器端不支持 CIFS Unix扩展，那么客户端对于新建的文件/目录/设备并不使用命令行上指定的默认UID/GID，
              而是将新建文件的UID/GID缓存在本地，这就意味着文件的UID/GID在重新加载inode或者重新挂载该文件系统之后可能会发生变化。

       nosetuids
              不管服务器端是否支持 CIFS Unix扩展，客户端都不会在新建的文件/目录/设备(create, mkdir, mknod)上设置UID/GID。
              这将导致服务器端按照默认规则设置文件/目录/设备的UID/GID(通常是连接用户的UID/GID)。
              让服务器端(而不是客户端)设置UID/GID是默认行为。
              如果服务器端不支持 CIFS Unix扩展，那么新建文件/目录/设备的UID/GID将显示为连接用户的UID/GID或命令行上指定的UID/GID值。

       perm
              客户端执行权限检查(用 vfs_permission 函数根据 mode 和相应的操作检查 uid/gid )。这个选项是默认开启的。
              注意，这是在服务器端根据连接的用户对客户端操作执行一般的 ACL 检查之外，客户端对自身操作进行的权限检查。

       noperm
              客户端不对自身操作进行任何权限检查。这可能会导致被挂载的服务器端文件系统被本地系统上的其他用户访问。
              这个选项仅在服务器端支持 CIFS Unix扩展，但是客户端和服务器端的UID/GID并不匹配，
              并且无法通过执行挂载操作的用户身份进行访问控制时才需要。
              注意，这个选项并不影响在服务器端根据连接的用户对客户端操作执行一般的 ACL 检查。

       dynperm
              要求服务器端仅在内存中维护 UID/GID 和权限，而不将它们记录到实际的文件系统上。
              这些信息可能会随时丢失(比如从缓存中重新加载inode)，
              所以虽然这个选项可以让某些程序正常工作，但是其实际行为是不可预测的。
              更多信息参见下面的“文件和目录的属主及权限”小节。

       noacl
              即使服务器端支持，也禁用 POSIX ACL 特性。
              CIFS 客户端可以获取和设置 Samba 服务器上的 POSIX ACL ，但是可以通过该选项强制关闭。
              [提示]设置 POSIX ACL 要求客户端内核的 CIFS 模块同时支持 XATTR 和 POSIX 特性

       sfu
              如果服务器端不支持 CIFS Unix扩展，那么就以兼容SFU(Services for Unix)的格式创建设备文件和管道(FIFO)文件。
              也就是通过 SETFILEBITS 属性额外检查文件权限的高 10-12 位(和 SFU 的做法一样)。
              而剩余的低 9 位依然可以用于描述权限(ACL)。

       nounix
              强制关闭 CIFS Unix扩展。这相当于一次性关闭多个选项，
              包括：POSIX ACL, POSIX lock, POSIX path, 服务器端软连接(symlink), 服务器端的 uids/gids/mode 值。
              这个选项也可以用于对 CIFS Unix扩展支持有缺陷的服务器。
              更多信息请参见"INODE编号"小节。

       nouser_xattr
              即使服务器端支持，也不允许 getfattr/setfattr 获取和设置 xattr 。这是默认值。

       ip=arg
              指定目标服务器的IP地址。
              如果 UNC 名称中已经包含了这个信息(包括从DNS中解析得到)，就没必要在这里设置了，所以这个选项很少使用。

       port=num
              设置将要连接的 CIFS 服务器端口。
              如果 CIFS 服务器并未在该端口监听或者未指定此选项，那么将首先尝试默认的 445 端口，如果没有应答就再尝试 139 端口。

       servern=name
       netbiosname=name
              指定服务器的 netbios name (RFC1001 name)。只在连接 Windows 98/ME 服务器(139端口)时才需要这个参数。

       iocharset=charset
              指定默认以什么字符集显示文件名，必须与系统的locale设置保持一致。
              例如在"en_US.UTF-8"的情况下应该使用"utf8"。
              如果没有指定该选项，将使用客户端内核中的 CONFIG_NLS_DEFAULT 值。
              如果服务器端支持Unicode字符，网络路径名将默认使用Unicode字符，
              如果服务器端不支持Unicode字符，那么该选项就没有任何意义。

       ro
              只读挂载

       rw
              读写挂载

       directio
              不对文件的 inode 数据做缓存。这样就不会对文件作内存映射(mmap)。
              在某些具有快速网络连接的情况下，客户端可以从此选项中受益，
              例如，需要进行超长序列读取的应用程序就不需要再次读取相同的数据，
              从而可以比对读写都进行缓冲的默认行为(预读取/后台延迟写入)提供更好的性能。
              该选项允许向服务器发送大于页面尺寸的写操作，
              而且要求内核的 cifs.ko 模块在编译时开启了 CIFS_EXPERIMENTAL 选项。

       mapchars
              将7个保留字符(\:?|*><)中的6个(不包括反斜杠)重新映射到新的字符(高于0xF000)。
              这样就允许客户端可以识别 Windows POSIX 模拟层创建的包含这些保留字符的文件名。
              该选项还可以用于将文件名中包含保留字符的文件系统挂载到同样禁止使用保留字符的 Samba 服务器。
              注意，在使用了此选项挂载的文件系统上创建的文件可能在不使用此选项挂载的情况下无法访问。
              该选项对于不支持 Unicode 的服务器没有意义。

       nomapchars
              不对7个保留字符做任何重新映射。这是默认值。

       intr
              当前尚未实现

       nointr
              当前尚未实现(默认值)

       hard
              当服务器端失去响应后访问其上文件的应用程序将被挂起。

       soft
              (默认值)当服务器端失去响应后访问其上文件的应用程序将收到一个错误信号而不是被挂起。

       nocase
              对路径名进行大小写无关的匹配(在服务器端支持的情况下，大小写敏感的匹配是默认值)。

       nobrl
              不向服务器发送对 byte range lock 的请求。
              对于某些不遵守 cifs 风格的 byte range lock 规范的应用程序来说，这个选项是必须的。
              另一方面，目前大多数 cifs 服务器也尚未实现 advisory byte range lock 。

       serverino
              使用服务器提供的inode编号(连续的、文件唯一标识符)，而不使用客户端自动生成的临时inode编号。
              虽然服务器的inode编号可以很轻易的分辨硬链接文件(它们的inode编号相同)并且保持稳定不变(这对某些程序很有必要)，
              但是当同时挂载多个服务器端文件系统时，依然可能由于inode编号重叠而导致混乱。
              而且，也有少数服务器不支持提供inode编号。如果服务器不能提供inode编号，这个选项就没有任何实际效果。

       noserverino
              使用客户端自动生成的临时inode编号，即使服务器提供了inode编号。这是默认值。
              更多信息参见"INODE编号"小节。

       rsize=num
              默认网络读取尺寸(通常是 16K)。目前还不能使用比 CIFSMaxBufSize 大的值。
              CIFSMaxBufSize 的默认值是 16K 并且可以在加载 cifs.ko 时，
              将其设置为从 8K 到最大允许的 kmalloc 尺寸之间的任意值。
              将 CIFSMaxBufSize 设为一个很大的值将会导致使用更多的内存，并且有可能在某些情况下降低性能。
              使用大于127K(原始cifs协议允许的最大值)的值还需要服务器端的额外支持(比如 Samba 3.0.26 或更高版本)。
              num 的最小值是 2048 ，最大值是 130048(127K)与 CIFSMaxBufSize 中的较小者。

       wsize=num
              默认网络写入尺寸(默认值是57344)。允许的最大值也是57344(14个4K页面)。

       --verbose
              在挂载时输出额外的调试信息。注意，该选项必须在 -o 选项之前使用，也就是这样：
              mount -t cifs //server/share /mnt --verbose -o user=username


SERVICE 的格式和分割符
       通常在 service 中用正斜杠(/)作为分隔符。
       由于正斜杠(/)不能用于Windows平台的文件名中，所以可以被看做"全局分割符"，并被Linux客户端无条件的转换成反斜杠(\)。
       另一方面，由于POSIX标准允许在文件名中使用反斜杠(\)，所以不能自动将其转换为正斜杠(/)。

       mount.cifs 将会在可以转换而不产生混淆的情况下，自动将反斜杠(\)转换成正斜杠(/)。
       但是它不会将共享名(sharename)之后的路径中所包含的反斜杠(\)自动转换成正斜杠(/)。


INODE编号
       如果服务器端支持Unix扩展，并且客户端也允许使用Unix扩展，那么将使用服务器实际提供的inode编号响应 POSIX 调用。

       如果Unix扩展被nounix禁用(或者服务器端本身就不支持)，但同时又开启了"serverino"选项的话，那么将无法获取真正的服务器端inode编号。
       此时客户端将把 server-assigned "UniqueID" 映射到一个inode编号。

       UniqueID 的值和服务器端inode编号是两个不同的值。
       UniqueID 的值在整个服务器范围内是唯一的，其值通常大于232(2的32次方)。
       这个值通常会让不支持LFS(Large File Support)的程序触发一个 glibc EOVERFLOW 错误。
       因此强烈建议你重新编译此程序，并开启LFS支持(也就是 -D_FILE_OFFSET_BITS=64)，以避免这个错误。
       当然，你也可以使用"noserverino"选项来客户端确保生成的inode编号小于232(2的32次方)。
       但是这样做的缺点是无法正确检测到硬链接。


文件和目录的属主及权限
       核心 CIFS 协议并不提供文件和目录的 unix 属主或权限信息。
       正因为如此，文件和目录才会看上去像被 uid= 和 gid= 选项指定的用户和组所拥有，
       并且其权限才会看上去和 file_mode 以及 dir_mode 指定的权限一致。
       可以通过 chmod/chown 来修改这些值，但是并不会在服务器端产生真正的实际效果。

       如果服务器端支持Unix扩展，并且客户端也允许使用Unix扩展，文件和目录的 uid, gid, mode 将由服务器端提供。
       因为 CIFS 通常由同一个用户挂载，所以不管是哪个用户访问此文件系统，所使用的 credentials 文件都是同一个。
       这样，新创建的文件和目录其属主/属组就都根据同一个 credentials 文件中的连接用户来设置。

       如果客户端和服务器端使用的 uid 和 gid 并不匹配，那么 forceuid 和 forcegid 选项就很有用处了。
       注意，并没有强制改写 mode 的选项。
       当指定了 forceuid 和/或 forcegid 后，文件和目录的权限就可能不能反映真正的权限了。

       如果Unix扩展被nounix禁用(或者服务器端本身就不支持)，仍然有可能使用"dynperm"选项在服务器上模拟出来。
       使用该选项后，新创建的文件和目录将看上去拥有了正确的权限。
       不过这些权限并不真正存储在服务器端的文件系统上(仅在内存中)，因此可能会随时丢失(比如内核刷新了inode缓存)。
       因此，我们不鼓励使用此选项。

       还可以使用 noperm 选项在客户端完全越过权限检查。
       但是服务器端的权限检查是无法越过的，服务器端将始终根据 credentials 文件中提供的用户信息进行权限检查，
       而与客户端实际访问文件系统的用户无关。


环境变量
       环境变量 USER 用于指定连接服务器的用户名。该变量也可以使用 username%password 的格式同时给出口令。

       环境变量 PASSWD 用于指定连接服务器的用户密码。

       环境变量 PASSWD_FILE 用于给出读取密码的文件的路径。其中的第一行将被作为密码读取。


注意
       该命令可能只允许 root 使用，除非以 setuid 安装。
       在setuid的情况下，默认将开启 noexec 和 nosuid 挂载标记。
       当安装为 setuid 程序后，该程序就将遵守 mount 程序对于用户挂载限制的约定。

       某些 samba 客户端工具，例如 smbclient(8) ，会根据客户端的配置文件 smb.conf 中的参数决定其行为。
       但是 mount.cifs 与他们不同，它完全无视 smb.conf 的内容。


配置
       修改和读取 CIFS 配置、读取 CIFS 调试信息的首要途径就是 Linux 的 /proc 文件系统。
       /proc/fs/cifs 目录中包含了许多配置和调试信息。
       启动选项(例如最大buffer尺寸和buffer个数)只能在内核加载 cifs.ko 模块的时候指定，
       它们可以通过"modinfo /path/to/cifs.ko"命令看到。
       更多信息参见 Documentation/filesystems/cifs/README 文件。


缺陷
       使用 CIFS URL 进行挂载目前尚未实现。

       credentials 文件目前尚不能处理带有前导空格的 usernames 和 passwords

