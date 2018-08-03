##docker所有命令,特整理如下：



# docker --help

Usage: docker [OPTIONS] COMMAND [arg...]

       docker daemon [ --help | ... ]

       docker [ -h | --help | -v | --version ]



A self-sufficient runtime for containers.



Options:



  --config=~/.docker              Location of client config files

  

  -D, --debug=false               Enable debug mode

  

  -H, --host=[]                   Daemon socket(s) to connect to

  

  -h, --help=false                Print usage

  

  -l, --log-level=info            Set the logging level

  

  --tls=false                     Use TLS; implied by --tlsverify

  

  --tlscacert=~/.docker/ca.pem    Trust certs signed only by this CA

  

  --tlscert=~/.docker/cert.pem    Path to TLS certificate file

  

  --tlskey=~/.docker/key.pem      Path to TLS key file

  

  --tlsverify=false               Use TLS and verify the remote

  

  -v, --version=false             Print version information and quit



##Commands:

    attach    Attach to a running container

    

              --将终端依附到容器上

              

              1> 运行一个交互型容器

                 [root@localhost ~]# docker run -i -t centos /bin/bash

                 [root@f0a02b473067 /]#

              2> 在另一个窗口上查看该容器的状态

                 [root@localhost ~]# docker ps -a

                 CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS      PORTS       NAMES

                 d4a75f165ce6        centos              "/bin/bash"         5 seconds ago       Up 5 seconds            cranky_mahavira

              3> 退出第一步中运行的容器

                 [root@d4a75f165ce6 /]# exit

                  exit

              4> 查看该容器的状态

                 [root@localhost ~]# docker ps -a

                 CONTAINER ID        IMAGE           COMMAND           CREATED             STATUS                  PORTS    NAMES

                 d4a75f165ce6        centos          "/bin/bash"       2 minutes ago       Exited (0) 23 seconds ago        cranky_mahavira

                 可见此时容器的状态是Exited，那么，如何再次运行这个容器呢？可以使用docker start命令

              5> 再次运行该容器

                 [root@localhost ~]# docker start cranky_mahavira

                 cranky_mahavira

              6> 再次查看该容器的状态

                 [root@localhost ~]# docker ps -a

                 CONTAINER ID        IMAGE          COMMAND             CREATED             STATUS              PORTS      NAMES

                 d4a75f165ce6        centos         "/bin/bash"         6 minutes ago       Up 29 seconds                  cranky_mahavira

                 因为该容器是交互型的，但此刻我们发现没有具体的终端可以与之交互，这时可使用attach命令。

              7 通过attach命令进行交互

                 [root@localhost ~]# docker attach cranky_mahavira

                 [root@d4a75f165ce6 /]#



    build     Build an image from a Dockerfile

              --通过Dockerfile创建镜像



    commit    Create a new image from a container's changes

              --通过容器创建本地镜像

              注意：如果是要push到docker hub中，注意生成镜像的命名

               [root@localhost ~]# docker commit centos_v1 centos:v1

               68ad49c999496cff25fdda58f0521530a143d3884e61bce7ada09bdc22337638

               [root@localhost ~]# docker push centos:v1

               You cannot push a "root" repository. Please rename your repository to <user>/<repo> (ex: <user>/centos)

               用centos:v1就不行，因为它push到docker hub中时，是推送到相应用户下，必须指定用户名。譬如我的用户名是ivictor，则新生成的本地镜像命名为：

               docker push victor/centos:v1，其中v1是tag，可不写，默认是latest



    cp        Copy files/folders from a container to a HOSTDIR or to STDOUT

              --在宿主机和容器之间相互COPY文件

              cp的用法如下：

              Usage:    docker cp [OPTIONS] CONTAINER:PATH LOCALPATH|-

                        docker cp [OPTIONS] LOCALPATH|- CONTAINER:PATH

              需要注意的是-的用法，我在容器新建了两个文本文件，其中一个为test.txt，内容如下：

              root@839866a338db:/# cat test.txt

              123

              456

              789

              另一个文件为test1，txt，内容为：

              root@839866a338db:/# cat test1.txt

              helloworld

              用法一的结果如下：

              [root@localhost ~]# docker cp mysqldb:/test.tar -

              test.tar0100644000000000000000000002400012573523153010736 0ustar0000000000000000test.txt000064400000000000000000000000141257352311101              1267 0ustar  rootroot123

              456

              789

              test1.txt0000644000000000000000000000001312573523124011353 0ustar  rootroothelloworld

              用法二的结果如下：

              [root@localhost ~]# cat test.tar |docker cp - mysqldb:/

              [root@localhost ~]# docker exec -it mysqldb /bin/bash

              root@839866a338db:/# ls

              bin   dev              entrypoint.sh  home  lib64  mnt  proc  run   selinux    sys      test.txt   tmp  var

              boot  docker-entrypoint-initdb.d  etc         lib   media  opt  root  sbin  srv    test.tar  test1.txt  usr

              --容器内新增了两个文件，test.txt和test1.txt，而这正是test.tar里打包的文件



    create    Create a new container

              --创建一个新的容器，注意，此时，容器的status只是Created



    diff      Inspect changes on a container's filesystem

              --查看容器内发生改变的文件，以我的mysql容器为例

               [root@localhost ~]# docker diff mysqldb

               C /root

               A /root/.bash_history

               A /test1.txt

               A /test.tar

               A /test.txt

               C /run

               C /run/mysqld

               A /run/mysqld/mysqld.pid

               A /run/mysqld/mysqld.sock

               不难看出，C对应的均是目录，A对应的均是文件



    events    Get real time events from the server

              --实时输出Docker服务器端的事件，包括容器的创建，启动，关闭等。

              譬如：

              [root@localhost ~]# docker events

              2015-09-08T17:40:13.000000000+08:00 d2a2ef5ddb90b505acaf6b59ab43eecf7eddbd3e71f36572436c34dc0763db79: (from wordpress) create

              2015-09-08T17:40:14.000000000+08:00 d2a2ef5ddb90b505acaf6b59ab43eecf7eddbd3e71f36572436c34dc0763db79: (from wordpress) die

              2015-09-08T17:42:10.000000000+08:00 839866a338db6dd626fa8eabeef53a839e4d2e2eb16ebd89679aa722c4caa5f7: (from mysql) start



    exec      Run a command in a running container

              --用于容器启动之后，执行其它的任务

              通过exec命令可以创建两种任务：后台型任务和交互型任务

              后台型任务：docker exec -d cc touch 123  其中cc是容器名

              交互型任务：

              [root@localhost ~]# docker exec -i -t cc /bin/bash

              root@1e5bb46d801b:/# ls

              123  bin  boot  dev  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var



    export    Export a container's filesystem as a tar archive

              --将容器的文件系统打包成tar文件

              有两种方式：

              docker export -o mysqldb1.tar mysqldb

              docker export mysqldb > mysqldb.tar



    history   Show the history of an image

              --显示镜像制作的过程，相当于dockfile



    images    List images

              --列出本机的所有镜像



    import    Import the contents from a tarball to create a filesystem image

              --根据tar文件的内容新建一个镜像，与之前的export命令相对应

             [root@localhost ~]# docker import mysqldb.tar mysql:v1

             eb81de183cd94fd6f0231de4ff29969db822afd3a25841d2dc9cf3562d135a10

             [root@localhost ~]# docker images

             REPOSITORY                 TAG                 IMAGE ID            CREATED              VIRTUAL SIZE

             mysql                      v1                  eb81de183cd9        21 seconds ago       281.9 MB



    info      Display system-wide information

              --查看docker的系统信息

              [root@localhost ~]# docker info

              Containers: 3    --当前有3个容器

              Images: 298

              Storage Driver: devicemapper

               Pool Name: docker-253:0-34402623-pool

               Pool Blocksize: 65.54 kB

               Backing Filesystem: xfs

               Data file: /dev/loop0

               Metadata file: /dev/loop1

               Data Space Used: 8.677 GB     --对应的是下面Data loop file大小

               Data Space Total: 107.4 GB

               Data Space Available: 5.737 GB

               Metadata Space Used: 13.4 MB  --对应的是下面Metadata loop file大小

               Metadata Space Total: 2.147 GB

               Metadata Space Available: 2.134 GB

               Udev Sync Supported: true

               Deferred Removal Enabled: false

               Data loop file: /var/lib/docker/devicemapper/devicemapper/data

               Metadata loop file: /var/lib/docker/devicemapper/devicemapper/metadata

               Library Version: 1.02.93-RHEL7 (2015-01-28)

              Execution Driver: native-0.2

              Logging Driver: json-file

              Kernel Version: 3.10.0-229.el7.x86_64

              Operating System: CentOS Linux 7 (Core)

              CPUs: 2

              Total Memory: 979.7 MiB

              Name: localhost.localdomain

              ID: TFVB:BXGQ:VVOC:K2DJ:LECE:2HNK:23B2:LEVF:P3IQ:L7D5:NG2V:UKNL

              WARNING: bridge-nf-call-iptables is disabled

              WARNING: bridge-nf-call-ip6tables is disabled



    inspect   Return low-level information on a container or image

              --用于查看容器的配置信息，包含容器名、环境变量、运行命令、主机配置、网络配置和数据卷配置等。



    kill      Kill a running container

              --强制终止容器

              关于stop和kill的区别，docker stop命令给容器中的进程发送SIGTERM信号，默认行为是会导致容器退出，当然，

              容器内程序可以捕获该信号并自行处理，例如可以选择忽略。而docker kill则是给容器的进程发送SIGKILL信号，该信号将会使容器必然退出。



    load      Load an image from a tar archive or STDIN

              --与下面的save命令相对应，将下面sava命令打包的镜像通过load命令导入



    login     Register or log in to a Docker registry

              --登录到自己的Docker register，需有Docker Hub的注册账号

              [root@localhost ~]# docker login

              Username: ivictor

              Password:

              Email: xxxx@foxmail.com

              WARNING: login credentials saved in /root/.docker/config.json

              Login Succeeded



    logout    Log out from a Docker registry

              --退出登录

              [root@localhost ~]# docker logout

              Remove login credentials for https://index.docker.io/v1/



    logs      Fetch the logs of a container

              --用于查看容器的日志，它将输出到标准输出的数据作为日志输出到docker logs命令的终端上。常用于后台型容器



    pause     Pause all processes within a container

              --暂停容器内的所有进程，

              此时，通过docker stats可以观察到此时的资源使用情况是固定不变的，

              通过docker logs -f也观察不到日志的进一步输出。



    port      List port mappings or a specific mapping for the CONTAINER

              --输出容器端口与宿主机端口的映射情况

              譬如：

              [root@localhost ~]# docker port blog

              80/tcp -> 0.0.0.0:80

              容器blog的内部端口80映射到宿主机的80端口，这样可通过宿主机的80端口查看容器blog提供的服务



    ps        List containers

              --列出所有容器，其中docker ps用于查看正在运行的容器，ps -a则用于查看所有容器。



    pull      Pull an image or a repository from a registry

              --从docker hub中下载镜像



    push      Push an image or a repository to a registry

              --将本地的镜像上传到docker hub中

              前提是你要先用docker login登录上，不然会报以下错误

              [root@localhost ~]# docker push ivictor/centos:v1

              The push refers to a repository [docker.io/ivictor/centos] (len: 1)

              unauthorized: access to the requested resource is not authorized



    rename    Rename a container

              --更改容器的名字



    restart   Restart a running container

              --重启容器



    rm        Remove one or more containers

              --删除容器，注意，不可以删除一个运行中的容器，必须先用docker stop或docker kill使其停止。

              当然可以强制删除，必须加-f参数

              如果要一次性删除所有容器，可使用 docker rm -f `docker ps -a -q`，其中，-q指的是只列出容器的ID



    rmi       Remove one or more images

              --删除镜像



    run       Run a command in a new container

              --让创建的容器立刻进入运行状态，该命令等同于docker create创建容器后再使用docker start启动容器



    save      Save an image(s) to a tar archive

              --将镜像打包，与上面的load命令相对应

              譬如：

              docker save -o nginx.tar nginx



    search    Search the Docker Hub for images

              --从Docker Hub中搜索镜像



    start     Start one or more stopped containers

              --启动容器



    stats     Display a live stream of container(s) resource usage statistics

              --动态显示容器的资源消耗情况，包括：CPU、内存、网络I/O



    stop      Stop a running container

              --停止一个运行的容器



    tag       Tag an image into a repository

              --对镜像进行重命名



    top       Display the running processes of a container

              --查看容器中正在运行的进程



    unpause   Unpause all processes within a container

              --恢复容器内暂停的进程，与pause参数相对应



    version   Show the Docker version information

              --查看docker的版本



    wait      Block until a container stops, then print its exit code

              --捕捉容器停止时的退出码

              执行此命令后，该命令会“hang”在当前终端，直到容器停止，此时，会打印出容器的退出码。



Run 'docker COMMAND --help' for more information on a command.
