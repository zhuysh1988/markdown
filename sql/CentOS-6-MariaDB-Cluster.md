## 可将cluster 同步方式设置成为
        wsrep_sst_method=xtrabackup  #所有节点都要更改
## xtrabackup 安装 FROM <http://allcmd.com/post/id/198>
### INSTALL MARIADB

    192.168.80.111      node1 db1
    
    192.168.80.110      node2 db2
    
    192.168.80.101      node3 db3

####all node

######因为官方源连接不稳定,最好使用迅雷下载下来,放到每个node /var/cache/yum/下的目录里
######使用aliyun.repo <http://mirrors.aliyun.com/help/centos>
###### epel.repo <http://mirrors.aliyun.com/help/epel>
    cat << EOF >/etc/yum.repos.d/mariadb.repo
    [mariadb]
    name = MariaDB
    baseurl = http://yum.mariadb.org/10.0/centos6-amd64
    gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
    gpgcheck=1
    EOF

    yum install http://dl.fedoraproject.org/pub/epel/6/x86_64/socat-1.7.2.3-1.el6.x86_64.rpm -y

    yum install MariaDB-Galera-server MariaDB-client rsync galera -y

    /etc/init.d/mysql start && chkconfig mysql on

    /usr/bin/mysql_secure_installation  ##不设置密码

    mkdir /mariadb_data  && mount /dev/mapper/VG_SYSTEM-lv_mysql_data /mariadb_data/

    echo "/dev/mapper/VG_SYSTEM-lv_mysql_data    /mariadb_data        ext4    defaults   0 0" >>/etc/fstab

    mysql -uroot -p

        DELETE FROM mysql.user WHERE user='';
        GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY 'password';
        GRANT ALL PRIVILEGES ON *.* to sst_user@'%' IDENTIFIED BY 'password';
        FLUSH PRIVILEGES;
        quit

    /etc/init.d/mysql stop


### all node 
    rm -rf /etc/my.cnf.d/*
    
    cat >/etc/my.cnf.d/galera_common.cnf <<HERE
    [mysqld]
    datadir=/mariadb_data/data
    character_set_server=utf8
    wsrep-cluster-name = "szqs_d3_2_cluster"
    wsrep-provider = /usr/lib64/galera/libgalera_smm.so
    wsrep-provider-options = "gcache.size=256M;gcache.page_size=128M"
    wsrep-sst-auth = "sst_user:password"
    binlog-format = row
    default-storage-engine = InnoDB
    innodb-doublewrite = 1
    innodb-autoinc-lock-mode = 2
    innodb-flush-log-at-trx-commit = 2
    innodb-locks-unsafe-for-binlog = 1
    HERE

####db1
    cat >/etc/my.cnf.d/galera_db00.cnf <<HERE
    [mysqld]
    wsrep-node-name = "db1"
    wsrep-sst-receive-address = 192.168.80.111
    wsrep-node-incoming-address = 192.168.80.111
    bind-address = 192.168.80.111
    wsrep_sst_method = rsync

    wsrep-cluster-address = gcomm://192.168.80.111,192.168.80.101,192.168.80.110
    HERE
    
    /etc/init.d/mysql start --wsrep-new-cluster

####db2
    cat >/etc/my.cnf.d/galera_db00.cnf <<HERE
    [mysqld]
    wsrep-node-name = "db2"
    wsrep-sst-receive-address = 192.168.80.110
    wsrep-node-incoming-address = 192.168.80.110
    bind-address = 192.168.80.110
    wsrep_sst_method = rsync
    wsrep-cluster-address = gcomm://192.168.80.111,192.168.80.101,192.168.80.110
    HERE
    
    /etc/init.d/mysql start

####db3
    cat >/etc/my.cnf.d/galera_db00.cnf <<HERE
    [mysqld]
    wsrep-node-name = "db3"
    wsrep-sst-receive-address = 192.168.80.101
    wsrep-node-incoming-address = 192.168.80.101
    bind-address = 192.168.80.101
    wsrep_sst_method = rsync
    wsrep-cluster-address = gcomm://192.168.80.111,192.168.80.101,192.168.80.110
    HERE
    
    /etc/init.d/mysql start

###检测集群
    show status like 'wsrep%';

##配置NGINX转发
    mkdir /home/nginx/tcp_conf.d
    vim /home/nginx/nginx.conf
    # 添加stream模块
    stream {
    include  /home/nginx/tcp_conf.d/*.conf;
    }

    vim /home/nginx/tcp_conf.d/tcp.conf
        upstream szqs_d3_1 { 
            hash $remote_addr consistent; 
            server 192.168.80.101:3306 weight=5 max_fails=3 fail_timeout=30s; 
            server 192.168.80.110:3306 weight=5 max_fails=3 fail_timeout=30s; 
            server 192.168.80.111:3306 weight=5 max_fails=3 fail_timeout=30s; 
        }
    
        server { 
            listen 3306; 
            proxy_connect_timeout 1s; 
            proxy_timeout 3s; 
            proxy_pass szqs_d3_1; 
        }
