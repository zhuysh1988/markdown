## Ubuntu Server 14.04 通过阿里云安装 Docker

-  ##  一 配置 apt 阿里云源
    
    
        cat << EOF > /etc/apt/sources.list 
        deb http://mirrors.aliyun.com/ubuntu/ trusty main restricted
        deb-src http://mirrors.aliyun.com/ubuntu/ trusty main restricted
        deb http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted
        deb-src http://mirrors.aliyun.com/ubuntu/ trusty-updates main restricted
        deb http://mirrors.aliyun.com/ubuntu/ trusty universe
        deb-src http://mirrors.aliyun.com/ubuntu/ trusty universe
        deb http://mirrors.aliyun.com/ubuntu/ trusty-updates universe
        deb-src http://mirrors.aliyun.com/ubuntu/ trusty-updates universe
        deb http://mirrors.aliyun.com/ubuntu/ trusty multiverse
        deb-src http://mirrors.aliyun.com/ubuntu/ trusty multiverse
        deb http://mirrors.aliyun.com/ubuntu/ trusty-updates multiverse
        deb-src http://mirrors.aliyun.com/ubuntu/ trusty-updates multiverse
        deb http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse
        deb-src http://mirrors.aliyun.com/ubuntu/ trusty-backports main restricted universe multiverse
        deb http://security.ubuntu.com/ubuntu trusty-security main restricted
        deb-src http://security.ubuntu.com/ubuntu trusty-security main restricted
        deb http://security.ubuntu.com/ubuntu trusty-security universe
        deb-src http://security.ubuntu.com/ubuntu trusty-security universe
        deb http://security.ubuntu.com/ubuntu trusty-security multiverse
        deb-src http://security.ubuntu.com/ubuntu trusty-security multiverse
        EOF

-  ## 二 升级内核

>Ubuntu 发行版中，LTS（Long-Term-Support）长期支持版本，会获得 5 年的升级
维护支持，这样的版本会更稳定，因此在生产环境中推荐使用 LTS 版本。
>Docker 目前支持的 Ubuntu 版本最低为 12.04 LTS，但从稳定性上考虑，推荐使用
14.04 LTS 或更高的版本。
>Docker 需要安装在 64 位的 x86 平台或 ARM 平台上（如树莓派），并且要求内核
版本不低于 3.10。但实际上内核越新越好，过低的内核版本可能会出现部分功能无
法使用，或者不稳定。
>用户可以通过如下命令检查自己的内核版本详细信息：

        $ uname -a
        Linux device 4.4.0-45-generic #66~14.04.1-Ubuntu SMP Wed Oct 19
        15:05:38 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux
###升级内核
>如果内核版本过低，可以用下面的命令升级系统内核。
###Ubuntu 12.04 LTS
    sudo apt-get install -y --install-recommends linux-generic-lts-trusty

###Ubuntu 14.04 LTS

    sudo apt-get install -y --install-recommends linux-generic-lts-xenial
    
- ## 三 使用阿里云脚本进行安装

>Docker 官方为了简化安装流程，提供了一套安装脚本，Ubuntu 和 Debian 系统可
以使用这套脚本安装：

    curl -sSL https://get.docker.com/ | sh

>执行这个命令后，脚本就会自动的将一切准备工作做好，并且把 Docker 安装在系
统中。
>不过，由于伟大的墙的原因，在国内使用这个脚本可能会出现某些下载出现错误的
情况。国内的一些云服务商提供了这个脚本的修改版本，使其使用国内的 Docker
软件源镜像安装，这样就避免了墙的干扰。

###阿里云的安装脚本
    curl -sSL http://acs-public-mirror.oss-cn-hangzhou.aliyuncs.com/docker-engine/internet | sh -
    
- ## 四 设置阿里云 镜像加速器
###申请自己的加速器地址: 
    https://wscssx7e333ssr7.mirror.aliyuncs.com
###如何使用Docker加速器
####针对Docker客户端版本大于1.10的用户

