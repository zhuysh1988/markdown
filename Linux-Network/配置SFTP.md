> 我们有时会遇到这样的需求，限制一个Linux用户，让他只能在指定的目录下进行添加、修改、删除操作，并且只能使用sftp登录服务器，不能用ssh操作。这些可以通过配置sftp服务实现。

* 提供sftp服务的有vsftpd和internal-sftp，这里用的是系统自带的internal-sftp，操作步骤如下：

### 1.创建新用户ui，禁止ssh登录，不创建家目录
```
useradd -s /sbin/nologin -M www
```
### 2.设置用户密码
```
passwd www
```
### 3.创建用户的根目录，用户就只能在此目录下活动
```
mkdir /home/www
```
### 4.设置目录权限，目录的权限设定有两个要点：
目录开始一直往上到系统根目录为止的目录拥有者都只能是root
目录开始一直往上到系统根目录为止都不可以具有群组写入权限
```
chown root:root /home/www
chmod 755 /home/www
```
### 5.配置sshd_config
```
vim /etc/ssh/sshd_config
```
### 6.修改为下面内容，保存退出
```
#注释掉这行
#Subsystem      sftp    /usr/libexec/openssh/sftp-server
#添加在配置文件末尾
Subsystem sftp internal-sftp     #指定使用sftp服务使用系统自带的internal-sftp
Match User www                     #匹配用户，如果要匹配多个组，多个组之间用逗号分割
ChrootDirectory /home/www         #用chroot将指定用户的根目录，chroot的含义：http://www.ibm.com/developerworks/cn/linux/l-cn-chroot/
ForceCommand internal-sftp        #指定sftp命令
X11Forwarding no                #这两行，如果不希望该用户能使用端口转发的话就加上，否则删掉
AllowTcpForwarding no
```
### 7.重启sshd服务
```
service sshd restart
```
### 8.测试：
用户登录后进入的是/home/www即用户根目录，根目录是无法写入的，所以先用root在/home/www新建一个ui目录
```
mkdir /home/www/ui
```
修改目录所有者和权限
```
chown ui:ui /home/www/ui
chmod 777 /home/www/ui
```
```
#可以在其他目录创建软连接指向ui目录
#ln -s  /home/www/ui /www/
```
sftp登录www用户，进入ui目录，即可在/home/www/ui下，对文件进行添加、修改、删除的操作
```
sftp -oPort=22 ui@123.56.18.72
sftp> cd ui
```