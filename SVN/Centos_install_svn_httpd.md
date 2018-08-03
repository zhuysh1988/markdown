
### centos7搭建SVN+Apache+IF.svnadmin支持https实现web管理SVN

### 1.介绍                                                          

>今天写的是CentOS7上搭建基于Apache,http访问的SVN Server;和IF.svnadmin实现web后台可视化管理SVN

>iF.SVNAdmin应用程序是您的Subversion授权文件的基于Web的GUI。它基于PHP 5.3，需要安装一个Web服务器（Apache）。该应用程序不需要数据库后端或任何类似的，它完全基于Subversion授权和用户认证文件。（+包含用户和组的LDAP支持）

### 2. 软件准备                                                   
 

#### 安装过程如下：

##### 1.安装apache

    [root@localhost ~]# yum install httpd -y

##### 2.安装svn服务器(其中,mod_dav_svn是apache服务器访问svn的一个模块)

    [root@localhost ~]# yum install mod_dav_svn subversion -y

##### 3.安装完成后可以通过如下命令查看是否安装成功

    [root@localhost ~]# httpd -version
    [root@localhost ~]# svnserve --version
    [root@localhost ~]# ls /etc/httpd/modules/ | grep svn

    mod_authz_svn.so 
    mod_dav_svn.so
##### 3.在apache下配置svn 

    [root@localhost ~]# vim /etc/httpd/conf.d/subversion.conf

#### 3. 建立SVN Server仓库                                 
 

>通过如下命令建立svn仓库

>其中/var/www/svn是准备放仓库的目录,这个目录可以放置多个代码仓库


    [root@localhost ~]# mkdir /var/www/svn

    [root@localhost ~]# svnadmin create /var/www/svn/sungeek
    [root@localhost ~]# ls /var/www/svn/sungeek
                --->  conf  db  format  hooks  locks  README.txt
    [root@localhost ~]# chown -R apache.apache /var/www/svn

>创建用户文件passwd和权限控制文件authz
    [root@localhost ~]# touch /var/www/svn/passwd 

    [root@localhost ~]# touch /var/www/svn/authz


 

##### 4. 配置安装PHP&IF.SVNadmin                     

>由于iF.SVNAdmin使用php写的，因此我们需要安装php

    [root@localhost ~]# yum install php -y

>安装配置if.svnadmin

    [root@localhost ~]# wget http://sourceforge.net/projects/ifsvnadmin/files/svnadmin-1.6.2.zip/download
    [root@localhost ~]# cd /usr/src/
    [root@localhost src]# unzip iF.SVNAdmin-stable-1.6.2
    [root@localhost iF.SVNAdmin-stable-1.6.2]# cp -r iF.SVNAdmin-stable-1.6.2/ /var/www/html/svnadmin
    [root@localhost ~]# cd /var/www/html
    [root@localhost html]# chown -R apache.apache svnadmin
    [root@localhost html]# cd /var/www/html/svnadmin
    [root@localhost html]# chmod -R 777 data

 

#### 5.启动服务  

> 如果开启了防火墙, 需要开启httpd访问权限

    [root@localhost ~]# firewall-cmd --permanent --add-service=http
    [root@localhost ~]# firewall-cmd --permanent --add-service=https
    [root@localhost ~]# firewall-cmd --reload　
 
>通过查看文件/usr/lib/systemd/system/svnserve.service, 了解到svnserver的配置文件是/etc/sysconfig/svnserve

##### 修改/etc/sysconfig/svnserve

    [root@localhost ~]# vim /etc/sysconfig/svnserve
    OPTIONS="-r /var/svn"     
    ======> OPTIONS="-r /var/www/svn"　

>通过如下命令来启用服务

    [root@localhost ~]# systemctl start httpd.service

>如下命令使其开机自启动

    [root@localhost ~]# systemctl enable httpd.service

>重启Apache

    [root@localhost ~]# systemctl restart httpd.service

>启动webserver服务后，浏览器地址输入http://ip/svnadmin出现配置界面，输入下图中配置信息，输入每个配置信息可以点击旁边的Test测试是否输入正确，最后保存配置





>保存后，会提示默认的账户为admin/admin。

>登陆后我们可以在“Repositories”下“add”，添加项目目录；

>在"Users"下添加用户；

>在“Access-Paths”下关联对应项目的用户，并分配相关读写权限。

 