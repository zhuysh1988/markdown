Docker仓库搭建（Registry + Portus）
1.更新系统：

    yum update -y

2. 安装docker-compos

   yum -y install epel-release    #pip安装包在epel源中
   yum -y install python-pip
   pip install -U docker-compose

3.安装git客户端

  yum install -y git

4.复制Portus安装程序

  git clone https://github.com/SUSE/Portus.git

5.配置Docker安装源

  vi /etc/yum.repos.d/docker.repo
    [dockerrepo]
     name=Docker Repository
    baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
    enabled=1
    gpgcheck=1
    gpgkey=
    https://yum.dockerproject.org/gpg

6.安装docker引擎并启动

   yum cleal all && yum makecache
  yum install -y docker-engine
  systemctl start docker.service
  systemctl enable docker.service

此步如果有保存，请参考下面链接的地址：

http://www.cnblogs.com/amoyzhu/p/5261393.html

7. 安装Portus

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
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39	./compose-setup.sh -e 192.168.0.109
#安装过程中会下载registry、mariadb、rails、ports_web等几个docker镜像
#如果网络不好可以先下载对应的几个docker镜像文件
#然后上传到portus服务器上并用docker load命令加载。
#镜像的具体版本号以实际为准。
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
portus_web          latest              24a654206d8b        2 days ago          1.086 GB
registry            2.3.1               83139345d017        4 months ago        165.8 MB
mariadb             10.0.23             93631b528e67        5 months ago        304.6 MB
rails               4.2.2               99b347e4bbb4        13 months ago       884.5 MB
安装过后会给出相应的登陆信息和客户端需要的操作样例
###################
#     SUCCESS     #
###################

Make sure port 3000 and 5000 are open on host 192.168.0.109

Open http://192.168.0.109:3000 with your browser and perform the following steps:

  1. Create an admin account
  2. You will be redirected to a page where you have to register the registry. In this form:
    - Choose a custom name for the registry.
    - Enter 192.168.0.109:5000 as the hostname.
    - Do *not* check the "Use SSL" checkbox, since this setup is not using SSL.

Perform the following actions on the docker hosts that need to interact with your registry:

  - Ensure the docker daemon is started with the '--insecure-registry 192.168.0.109:5000'
  - Perform the docker login.

To authenticate against your registry using the docker cli do:

  $ docker login -u <portus username> -p <password> -e <email> 192.168.0.109:5000

To push an image to the private registry:

  $ docker pull busybox
  $ docker tag busybox 192.168.0.109:5000/<username>busybox
  $ docker push 192.168.0.109:5000/<username>busybox



8、打开防火墙端口



1
2
3	firewall-cmd --zone=public  --add-port=3000/tcp --permanent
firewall-cmd --zone=public  --add-port=5000/tcp --permanent
systemctl restart firewall.service




9. Portus初始化



连接到本docker仓库（也可以是其他仓库，必须是registry 2.0以上版本）
<ignore_js_op>
10、上传镜像测试
修改文件/lib/systemd/system/docker.service中的ExecStart增加--insecure-registry 192.168.0.109:5000并重启docker服务

1
2	systemctl daemon-reload
systemctl restart docker.service



检查docker服务



1
2	# ps -ef|grep insecure-registry
root     29486     1  0 01:32 ?        00:00:00 /usr/bin/dockerd --insecure-registry 192.168.0.109:5000

11. 重启Portus容器：

docker start portus_db_1 portus_web_1 portus_crono_1 portus_registry_1

12.下载busybox镜像并上传到私有的仓库中（安装结束时有操作提示）

docker pull busybox

从docker官网上下载busybox镜像到本地


docker tag busybox 192.168.0.109:5000/admin/busybox

把刚下载的镜像busybox打上tag（重命名）：192.168.0.109:5000/admin/busybox


docker login -u admin -p admin123 192.168.0.109:5000

登陆私有的镜像仓库


docker push 192.168.0.109:5000/admin/busybox

把本地的tag为192.168.0.109:5000/admin/busybox上传到私有仓库。



检查Portus界面的镜像信息


13.下载镜像测试

    docker pull 192.168.0.109:5000/admin/busybox

 
