##saltstack常用模块及API

###列出当前版本支持的模块
    salt '*' sys.list_modules
>API原理是通过调用master client模块，实例化一个LocalClient对象，再调用cmd()方法来实现的。
以下API实现test.ping的示例：(其他API调用只需要改变cmd即可)

    import salt.client

    client = salt.client.LocalClient()

    ret = client.cmd('*','test.ping)  #cmd内格式：'<操作目标>','<模块>','[参数]'。例：'*','cmd.run',['df -h'] print ret


##常用模块
###Archive模块
    功能：实现系统层面的压缩包调用，支持gzip、gunzip、rar、tar、unrar、unzip等
###示例：
    #采用gunzip解压sourcefile.txt.gz包
    salt '*' archive.gunzip sourcefile.txt.gz

    #采用gzip压缩sourcefile.txt文件
    salt '*' archive.gzip sourcefile.txt
###API调用：
    client.cmd('*','archive.gunzip',['sourcefile.txt.gz'])

##cmd模块
>功能：实现远程的命令行调用执行（默认具备root操作权限，使用时需评估风险）
###示例：
    #获取所欲被控主机的内存使用情况
    salt '*' cmd.run 'free -m'

    #在wx主机上运行test.py脚本，其中script/test.py存放在file_roots指定的目录（默认是在/srv/salt,自定义在/etc/salt/master文件中定义），
    #该命令会做2个动作：首先同步test.py到minion的cache目录；起床运行该脚本 salt 'wx' cmd.script salt://script/test.py

###API调用：
    client.cmd('*','cmd.run',['free -m'])

##cp模块
>功能：实现远程文件、目录的复制，以及下载URL文件等操作
###示例：

    #将被控主机的/etc/hosts文件复制到被控主机本地的salt cache目录（/var/cache/salt/minion/localfiles/）
    salt '*' cp.cache_local_file /etc/hosts

    #将主控端file_roots指定位置下的目录复制到被控主机/minion/目录下
    salt '*' cp.get_dir salt://script/ /minion/

    #将主控端file_roots指定位置下的文件复制到被控主机/minion/test.py文件(file为文件名)
    salt '*' cp.get_dir salt://script/test.py /minion/test.py

    #下载URL内容到被控主机指定位置(/tmp/index.html)
    salt '*' cp.get_url http://www.slashdot.ort /tmp/index.html

###API调用：
    client.cmd('*','cp.get_file',['salt://script/test.py','/minion/test.py'])

##cron模块
>功能：实现被控主机的crontab操作
###示例：

    #查看指定被控主机、root用户的crontab操作
    salt 'wx' cron.raw_cron root

    #为指定被控主机、root用户添加/usr/local/weekly任务zuoye
    salt 'wx' cron.set_job root '*' '*' '*' '*' 1 /usr/local/weekly

    #删除指定被控主机、root用户crontab的/usr/local/weekly任务zuoye
    salt 'wx' cron.rm_job root /usr/local/weekly

###API调用：
    client.cmd('wx','cron.set_job',['root','*','*','*','*',1,'/usr/local/weekly'])

##dnsutil模块
>功能：实现被控主机通用DNS操作

###示例：
    #添加指定被控主机hosts的主机配置项
    salt 'wx' dnsutil.hosts_append /etc/hosts 127.0.0.1 adl.yuk.com,ad2.yuk.com

    #删除指定被控主机的hosts的主机配置项
    salt 'wx' dnsutil.hosts_remove /etc/hosts ad1.yuk.com

###API调用：
    clietn.cmd('wx','dnsutil.hosts_append',['/etc/hosts','127.0.0.1','ad1.yuk.com','ad2.yuk.com'])

##file模块
>功能：被控主机常见的文件操作，包括文件读写、权限、查找、校验
###示例：

    #校验所有被控主机/etc/fstab文件的md5值是否为xxxxxxxxxxxxx,一致则返回True值
    salt '*' file.check_hash /etc/fstab md5=xxxxxxxxxxxxxxxxxxxxx

    #校验所有被控主机文件的加密信息，支持md5、sha1、sha224、shs256、sha384、sha512加密算法
    salt '*' file.get_sum /etc/passwd md5

    #修改所有被控主机/etc/passwd文件的属组、用户权限、等价于chown root:root /etc/passwd
    salt '*' file.chown /etc/passwd root root

    #复制所有被控主机/path/to/src文件到本地的/path/to/dst文件
    salt '*' file.copy /path/to/src /path/to/dst

    #检查所有被控主机/etc目录是否存在，存在则返回True,检查文件是否存在使用file.file_exists方法
    salt '*' file.directory_exists /etc

    #获取所有被控主机/etc/passwd的stats信息
    salt '*' file.stats /etc/passwd

    #获取所有被控主机/etc/passwd的权限mode，如755，644
    salt '*' file.get_mode /etc/passwd

    #修改所有被控主机/etc/passwd的权限mode为0644
    salt '*' file.set_mode /etc/passwd 0644

    #在所有被控主机创建/opt/test目录
    salt '*' file.mkdir /opt/test

    #将所有被控主机/etc/httpd/httpd.conf文件的LogLevel参数的warn值修改为info
    salt '*' file.sed /etc/httpd/httpd.conf 'LogLevel warn' 'LogLevel info'

    #给所有被控主机的/tmp/test/test.conf文件追加内容‘maxclient 100’
    salt '*' file.append /tmp/test/test.conf 'maxclient 100'

    #删除所有被控主机的/tmp/foo文件
    salt '*' file.remove /tmp/foo

###API调用：
    client.cmd('*','file.remove',['/tmp/foo'])

##iptables模块
>功能：被控主机的iptables支持
###示例：

    #在所有被控主机端追加（append）、插入（insert）iptables规则，其中INPUT为输入链
    salt '*' iptables.append filter INPUT rule='-m state --state RELATED,ESTABLISHED -j ACCEPT'
    salt '*' iptables.insert filter INPUT position=3 rule='-m state --state RELATED,ESTABLISHED -j ACCEPT'

    #在所有被控主机删除指定链编号为3（position=3）或指定存在的规则
    salt '*' iptalbes.delete filter INPUT position=3 salt '*' iptables.delete filter INPUT rule='-m state --state RELATEC,ESTABLISHED -j ACCEPT'

    #保存所有被控主机端主机规则到本地硬盘（/etc/sysconfig/iptables）
    salt '*' iptables.save /etc/sysconfig/iptables

###API调用：
    client.cmd('*','iptables.append',['filter','INPUT','rule=\'-p tcp --sport 80 -j ACCEPT\''])

##network模块
>功能：返回被控主机的网络信息
###示例：

    #在指定被控主机获取dig、ping、traceroute目录域名信息
    salt 'wx' network.dig www.qq.com
    salt 'wx' network.ping www.qq.com
    salt 'wx' network.traceroute www.qq.com

    #获取指定被控主机的mac地址
    salt 'wx' network.hwaddr eth0

    #检测指定被控主机是否属于10.0.0.0/16子网范围，属于则返回True
    salt 'wx' network.in_subnet 10.0.0.0/16

    #获取指定被控主机的网卡配置信息
    salt 'wx' network.interfaces

    #获取指定被控主机的IP地址配置信息
    salt 'wx' network.ip_addrs

    #获取指定被控主机的子网信息
    salt 'wx' network.subnets

###API调用：
    client.cmd('wx','network.ip_addrs')

##pkg包管理模块
>功能：被控主机程序包管理，如：yum、apt-getdegn
###示例：

    #为所有被控主机安装PHP环境，根据不同系统发行版调用不同安装工具进行部署，如redhat平台的yum，等价于yum -y install php
    salt '*' pkg.install php

    #卸载所有被控主机的PHP环境
    salt '*' pkg.remove php

    #升级所有被控主机的软件包
    salt '*' pkg.upgrade

###API调用：
    client.cmd('*','pkg.remove',['php'])

###service服务模块
>功能：被控主机程序包服务管理
###示例：

    #开启（enable）、禁用（disable）nginx开机自启动脚本
    salt '*' service.enable nginx
    salt '*' service.disable nginx

    #针对nginx服务的reload、restart、start、stop、status操作
    salt '*' service.reload nginx
    salt '*' service.restart nginx
    salt '*' service.start nginx
    salt '*' service.stop nginx
    salt '*' service.status nginx

###API调用：
    client.cmd('*','service.stop',['nginx'])

##其他模块
###除了上述模块外，saltstack还提供了:

    user(系统用户模块）
    group（系统组模块）
    partition（系统分区模块）
    puppet（puppet管理模块）
    system（系统重启、关机模块）
    timezone（时区管理模块）
    nginx（nginx管理模块）
    mount（文件系统挂载模块）
###等等。当然我们也可以通过Python扩展模块来满足需求。
