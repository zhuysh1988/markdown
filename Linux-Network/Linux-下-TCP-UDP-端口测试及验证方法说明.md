## Linux 下 TCP/UDP 端口测试及验证方法说明
>在云服务器 ECS Linux 系统中，有时需要在系统中测试端口的连通性，以便确认系统的TCP、UDP协议栈是否可以正常运行。本文对此进行简要说明。

###TCP端口测试

>使用 telnet 测试现有监听端口连通性

>可以使用 Linux 自带的 telnet 工具来测试现有端口的连通性，测试命令为：

    telnet <host> <port>
    # host 是目标服务器 IP，port是待测试端口号

####示例：

>可以如下指令测试 22 端口的连通性：

    telnet 127.0.0.1 22

>若成功连接，会显示类似如下信息。不同 Linux 系统环境下，显示可能有所不同，但通常若包含 "Connected to ..." 信息，则说明连接成功。

    Trying 127.0.0.1...
    Connected to 127.0.0.1.
    Escape character is '^]'.
    SSH-2.0-OpenSSH_5.3

>另外， Windows 环境下，成功连接后，会出现一个新窗口（有回显或无任何回显）。 如果连接失败，会显示类似如下信息：

    C:\>telnet 127.0.0.1 1111
    正在连接127.0.0.1...无法打开到主机的连接。 在端口 1111: 连接失败

###创建新的监听端口测试

>可以使用 python 自带的 Web 服务器用于临时创建新的监听端口进行测试。用法如下：

    python -m SimpleHTTPServer <所需端口号>

####示例输出：
    [root@centos]# python -m SimpleHTTPServer 123
    Serving HTTP on 0.0.0.0 port 123 ...
    说明：启动的 Web 服务是单线程的，以当前目录为根目录，一次只能接受一个请求，一般只用来测试。测试完成按 Ctr +C 终止进程即可。

###UDP端口测试

>telnet 仅能用于 TCP 协议的端口测试，若要对UDP端口进行测试，可以使用 nc 程序。

>使用如下指令确认系统内是否已经安装了 nc：

    which nc

####示例输出：
    [root@centos]# which nc
    /usr/bin/nc

>如果 nc 未被安装，根据操作系统的不同， 使用yum 或 apt-get 等工具进行安装，本文不再详述。

####使用如下指令测试目标服务器 UDP 端口的连通性：
####用法：
    nc -vuz <目标服务器 IP> <待测试端口>
####示例输出：
    [root@centos]# nc -vuz 192.168.0.1 25
    Connection to 192.168.0.1 25 port [udp/smtp] succeeded!

>若返回结果中包含 "succeeded" 字样，则说明相应的端口访问正常。如果无任何返回信息，则说明相应端口访问失败。
 

####参数说明：
    -v    详细输出（用两个-v可得到更详细的内容）
    -u    使用UDP传输协议
    -z    让nc只扫描端口，不发送任何的数据 
