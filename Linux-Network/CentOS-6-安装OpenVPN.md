CentOS6搭建OpenVPN服务器

FORM<http://www.linuxidc.com/Linux/2014-11/109588.htm>

>OpenVPN是一个用于创建虚拟专用网络(Virtual Private Network)加密通道的免费开源软件。使用OpenVPN可以方便地在家庭、办公场所、住宿酒店等不同网络访问场所之间搭建类似于局域网的专用网络通道。

>使用OpenVPN配合特定的代理服务器，可用于访问Youtube、FaceBook、Twitter等受限网站，也可用于突破公司的网络限制。

    Ubuntu下OpenVPN客户端配置教程 http://www.linuxidc.com/Linux/2013-06/86562.htm
    
    Ubuntu 10.04搭建OpenVPN http://www.linuxidc.com/Linux/2012-11/74790.htm
    
    Ubuntu 13.04 VPN (OpenVPN) 配置和连接不能同时访问内外网的问题 http://www.linuxidc.com/Linux/2013-07/86899.htm
    
    如何在Linux上用OpenVPN搭建安全的远程网络架构 http://www.linuxidc.com/Linux/2013-11/92646.htm
    
    Ubuntu Server 14.04搭建OpenVPN服务器保护你的隐私生活 http://www.linuxidc.com/Linux/2014-08/105925.htm

##一、服务器端安装及配置

    服务器环境：干净的CentOS6.3 64位系统

    内网IP：10.143.80.116

    外网IP：203.195.xxx.xxx

    OpenVPN版本：OpenVPN 2.3.2 x86_64-RedHat-linux-gnu

###    1、安装前准备

#### 关闭selinux
    setenforce 0
    sed -i '/^SELINUX=/c\SELINUX=disabled' /etc/selinux/config
 
#### 安装openssl和lzo，lzo用于压缩通讯数据加快传输速度
    yum -y install openssl openssl-devel
    yum -y install lzo
     
#### 安装epel源
    rpm -ivh http://mirrors.sohu.com/Fedora-epel/6/x86_64/epel-release-6-8.noarch.rpm
    sed -i 's/^mirrorlist=https/mirrorlist=http/' /etc/yum.repos.d/epel.repo

###    2、安装及配置OpenVPN和easy-rsa

#### 安装openvpn和easy-rsa
    yum -y install openvpn easy-rsa
     
#### 修改vars文件
    cd /usr/share/easy-rsa/2.0/
    vim vars
    
#### 修改注册信息，比如公司地址、公司名称、部门名称等。
    export KEY_COUNTRY="CN"
    export KEY_PROVINCE="Shandong"
    export KEY_CITY="Qingdao"
    export KEY_ORG="MyOrganization"
    export KEY_EMAIL="me@myhost.mydomain"
    export KEY_OU="MyOrganizationalUnit"
    
#### 初始化环境变量
    source vars
     
#### 清除keys目录下所有与证书相关的文件
#### 下面步骤生成的证书和密钥都在/usr/share/easy-rsa/2.0/keys目录里
    ./clean-all
     
#### 生成根证书ca.crt和根密钥ca.key（一路按回车即可）
    ./build-ca
     
#### 为服务端生成证书和密钥（一路按回车，直到提示需要输入y/n时，输入y再按回车，一共两次）
    ./build-key-server server
     
#### 每一个登陆的VPN客户端需要有一个证书，每个证书在同一时刻只能供一个客户端连接，下面建立2份
#### 为客户端生成证书和密钥（一路按回车，直到提示需要输入y/n时，输入y再按回车，一共两次）
    ./build-key jihongrui

     
#### 创建迪菲·赫尔曼密钥，会生成dh2048.pem文件（生成过程比较慢，在此期间不要去中断它）
    ./build-dh
     
#### 生成ta.key文件（防DDos攻击、UDP淹没等恶意攻击）
    openvpn --genkey --secret keys/ta.key
    


