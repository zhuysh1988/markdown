>【前言】
>最近一直在使用ssh协议的端口转发(隧道）功能，完成对内网空透等。这篇文章将主要讲解3种常用的ssh tunnelling使用方法和基本原理。
>
>在介绍具体内容前，我先奉上端口转发的常用情景：
>

![157769-20160216172911470-1573211582.jpg](http://upload-images.jianshu.io/upload_images/5969055-66f8b4775314eb54.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
>
>图中的“我”，现在是要访问内部网站的192.168.1.0/24网段里面的服务器，然而由于不在一个网段，我是不可以直接ssh到内部网络的服务器。
>
>通常的做法是先ssh到“SSH Server”，然后再在ssh server上访问内部网站的服务器
>
>我能不能不用上ssh server就直接ssh到内部服务器呢？从下面的文章你将得到答案。

 

###SSH 端口转发主要有3种方式：

> ####本地端口转发
> ####格式如下：

    ssh -L [bind_address:]port:host:hostport <user>@<ssh server>
> ####如上图我现在要直接访问IP地址为192.168.1.2的服务器，可以在本地(SSH Client)这样做：

- ###Step 1：

 

    ssh -N -L 11122:192.168.1.2:22 peter@10.1.1.1
    或者：

    ssh -N -L 10.10.10.10:11122:192.168.1.2:22 peter@10.1.1.1
> ####### 如果你想绑定本机特定的IP可以在port前加上IP地址，如上面的10.10.10.10
> ######注意：peter是SSH Server上的一个用户名，“-N” 表示不执行命令，也就是不登录到SSH Server上去。
> ######
> ######输入SSH Server密码,命令会等在那，不要结束这个就行

- ###Step 2:

 

    ssh -p 11122 <192.168.1.2的用户名>@127.0.0.1
    或者：
    
    ssh -p 11122 <192.168.1.2的用户名>@10.10.10.10
     

> #####输入192.168.1.2服务器的密码，就登录了内部网络的192.168.1.2的机器了。

- ###原理分析:

> #####当你执行Step 1的命令时，ssh client程序会在本地监听指定的11122端口，你可以通过下面命令看到
> #####
> #####netstat -ntlp |grep 11122
> #####然后我们在Step 2中，我们ssh其实连接的是本地的11122端口，ssh client程序会帮我们转发到SSH Server的，然后SSH Server再帮我们转发到我们指定的192.168.1.2上的22端口

 

>####远程端口转发
> #####格式如下：

    ssh -R [bind_address:]port:host:hostport <user>@<ssh server>

> #####与 “本地端口转发”最大的不同是，这个命令后，绑定的端口不在是本地的端口，而是SSH Server（10.1.1.1/192.168.1.1)上的端口，
> #####
> #####注意：由于默认配置下，远程SSH Server只能绑定到127.0.0.1地址上，所以SSH Server以外的机器是不能使用到这个端口转发的，解决方法：
> #####
> #####用sudo权限打开SSH Server上的/etc/ssh/sshd_config： sudo vim /etc/ssh/sshd_config ,加入 

    GatewayPorts yes
> #####然后重启ssh service: sudo service ssh restart

- ###Step 1：

        ssh -N -R *:11122:192.168.1.2:22 peter@10.1.1.1
        *是用来表示使用SSH Server的所有地址，你也可以使用10.1.1.1这个地址

- ###Step 2:

        ssh -p 11122 <192.168.1.2上的用户>@10.1.1.1
        注意，跟本地端口转发不同的是，上面的地址和端口都是远程SSH Server的

 

> ####动态端口转发
> ####格式如下：

    ssh -D [bind_address:]port <user>@<ssh server>
 

> #####前面我介绍的两种方式都有一个比较大的问题，只能做到点对点的代理，或者说一个主机的port到另一个主机port上的映射，
> #####
> #####动态端口就是用来解决这个问题的，完成从点到面的代理，或者说完成本机一个port到任意远程地址和端口的映射
> #####
> #####一个比较典型的应用就是web代理服务器，下面我们准备把SSH Server变成一个web代理服务器

- ###Step 1：

    ssh -N -D 3456 peter@10.1.1.1
    注意：现在SSH Client的3456就被用来转发http请求了
    
- ###Step 2：

#### 设置Firefox使用本地127.0.0.1的3456端口来做http代理，如下图设置：


![157769-20160216204615907-1917590548.png](http://upload-images.jianshu.io/upload_images/5969055-ddf09f8ac2796017.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### 注意上图，一定要选择SOCK5 或者SOCK4，因为ssh只能作为SOCK主机而不是一般的HTTP主机代理

#####这样，我们就可以使用SSH Server的代理，用Firefox来访问所有的页面了。

 

###【结尾】
>当然，上面所提到的SSH Client,不一定要Linux主机，也可以是Windows装上putty等ssh客户端，具体设置是，打开putty设置 Connecction->SSH->Tunnels，相信你只要理解上面的内容，设置putty是很简单的事。