>您可以通过修改daemon配置文件/etc/docker/daemon.json来使用加速器：

    sudo mkdir -p /etc/docker
    sudo tee /etc/docker/daemon.json <<-'EOF'
    {
      "registry-mirrors": ["https://wssdfsdcxfdf7er7.mirror.aliyuncs.com"]
    }
    EOF
    sudo systemctl daemon-reload
    sudo systemctl restart docker
>针对Docker客户的版本小于等于1.10的用户

>或者想配置启动参数，可以使用下面的命令将配置添加到docker daemon的启动参数中。

####Ubuntu 12.04 14.04的用户

    echo "DOCKER_OPTS=\"\$DOCKER_OPTS --registry-mirror=https://wscx7fdsfsdfer7.mirror.aliyuncs.com\"" | sudo tee -a /etc/default/docker
    sudo service docker restart
####Ubuntu 15.04 16.04的用户

    sudo mkdir -p /etc/systemd/system/docker.service.d
    sudo tee /etc/systemd/system/docker.service.d/mirror.conf <<-'EOF'
    [Service]
    ExecStart=/usr/bin/docker daemon -H fd:// --registry-mirror=https://wscxsdfsdf7er7.mirror.aliyuncs.com
    EOF
    sudo systemctl daemon-reload
    sudo systemctl restart docker
    
### 检查生效
    root@ubuntu:~# ps -ef |grep dockerd
    root      56349      1  0 10:13 ?        00:00:00 /usr/bin/dockerd --registry-mirror=https://wscx7edfsdfr7.mirror.aliyuncs.com --raw-logs
    root      56462  41353  0 10:21 pts/1    00:00:00 grep --color=auto dockerd
    
-  ## 五 获取镜像
### Example : MariaDB
####获取:
    jihongrui@ubuntu:~$ sudo docker pull mariadb:latest
    latest: Pulling from library/mariadb
    10a267c67f42: Pull complete 
    c2dcc7bb2a88: Pull complete 
    17e7a0445698: Pull complete 
    9a61839a176f: Pull complete 
    64675690edb1: Pull complete 
    3de17e251488: Pull complete 
    f814b22b783e: Pull complete 
    733ce1f03439: Pull complete 
    fb7b719835fd: Pull complete 
    e13421f79ac0: Pull complete 
    8d3f82357729: Pull complete 
    a4f4cbdfcf7c: Pull complete 
    Digest: sha256:4b54358541679032f6c3a9d9fc944ad96d77ae72fecd6cb44bf18cf97743da24
    Status: Downloaded newer image for mariadb:latest
####列出镜像:
    jihongrui@ubuntu:~$ sudo docker images
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    mariadb             10.1                98f78d96be9c        5 days ago          395MB
    mariadb             latest              98f78d96be9c        5 days ago          395MB
    
####运行:
    jihongrui@ubuntu:~$ sudo mkdir -p /mysql/data
    jihongrui@ubuntu:~$ sudo docker run --name MariaDB \
    -p 13306:3306 \
    -v /mysql/data:/var/lib/mysql \
    -e MYSQL_ROOT_PASSWORD=mmmmmm \
    -d mariadb:10.1

####停止、启动容器
>首次运行容器后，就可以根据容器名停止、重新启动容器了。
#####停止容器

    $ sudo docker stop MariaDB

#####启动容器

    $ sudo docker start MariaDB

####运行Docker 镜像内的BASH
    sudo docker exec -it MariaDB bash
    root@bc5eb9f16aac:/# cat /etc/mysql/my.cnf |head -n 3
    # MariaDB database server configuration file.
    #
    # You can copy this file to one of:
> 是可以直接编辑配置文件的
#### 查看修改的文件
    jihongrui@ubuntu:~$ sudo docker diff Nginx
    C /root
    A /root/.bash_history
    C /run
    A /run/nginx.pid
    C /usr
    C /usr/share
    C /usr/share/nginx
    C /usr/share/nginx/html
    C /usr/share/nginx/html/index.html
    C /var
    C /var/cache
    C /var/cache/nginx
    A /var/cache/nginx/client_temp
    A /var/cache/nginx/fastcgi_temp
    A /var/cache/nginx/proxy_temp
    A /var/cache/nginx/scgi_temp
    A /var/cache/nginx/uwsgi_temp
    
    