###    3、创建服务器端配置文件

#### 在openvpn的配置目录下新建一个keys目录
    mkdir /etc/openvpn/keys
     
#### 将需要用到的openvpn证书和密钥复制一份到刚创建好的keys目录中
    cp /usr/share/easy-rsa/2.0/keys/{ca.crt,server.{crt,key},dh2048.pem,ta.key} /etc/openvpn/keys/
     
#### 复制一份服务器端配置文件模板server.conf到/etc/openvpn/
    cp /usr/share/doc/openvpn-2.3.2/sample/sample-config-files/server.conf /etc/openvpn/
#### 查看server.conf里的配置参数
    grep '^[^#;]' /etc/openvpn/server.conf
#### 编辑server.conf
###vim /etc/openvpn/server.conf
    
    port 1194
    proto tcp
    dev tun
    ca keys/ca.crt
    cert keys/server.crt
    key keys/server.key  # This file should be kept secret
    dh keys/dh2048.pem
    server 10.10.10.0 255.255.255.0
    ifconfig-pool-persist ipp.txt
    push "route 10.10.10.0 255.255.255.0"
    push "route 10.10.10.1"
    push "route 192.168.80.0 255.255.255.0"
    client-to-client
    duplicate-cn
    keepalive 10 120
    tls-auth keys/ta.key 0 # This file is secret
    #cipher AES-256-CBC
    comp-lzo
    persist-key
    persist-tun
    status /var/log/openvpn-status.log
    log-append  /var/log/openvpn.log
    verb 5
    #explicit-exit-notify 1

    
###    4、配置内核和防火墙，启动服务

#### 开启路由转发功能
    sed -i '/net.ipv4.ip_forward/s/0/1/' /etc/sysctl.conf
    sysctl -p
     
#### 配置防火墙，别忘记保存
    iptables -I INPUT -p tcp --dport 1194 -m comment --comment "openvpn" -j ACCEPT
    iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -j MASQUERADE
    service iptables save
     
#### 启动openvpn并设置为开机启动
    service openvpn start
    chkconfig openvpn on
    
###    5、创建客户端配置文件

##### 复制一份client.conf模板命名为client.ovpn
    cp /usr/share/doc/openvpn-2.3.2/sample/sample-config-files/client.conf client.ovpn
#### 编辑client.ovpn
####    vim client.ovpn
    client
    dev tun
    proto tcp
    #proto udp
    
    remote mirrors.jsqix.com 1194
    ;remote my-server-2 1194
    
    resolv-retry infinite
    
    nobind
    
    ;user nobody
    ;group nobody
    
    persist-key
    persist-tun
    ca ca.crt
    cert jihongrui.crt
    key jihongrui.key
    
    remote-cert-tls server
    
    tls-auth ta.key 1
    
    #cipher AES-256-CBC
    
    comp-lzo
    
    verb 5
    
    ;mute 20


##二、Windows客户端安装及配置
    
    <http://openvpn.ustc.edu.cn/> 客户端下载

    客户端系统：Windows7 64位

    内网IP：172.16.4.4

    OpenVPN版本：OpenVPN 2.3.3 Windows 64位

###1、下载安装OpenVPN

    OpenVPN 2.3.3 Windows 32位 安装文件：

    http://swupdate.openvpn.org/community/releases/openvpn-install-2.3.3-I002-i686.exe

    OpenVPN 2.3.3 Windows 64位 安装文件：

    http://swupdate.openvpn.org/community/releases/openvpn-install-2.3.3-I002-x86_64.exe

###2、配置client

    将OpenVPN服务器上的client.ovpn、ca.crt、client1.crt、client1.key、ta.key上传到Windows客户端安装目录下的config文件夹（C:\Program Files\OpenVPN\config）

###3、启动OpenVPN GUI

    在电脑右下角的openvpn图标上右击，选择“Connect”。正常情况下应该能够连接成功，分配正常的IP。
