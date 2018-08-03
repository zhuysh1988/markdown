###处理MariaDB Galera cluster初始化和启动报错两例


##问题一:
    160613  0:43:36 [Note] WSREP: Read nil XID from storage engines, skipping position init
    160613  0:43:36 [Note] WSREP: wsrep_load(): loading provider library '/usr/lib/galera/libgalera_smm.so'
    160613  0:43:36 [Note] WSREP: wsrep_load(): Galera 25.3.15(r3578) by Codership Oy <info@codership.com> loaded successfully.
    160613  0:43:36 [Note] WSREP: CRC-32C: using hardware acceleration.
    160613  0:43:36 [Note] WSREP: Found saved state: 00000000-0000-0000-0000-000000000000:-1
    160613  0:43:36 [ERROR] WSREP: Value 2147483648 too large for requested type (int).: 75 (Value too large for defined data type)
             at galerautils/src/gu_config.cpp:overflow_int():175
    160613  0:43:36 [ERROR] WSREP: wsrep::init() failed: 7, must shutdown
    160613  0:43:36 [ERROR] Aborting
    160613  0:43:36 [Note] /usr/sbin/mysqld: Shutdown complete
###分析：
    wsrep_provider_options="gcache.size=2048M"
    设置超过2G时，会引起bug，参考：https://jira.mariadb.org/browse/MDEV-9052
###处理方法：
    wsrep_provider_options="gcache.size=1999M"
 
###问题二：
 
    160613  9:42:32 [Warning] WSREP: last inactive check more than PT1.5S ago (PT3.50315S), skipping check
    160613  9:43:01 [Note] WSREP: view((empty))
    160613  9:43:01 [ERROR] WSREP: failed to open gcomm backend connection: 110: failed to reach primary view: 110 (Connection timed out)
             at gcomm/src/pc.cpp:connect():162
    160613  9:43:01 [ERROR] WSREP: gcs/src/gcs_core.cpp:gcs_core_open():208: Failed to open backend connection: -110 (Connection timed out)
    160613  9:43:01 [ERROR] WSREP: gcs/src/gcs.cpp:gcs_open():1379: Failed to open channel ''galera_cluster’' at 'gcomm://10.16.24.107,10.16.24.108,10.16.24.109': -110 (Connection timed out)
    160613  9:43:01 [ERROR] WSREP: gcs connect failed: Connection timed out
    160613  9:43:01 [ERROR] WSREP: wsrep::connect(gcomm://10.16.24.107,10.16.24.108,10.16.24.109) failed: 7
    160613  9:43:01 [ERROR] Aborting
    160613  9:43:01 [Note] WSREP: Service disconnected.
    160613  9:43:02 [Note] WSREP: Some threads may fail to exit.
    160613  9:43:02 [Note] /usr/sbin/mysqld: Shutdown complete
###分析处理：
#####删除该节点及该借点前面所有节点MySQL文件安装目录下的两个缓存文件及/var/lock/subsys 目录下的mysql 文件，然后重新启动：
    [root@mvxl0782 etc]# cd /var/lock/subsys
    [root@mvxl0782 subsys]# rm -rf mysql
    [root@mvxl0782 subsys]# cd /data/mysql/3306
    [root@mvxl0782 3306]# rm -rf galera.cache
    [root@mvxl0782 3306]# rm -rf grastate.dat
###第一节点:
    service mysql start --wsrep-new-cluster
###其它节点：
    service mysql start
