## 1 所需安装包
    percona-xtrabackup-24-2.4.6-2.el7.x86_64.rpm
    /data/mariadb/rpms/
    ├── galera-25.3.20-1.rhel7.el7.centos.x86_64.rpm
    ├── jemalloc-3.6.0-1.el7.x86_64.rpm
    ├── jemalloc-devel-3.6.0-1.el7.x86_64.rpm
    ├── MariaDB-10.0.31-centos7-x86_64-client.rpm
    ├── MariaDB-10.0.31-centos7-x86_64-common.rpm
    ├── MariaDB-10.0.31-centos7-x86_64-compat.rpm
    ├── MariaDB-10.0.31-centos7-x86_64-connect-engine.rpm
    ├── MariaDB-10.0.31-centos7-x86_64-devel.rpm
    ├── MariaDB-10.0.31-centos7-x86_64-oqgraph-engine.rpm
    ├── MariaDB-10.0.31-centos7-x86_64-server.rpm
    ├── MariaDB-10.0.31-centos7-x86_64-shared.rpm
    ├── MariaDB-10.0.31-centos7-x86_64-test.rpm
    ├── MariaDB-Galera-10.0.31-centos7-x86_64-server.rpm
    └── MariaDB-Galera-10.0.31-centos7-x86_64-test.rpm
## 2 配置好centos-base epel 源    
    /etc/yum.repos.d/
    ├── base.repo
    ├── epel.repo
    ├── epel-testing.repo
    └── mariadb.repo
- ### 1.1 制作mariadb yum 源
      cd /data/mariadb
      createrepo .
- ### 1.2 Create mariadb.repo
      cat mariadb.repo 
      [mariadb]
      name=mariadb -  10.3
      baseurl=http://192.168.1.119/mariadb
      gpgcheck=0
      enabled=1
## 3 开始安装
- ### 3.1 安装 xtrabackup
      yum install http://192.168.1.119/soft/percona-xtrabackup-24-2.4.6-2.el7.x86_64.rpm -y
- ### 3.2 安装MariaDB-Galera
      yum install MariaDB-Galera-server -y
- ### 3.3 安装socat 
      yum install socat -y
- ### 3.4 启动mysql       
      /etc/init.d/mysql start 
- ### 3.5 初始化mysql 
      /usr/bin/mysql_secure_installation
- ### 3.6 设置mysql 同步用户
      mysql -uroot -p

      DELETE FROM mysql.user WHERE user='';
      GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY 'password';
      GRANT ALL PRIVILEGES ON *.* to sst_user@'%' IDENTIFIED BY 'password';
      FLUSH PRIVILEGES;
      quit
- ### 3.7 Stop Mysql
      /etc/init.d/mysql stop 
## 4 配置和启动 mariadb cluster 
- ### 4.1 全局配置
      cat >/etc/my.cnf.d/galera_common.cnf <<HERE
      [mysqld]
      character_set_server=utf8
      wsrep-cluster-name = "bocloud-cluster-mariadb1"
      wsrep-provider = /usr/lib64/galera/libgalera_smm.so
      wsrep-provider-options = "gcache.size=256M;gcache.page_size=128M"
      wsrep-sst-auth = "sst_user:mmmmmm"
      binlog-format = row
      default-storage-engine = InnoDB
      innodb-doublewrite = 1
      innodb-autoinc-lock-mode = 2
      innodb-flush-log-at-trx-commit = 2
      innodb-locks-unsafe-for-binlog = 1
      HERE
- ### 4.2 node1 配置 

      cat >/etc/my.cnf.d/galera_db00.cnf <<HERE
      [mysqld]
      wsrep-node-name = "db1"

      wsrep-sst-receive-address = 172.17.17.111
      
      wsrep-node-incoming-address = 172.17.17.111

      bind-address = 192.168.1.111

      wsrep_sst_method=xtrabackup
      
      wsrep-cluster-address = gcomm://172.17.17.111,172.17.17.112,172.17.17.113
      HERE

      /etc/init.d/mysql start --wsrep-new-cluster
- ### 4.3 node2 配置 
      cat >/etc/my.cnf.d/galera_db00.cnf <<HERE
      [mysqld]
      wsrep-node-name = "db2"

      wsrep-sst-receive-address = 172.17.17.112
      
      wsrep-node-incoming-address = 172.17.17.112

      bind-address = 192.168.1.112

      wsrep_sst_method=xtrabackup
      
      wsrep-cluster-address = gcomm://172.17.17.111,172.17.17.112,172.17.17.113
      HERE
      /etc/init.d/mysql start
- ### 4.4 node3 配置 
      cat >/etc/my.cnf.d/galera_db00.cnf <<HERE
      [mysqld]
      wsrep-node-name = "db3"

      wsrep-sst-receive-address = 172.17.17.113
      
      wsrep-node-incoming-address = 172.17.17.113

      bind-address = 192.168.1.113

      wsrep_sst_method=xtrabackup
      
      wsrep-cluster-address = gcomm://172.17.17.111,172.17.17.112,172.17.17.113
      HERE
      /etc/init.d/mysql start 
## 5 检测集群
    show status like 'vsrep%'

    wsrep_incoming_addresses  172.17.17.112:3306,172.17.17.113:3306,172.17.17.111:3306