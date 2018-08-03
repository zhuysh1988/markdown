> ##使用OpenSSL快速创建TLS/SSL证书
##前言

>在配置Apache，FTP和Email邮件服务器的时候。为了实现安全传输，往往需要用到TLS或SSL服务来为服务器端和客户端建立的连接加密。不熟悉的话，每次配置安装TLS/SSL都得找一番资料。趁有时间索性写一个关于TLS/SSL的快速文档。方便自己的同时，也方便别人。

###理论描述

>SSL(Secure Sockets Layer 安全套接层),及其继任者传输层安全（Transport Layer Security，TLS）用于在两个通信应用程序之间提供保密性和数据完整性的一种安全协议。TLS与SSL在传输层对网络连接进行加密。

####TLS/SSL协议提供的服务主要有：

        认证用户和服务器，确保数据发送到正确的客户机和服务器；  
        加密数据以防止数据中途被窃取；
        维护数据的完整性，确保数据在传输过程中不被改变。

>####操作步骤

>####准备工作

>检查是否正确安装openssl软件包

    [root@nms ~]# rpm -q openssl
    openssl-1.0.0-25.el6_3.1.x86_64
    创建一个新的CA
    
    [root@nms ~]# /etc/pki/tls/misc/CA -newca
    CA certificate filename (or enter to create)  ##按Enter键
    
    Making CA certificate ...
    Generating a 2048 bit RSA private key
    ...................................+++
    ..+++
    writing new private key to '/etc/pki/CA/private/./cakey.pem'  ##生成CA的密钥
    Enter PEM pass phrase:            ##输入一个cakey.pem私钥保护密码
    ###以后，每一次访问cakey.pem都需要输入此密码
    ###输入密码不回显。
    ###一定要记住了，不然没法给其他主机签证书。
    Verifying - Enter PEM pass phrase:    ##重新输入，以验证密码
    -----
    ##接下来给CA自己创建一个证书
    ###填写申请信息。
    You are about to be asked to enter information that will be incorporated
    into your certificate request.
    What you are about to enter is what is called a Distinguished Name or a DN.
    There are quite a few fields but you can leave some blank
    For some fields there will be a default value,
    If you enter '.', the field will be left blank.  
    -----
    Country Name (2 letter code) [XX]:CN    ##CA所在国家
    State or Province Name (full name) []:Beijing   ##省份
    Locality Name (eg, city) [Default City]:Beijing   ##城市
    Organization Name (eg, company) [Default Company Ltd]:Xiyang Liu Group Co., Ltd 
    ###CA公司信息，谁在运作这个CA，谁为信用承保。
    Organizational Unit Name (eg, section) []:NIC  ##部门
    Common Name (eg, your name or your server s hostname) []:ca.xiyang-liu.com 
    ###管理者或者服务器名
    Email Address []:manager@ca.xiyang-liu.com
    ###管理邮箱，或者投诉邮箱，所有签过的证书都有这项信息。
    Please enter the following 'extra' attributes
    to be sent with your certificate request
    A challenge password []:  ##加密CA证书的密码，也要记住，可不输入
    An optional company name []:  ##可以不输入
    Using configuration from /etc/pki/tls/openssl.cnf 
    ##CA给自己签名
    Enter pass phrase for /etc/pki/CA/private/./cakey.pem:   ##输入cakey保护密码
    Check that the request matches the signature  ##检查请求文件的完整性
    Signature ok
    Certificate Details:
            Serial Number:
                b9:48:b2:aa:5b:76:6c:23
            Validity
                Not Before: Dec  6 12:06:42 2012 GMT
                Not After : Dec  6 12:06:42 2015 GMT
            Subject:
                countryName                = CN
                stateOrProvinceName        = Beijing
                organizationName           = Xiyang Liu Group Co., Ltd
                organizationalUnitName     = NIC
                commonName                 = ca.xiyang-liu.com
                emailAddress               = manager@ca.xiyang-liu.com
            X509v3 extensions:
                X509v3 Subject Key Identifier: 
                    EC:1C:4B:FB:82:DB:9C:86:.....47:0F:91:A5:6F:6F:32
                X509v3 Authority Key Identifier: 
                    keyid:EC:1C:4B:FB:82:D.......2:C8:47:0F:91:A5:6F:6F:32
    
                X509v3 Basic Constraints: 
                    CA:TRUE
    Certificate is to be certified until Dec  6 12:06:42 2015 GMT (1095 days)
    
    Write out database with 1 new entries
    Data Base Updated
    创建CA就结束了。总体就三个过程。1.生成一个“绝密”的密钥。2.创建一个签名申请文件。3.自己给自己签名，生成一个标记CA的证书。
    
    上述操作在CA服务器上完成。
    
    CA服务器就是专管授权签名的服务器。简单说，它就是一个说一不二的“老大”。它要为签过的证书承保。如果签过的顾客干坏事了，它有连带责任。所以让CA签名都是收钱的。收的钱越多，从某种程度上说，越有说服力。不收钱的CA，生存不下去，也没人看得起。非常有名的CA有verisign。
    
    创建签名申请
    
    创建一个签名申请，分两个过程。创建一个自己的密钥，然后提交给CA，请求签名。
    
    [root@nms ~]# openssl genrsa -des3 -out my-server.key 1024 
    ### 1024：表示生成DES3加密的1024位的密码
    Generating RSA private key, 1024 bit long modulus
    ......++++++
    ......................++++++
    e is 65537 (0x10001)
    Enter pass phrase for my-server.key:         ##输入一个私钥保护密码
    Verifying - Enter pass phrase for my-server.key:      ##验证输入
    从私钥中生成公钥：（可选，证书里就有，一般不用单独导出来）
    
    [root@nms ~]# openssl rsa -in my-server.key -pubout > my-server-public.key
    Enter pass phrase for my-server.key:   ##输入刚才设定的私钥保护密码
    writing RSA key
    创建证书请求
    
    [root@nms ~]# openssl req -new -key my-server.key -out my-server.csr
    Enter pass phrase for my-server.key:
    You are about to be asked to enter information that will be incorporated
    into your certificate request.
    What you are about to enter is what is called a Distinguished Name or a DN.
    There are quite a few fields but you can leave some blank
    For some fields there will be a default value,
    If you enter '.', the field will be left blank.
    -----
    ##下面的信息是证书请求方的信息，不一定和CA相同。
    ###两者的Common Name一定不能相同，否则CA不能给这个请求签名
    Country Name (2 letter code) [XX]:CN
    State or Province Name (full name) []:Beijing  
    ## State or Province Name必须和CA一致，否则无法签名。
    Locality Name (eg, city) [Default City]:Beijing
    Organization Name (eg, company) [Default Company Ltd]:Xiyang Liu Group Co., Ltd
    ## Organization Name必须和CA一致，否则无法签名。
    Organizational Unit Name (eg, section) []:NIC
    Common Name (eg, your name or your server s hostname) []:nms.xiyang-liu.com 
    Email Address []:manager@nms.xiyang-liu.com
    
    Please enter the following 'extra' attributes
    to be sent with your certificate request
    A challenge password []:PASSW0D1  #可不输入
    An optional company name []:
    两步并作一步走，使用如下命令直接创建一个全新的申请：
    
    openssl req -new -nodes -newkey rsa:1024 -keyout my-server-key.key -out my-server-req.csr -days 365
    -nodes参数表示不加密私钥。如果不添加nodes参数，以后每次使用私钥时都必须输入密码（如Apache每次重启）
    -newkey rsa:1024 指定密钥长度
    -days 365 设定证书有效期为一年，而不是默认的30天。
    填写信息，命令执行完毕，会生成两个文件。自己放好my-server-key.key。把my-server-req.csr发给CA请求签名。不差钱可以发给verisign哦。
    
    在使用证书的主机上操作。可以和CA是一个主机。
    
    CA签名请求
    
    [root@nms ~]# openssl ca -in my-server-req.csr -out my-server-req.crt
    Using configuration from /etc/pki/tls/openssl.cnf
    Enter pass phrase for /etc/pki/CA/private/cakey.pem:  ##输入cakey保护密码
    Check that the request matches the signature
    Signature ok
    Certificate Details:
           Serial Number:
                b9:48:b2:aa:5b:76:6c:24
            Validity
                Not Before: Dec  6 13:51:13 2012 GMT
                Not After : Dec  6 13:51:13 2013 GMT
            Subject:
                countryName               = CN
                stateOrProvinceName       = Beijing
                organizationName          = Xiyang Liu Group Co., Ltd
                organizationalUnitName    = NIC
                commonName                = nms.xiyang-liu.com
                emailAddress              = manager@nms.xiyang-liu.com
            X509v3 extensions:
                X509v3 Basic Constraints: 
                    CA:FALSE
                Netscape Comment: 
                    OpenSSL Generated Certificate
                X509v3 Subject Key Identifier: 
                    36:C4:AB:56:5............5:C2:84:A6:86:15
                X509v3 Authority Key Identifier: 
                    keyid:EC:1C:4B...........F:91:A5:6F:6F:32
    
    Certificate is to be certified until Dec  6 13:51:13 2013 GMT (365 days)
    Sign the certificate? [y/n]:y
    
    1 out of 1 certificate requests certified, commit? [y/n]y
    Write out database with 1 new entries
    Data Base Updated
####创建自签证书

######如果懒到连CA都不想创建，或者不需要建。就执行下面命令直接创建自签证书：
    
    openssl req -x509 -nodes -newkey rsa:1024 
    -keyout my-server-key.key -out my-server.crt
>命令执行结束将只生成crt证书和私钥文件，没有CA的证书。可用于传递电子邮件。

####使用生成的证书

>使用时，对于服务器往往需要CA的证书、密钥文件和签名证书。我们的CA不受系统信任，系统不会集成CA证书。所以需要指定。如果纯粹是私人传输邮件加密用的，则完全何以使用自签名证书。


FROM<　http://www.cnblogs.com/littleatp/p/5878763.html　>
