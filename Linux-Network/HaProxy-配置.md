#Example From TCP:



###在/usr/local/haproxy下添加配置文件haproxy.cfg

    修改配置文件内容如下：

    global

        log            127.0.0.1        local0

        log            127.0.0.1        local1 notice

        #log loghost    local0 info

        maxconn         4096

        user            haproxy      #所属运行的用户

        group           haproxy      #所属运行的组

        nbproc          1

        pidfile         /usr/local/haproxy/haproxy1.pid

        #debug

        #quiet



    defaults

        log            global

        option         tcplog

        option         dontlognull

        retries         3

        option          redispatch

        maxconn         4096

        timeout         connect  50000ms

        timeout         client   50000ms

        timeout         server   50000ms



    listen  mariadb-galera

        bind 127.0.0.1:3399  #客户端监听端口

        mode tcp

        balance  leastconn  #最少连接的负载均衡算法

        server   db1  127.0.0.1:3306 check

        server   db1  127.0.0.1:3307 check

        server   db1  127.0.0.1:3308 check



###启动haproxy：

    ./sbin/haproxy -f haproxy.cfg



#####根据最少连接的负载均衡算法，haproxy将读写请求重定向到最少连接的数据库服务器上。
#####
#####检查haproxy是否配置正确：
#####


######先连接上： mariadb@ubuntu:/usr/local/mysql$ ./bin/mysql --host 127.0.0.1 --port 3399 -umycluster -p123456 #注意连接端口为3399，是haproxy服务器的监听端口
######
######
######
######插入一条记录试试：insert into goods(id,name) value (2,'lumia');
######
######Query OK, 1 row affected (0.19 sec)
######
