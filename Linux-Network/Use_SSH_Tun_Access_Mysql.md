###通过SSH 通道转发来访问Mysql

#### 场景:
    Mysql服务器: test.cn
        Mysql_Listen: 127.0.0.1:3306
        SSH_Port: 8888
    Client : local.cn
    
#### SSH通道转发
    ssh -fNg -p 8888 -L 3306:127.0.0.1:3306 User@test.cn
    
    # 检查本地3306端口有没有监听
    ss -lntp |grep '3306'

#### Mysql Client 连接
    mycli -h localhost -P 3306 -u user -p password
    

    