>Docker 提供了一个  docker commit  命令，可以将容器的存储层保存下来成为镜像。
换句话说，就是在原有镜像的基础上，再叠加上容器的存储层，并构成新的镜像。
以后我们运行这个新镜像的时候，就会拥有原有容器最后的文件变化。

    docker commit  的语法格式为：
    docker commit [选项] <容器ID或容器名> [<仓库名>[:<标签>]]
#####我们可以用下面的命令将容器保存为镜像：

    jihongrui@ubuntu:~$ sudo docker commit \
    --author "Hongrui Ji <jihongrui@jsqix.com>" \
    --message "修改了default index.html" \
    Nginx \
    nginx:v2
    sha256:857bde2cfc8cb276bd90d9f31e178a56c943a58778fb1034c88e4970a2ef0006
    jihongrui@ubuntu:~$ 
>其中  --author  是指定修改的作者，而  --message  则是记录本次修改的内容。
这点和  git  版本控制相似，不过这里这些信息可以省略留空。
我们可以在  docker images  中看到这个新定制的镜像：

    jihongrui@ubuntu:~$ sudo docker images
    REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
    nginx               v2                  857bde2cfc8c        2 minutes ago       109MB
    nginx               latest              3448f27c273f        4 days ago          109MB

####查看镜像内的历史记录
>我们还可以用  docker history  具体查看镜像内的历史记录，如果比较
nginx:latest  的历史记录，我们会发现新增了我们刚刚提交的这一层。

    jihongrui@ubuntu:~$ sudo docker history nginx:v2
    IMAGE               CREATED             CREATED BY                                      SIZE                COMMENT
    857bde2cfc8c        4 minutes ago       nginx -g daemon off;                            213B                修改了default index.html
    3448f27c273f        4 days ago          /bin/sh -c #(nop)  CMD ["nginx" "-g" "daem...   0B                  
    <missing>           4 days ago          /bin/sh -c #(nop)  STOPSIGNAL [SIGQUIT]         0B                  
    <missing>           4 days ago          /bin/sh -c #(nop)  EXPOSE 80/tcp                0B                  
    <missing>           4 days ago          /bin/sh -c ln -sf /dev/stdout /var/log/ngi...   22B                 
    <missing>           4 days ago          /bin/sh -c apt-get update  && apt-get inst...   52.2MB              
    
>慎用  docker commit
使用  docker commit  命令虽然可以比较直观的帮助理解镜像分层存储的概念，
但是实际环境中并不会这样使用。
首先，如果仔细观察之前的  docker diff webserver  的结果，你会发现除了真
正想要修改的  /usr/share/nginx/html/index.html  文件外，由于命令的执
行，还有很多文件被改动或添加了。这还仅仅是最简单的操作，如果是安装软件
包、编译构建，那会有大量的无关内容被添加进来，如果不小心清理，将会导致镜
像极为臃肿。
此外，使用  docker commit  意味着所有对镜像的操作都是黑箱操作，生成的镜
像也被称为黑箱镜像，换句话说，就是除了制作镜像的人知道执行过什么命令、怎
么生成的镜像，别人根本无从得知。而且，即使是这个制作镜像的人，过一段时间
后也无法记清具体在操作的。虽然  docker diff  或许可以告诉得到一些线索，
但是远远不到可以确保生成一致镜像的地步。这种黑箱镜像的维护工作是非常痛苦
的。
而且，回顾之前提及的镜像所使用的分层存储的概念，除当前层外，之前的每一层
都是不会发生改变的，换句话说，任何修改的结果仅仅是在当前层进行标记、添
加、修改，而不会改动上一层。如果使用  docker commit  制作镜像，以及后期
修改的话，每一次修改都会让镜像更加臃肿一次，所删除的上一层的东西并不会丢
失，会一直如影随形的跟着这个镜像，即使根本无法访问到™。这会让镜像更加臃
肿。
docker commit  命令除了学习之外，还有一些特殊的应用场合，比如被入侵后保
存现场等。但是，不要使用  docker commit  定制镜像，定制行为应该使用
Dockerfile  来完成。下面的章节我们就来讲述一下如何使用  Dockerfile  定
制镜像。
