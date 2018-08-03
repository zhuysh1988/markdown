Centos 7 设置 SFTP
原创 2017年11月25日 15:00:21 标签：centos /ssh 286
近期要给服务器设置一个SFTP用户，可以上传删除修改的SFTP，但是禁止该用户SSH登录。这里记录下来

先升级
yum update
1
fox.风

创建用户组 sftp
用户组名为sftp

groupadd sftp
1
创建用户 test
例如这个用户名为 test

useradd -G sftp -s /sbin/nologin test 
1
-s 禁止用户ssh登陆 
-G 加入sftp 用户组

创建密码
passwd test 
1
修改配置文件sshd_config
vim /etc/ssh/sshd_config
1
修改为如下

....
##下面这行注释掉
#Subsystem sftp /usr/libexec/openssh/sftp-server
##后面加入
Subsystem sftp internal-sftp
#注意，以下要 放在 本文件的最后行，否则 root用户无法登陆
Match Group sftp
X11Forwarding no
AllowTcpForwarding no
ChrootDirectory %h                      
ForceCommand internal-sftp
1
2
3
4
5
6
7
8
9
10
11
说明 
Match Group sftp 匹配sftp用户组中的用户 
ChrootDirectory %h 只能访问默认的用户目录(自己的目录)，例如 /home/test

设置目录权限
chown root:sftp /home/test
chgrp -R sftp /home/test
chmod -R 755 /home/test
#设置用户可以上传的目录,改目录下允许用户上传删除修改文件及文件夹
mkdir /home/test/upload
chown -R test:sftp /home/test/upload
chmod -R 755 /home/test/upload
1
2
3
4
5
6
7
重启ssh
systemctl restart sshd.service
1
链接
新建一个 终端链接，或者在 FTP 客户端中使用SFTP 模式链接(输入相关的IP用户名及端口)

sftp test@192.1.1.1
1
F&Q
如果报类似以下错误

sftp Connection to  closed by remote host.
或者
Write failed: Broken pipe 
Couldn't read packet: Connection reset by peer 
1
2
3
4
这个就是该用户根目录的权限问题，chown root:sftp /home/test 设置为root用户即可解决，目录权限为755

其他，检测 /etc/selinux/config中SELINUX 是否为SELINUX=disabled，如果不是请改正



CentOS的ssh sftp配置及权限设置 (2013-01-31 14:57:51)转载▼
标签： linux sftp it	分类： linux
从技术角度来分析，几个要求：
1、从安全方面看，sftp会更安全一点
2、线上服务器提供在线服务，对用户需要控制，只能让用户在自己的home目录下活动
3、用户只能使用sftp，不能ssh到机器进行操作

提供sftp服务，可以用系统自带的internal-sftp，也可以使用vsftpd，这里需求不多，直接选用internal-sftp。

限制用户只能在自己的home目录下活动，这里需要使用到chroot，openssh 4.8p1以后都支持chroot，我现在用的是CentOS 6.3，自带的openssh已经是5.3p1，足够了。

可以输入：
# ssh -V  
来查看openssh的版本，如果低于4.8p1，需要自行升级安装，不在这里具体介绍了。

假设，有一个名为sftp的组，这个组中的用户只能使用sftp，不能使用ssh，且sftp登录后只能在自己的home目录下活动

1、创建sftp组
# groupadd sftp  

2、创建一个sftp用户，名为mysftp
# useradd -g sftp -s /bin/false mysftp
# passwd mysftp

3、sftp组的用户的home目录统一指定到/data/sftp下，按用户名区分，这里先新建一个mysftp目录，然后指定mysftp的home为/data/sftp/mysftp

# mkdir -p /data/sftp/mysftp
# usermod -d /data/sftp/mysftp mysftp

4、配置sshd_config
编辑 /etc/ssh/sshd_config

# vim +132 /etc/ssh/sshd_config  
找到如下这行，并注释掉
Subsystem      sftp    /usr/libexec/openssh/sftp-server  

添加如下几行
Subsystem       sftp    internal-sftp  
Match Group sftp  
ChrootDirectory /data/sftp/%u  
ForceCommand    internal-sftp  
AllowTcpForwarding no  
X11Forwarding no  

解释一下添加的几行的意思

Subsystem       sftp    internal-sftp  
这行指定使用sftp服务使用系统自带的internal-sftp

Match Group sftp  
这行用来匹配sftp组的用户，如果要匹配多个组，多个组之间用逗号分割

当然，也可以匹配用户
Match User mysftp
这样就可以匹配用户了，多个用户名之间也是用逗号分割，但我们这里按组匹配更灵活和方便

ChrootDirectory /data/sftp/%u  
用chroot将用户的根目录指定到/data/sftp/%u，%u代表用户名，这样用户就只能在/data/sftp/%u下活动，chroot的含义，可以参考这里：http://www.ibm.com/developerworks/cn/linux/l-cn-chroot/

ForceCommand    internal-sftp  
指定sftp命令

AllowTcpForwarding no  
X11Forwarding no  
这两行，如果不希望该用户能使用端口转发的话就加上，否则删掉

5、设定Chroot目录权限
# chown root:sftp /data/sftp/mysftp
# chmod 755 /data/sftp/mysftp

错误的目录权限设定会导致在log中出现”fatal: bad ownership or modes for chroot directory XXXXXX”的内容

目录的权限设定有两个要点：
1、由ChrootDirectory指定的目录开始一直往上到系统根目录为止的目录拥有者都只能是root
2、由ChrootDirectory指定的目录开始一直往上到系统根目录为止都不可以具有群组写入权限

所以遵循以上两个原则
1）我们将/data/sftp/mysftp的所有者设置为了root，所有组设置为sftp
2）我们将/data/sftp/mysftp的权限设置为755，所有者root有写入权限，而所有组sftp无写入权限

6、建立SFTP用户登入后可写入的目录
照上面设置后，在重启sshd服务后，用户mysftp已经可以登录，但使用chroot指定根目录后，根应该是无法写入的，所以要新建一个目录供mysftp上传文件。这个目录所有者为mysftp，所有组为sftp，所有者有写入权限，而所有组无写入权限

# mkdir /data/sftp/mysftp/upload  
# chown mysftp:sftp /data/sftp/mysftp/upload  
# chmod 755 /data/sftp/mysftp/upload  

7、重启sshd服务

# service sshd restart  

到这里，mysftp已经可以通过sftp客户端登录并可以上传文件到upload目录。
如果还是不能在此目录下上传文件，提示没有权限，检查SElinux是否关闭，可以使用如下指令关闭SElinux
修改/etc/selinux/config文件中的SELINUX="" 为 disabled ，然后重启。或者
# setenforce 0

一开