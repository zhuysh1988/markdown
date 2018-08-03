##mariadb配置文件优化参数
>FROM <http://xianglinhu.blog.51cto.com/5787032/1702472>
>mariadb数据库优化需要根据自己业务需求以及根据硬件配置来进行参数优化，下面是一些关于mariadb数据库参数优化的配置文件。
###如下为128G内存32线程处理器的mariadb配置参数优化：

    [client]
    #password= your_password
    port= 3306
    socket= /tmp/mysql.sock
    !includedir /opt/local/mysql/wsrep
    # The MySQL server
    [mysqld]
    port= 3306
    socket= /tmp/mysql.sock
    basedir = /opt/local/mysql
    datadir=/opt/local/mysql/data                   #数据库存放目录
    relay-log=/opt/local/mysql/relaylog/s74-relay-bin
    pid-file = /opt/local/mysql/mysql.pid
    log-error = /opt/local/mysql/logs/mysqld.log
    open_files_limit = 65535                        #
    #skip-locking
    skip-external-locking                           #跳过外部锁定
    back_log=3000                                   #暂存的连接数量
    skip-name-resolve                               #关闭mysql的dns反查功能
    memlock                                         #将mysqld 进程锁定在内存中
    lower_case_table_names = 1
    #query_response_time_stats=1
    #core-file
    #core-file-size = unlimited
    query_cache_type=1                              #查询缓存  (0 = off、1 = on、2 = demand)
    performance_schema=0                            #收集数据库服务器性能参数
    net_read_timeout=3600                           #连接繁忙阶段（query）起作用
    net_write_timeout=3600                          #连接繁忙阶段（query）起作用
    key_buffer_size = 32M                           #设置索引块缓存大小
    max_allowed_packet = 128M                       #通信缓冲大小
    table_open_cache = 1024                         #table高速缓存的数量
    sort_buffer_size = 12M                          #每个connection（session）第一次需要使用这个buffer的时候，一次性分配设置的内存
    read_buffer_size = 8M                           #顺序读取数据缓冲区使用内存
    #sort_buffer_size = 32M
    #read_buffer_size = 32M
    read_rnd_buffer_size = 32M                      #随机读取数据缓冲区使用内存
    myisam_sort_buffer_size = 32M                   #MyISAM表发生变化时重新排序所需的缓冲
    thread_cache_size = 120                         #重新利用保存在缓存中线程的数量
    query_cache_size = 64M
    join_buffer_size = 8M                           #Join操作使用内存
    bulk_insert_buffer_size = 32M                   #批量插入数据缓存大小
    delay_key_write=ON                              #在表关闭之前，将对表的update操作指跟新数据到磁盘，而不更新索引到磁盘，把对索引的更改记录在内存。这样MyISAM表可以使索引更新更快。在关闭表的时候一起更新索引到磁盘
    delayed_insert_limit=4000
    delayed_insert_timeout=600
    delayed_queue_size=4000
    # Try number of CPU's*2 for thread_concurrency
    # The variable only affects Solaris!
    thread_concurrency = 64                         #CPU核数 * 2
    max_connections=1500                            #最大连接（用户）数。每个连接MySQL的用户均算作一个连接
    max_connect_errors=30                           #最大失败连接限制
    interactive_timeout=600                         #服务器关闭交互式连接前等待活动的秒数
    wait_timeout=3600                               #服务器关闭非交互连接之前等待活动的秒数
    slow_query_log                                  #慢查询记录日志
    long_query_time = 0.1                           #慢查询记录时间  0.1秒
    slow_query_log_file=/opt/local/mysql/logs/slow_query.log            #慢查询日志路径
    #log_slow_verbosity=full
    log_slow_verbosity=query_plan                   #
    # Replication Master Server (default)
    # binary logging is required for replication
    log-bin=/opt/local/mysql/binlog/mysql-bin                               #binlog 名称
    log-slave-updates                               #从master取得并执行的二进制日志写入自己的二进制日志文件中
    replicate-ignore-db=mysql                       #不同步的表
    # binary logging format - mixed recommended
    binlog_format=row                               #binlog 格式 分别为 row=行格式 丶 mixed=混合格式 丶 STATEMENT=SQL语句复制模式
    event_scheduler=1                               #计划任务 事件调度器
    # required unique id between 1 and 2^32 - 1
    # defaults to 1 if master-host is not set
    # but will not function as a master if omitted
    server-id= 1                                 #
    # Point the following paths to different dedicated disks
    #tmpdir= /tmp/
    #log-update = /path-to-dedicated-directory/hostname
    # Uncomment the following if you are using InnoDB tables
    #innodb_data_home_dir = /data/mysql-5.1.48/mysql-data/
    #innodb_data_file_path = ibdata1:2000M;ibdata2:10M:autoextend
    #innodb_log_group_home_dir = /data/mysql-5.1.48/mysql-data/
    # You can set .._buffer_pool_size up to 50 - 80 %
    # of RAM but beware of setting memory usage too high
    innodb_file_format=barracuda
    innodb_file_format_max=barracuda
    innodb_file_per_table=1
    innodb_fast_shutdown=0
    innodb_buffer_pool_size = 90000M
    innodb_buffer_pool_instances = 4
    #innodb_additional_mem_pool_size = 20M
    #innodb_use_sys_malloc = 20M
    # Set .._log_file_size to 25 % of buffer pool size
    innodb_log_file_size = 512M
    #innodb_log_buffer_size = 8M
    innodb_log_files_in_group = 3
    innodb_flush_log_at_trx_commit = 2
    innodb_lock_wait_timeout = 3
    innodb_rollback_on_timeout = on
    innodb_flush_method=O_DIRECT
    transaction-isolation=READ-COMMITTED
    innodb_thread_concurrency=0
    innodb_io_capacity=800
    innodb_purge_threads=1
    innodb_open_files=65535
    #innodb_stats_update_need_lock=0
    #innodb_flush_neighbor_pages=0
    #innodb_aio_pending_ios_per_thread=256
    #for binlog_format=row
    innodb_autoinc_lock_mode=2
    #innodb_fast_checksum = 1
    innodb_read_io_threads = 8
    innodb_write_io_threads = 12
    innodb_stats_on_metadata = 0
    #使用线程池处理连接
    thread_handling=pool-of-threads
    thread_pool_oversubscribe=30
    thread_pool_size=64
    thread_pool_idle_timeout=7200
    thread_pool_max_threads=2000
    #查询优化器开关
    #optimizer_switch='index_condition_pushdown=on'
    #optimizer_switch='mrr=on'
    #optimizer_switch='mrr_sort_keys=on'
    #optimizer_switch='mrr_cost_based=off'
    #mrr_buffer_size=32M
    #optimizer_switch='join_cache_incremental=on'
    #optimizer_switch='join_cache_hashed=on'
    #optimizer_switch='join_cache_bka=on'
    #join_cache_level=4
    #join_buffer_size=32M
    #join_buffer_space_limit=32M
    [mysqldump]
    quick
    max_allowed_packet = 16M
    [mysql]
    no-auto-rehash
    # Remove the next comment character if you are not familiar with SQL
    #safe-updates
    [myisamchk]
    key_buffer_size = 256M
    sort_buffer_size = 256M
    read_buffer = 2M
    write_buffer = 2M
    [isamchk]
    key_buffer_size = 256M
    sort_buffer_size = 256M
    read_buffer = 2M
    write_buffer = 2M
    [mysqlhotcopy]
    interactive-timeout


###如下为256G内存64线程处理器的mariadb配置参数优化：
    [client]
    #password= your_password
    port= 3306
    socket= /tmp/mysql.sock
    !includedir /opt/local/mysql/wsrep
    # The MySQL server
    [mysqld]
    port= 3306
    socket= /tmp/mysql.sock
    basedir = /opt/local/mysql
    datadir=/opt/local/mysql/data                   #数据库存放目录
    relay-log=/opt/local/mysql/relaylog/s74-relay-bin
    pid-file = /opt/local/mysql/mysql.pid
    log-error = /opt/local/mysql/logs/mysqld.log
    open_files_limit = 65535                        #
    #skip-locking
    skip-external-locking                           #跳过外部锁定
    back_log=3000                                   #暂存的连接数量
    skip-name-resolve                               #关闭mysql的dns反查功能
    memlock                                         #将mysqld 进程锁定在内存中
    lower_case_table_names = 1
    #query_response_time_stats=1
    #core-file
    #core-file-size = unlimited
    query_cache_type=1                              #查询缓存  (0 = off、1 = on、2 = demand)
    performance_schema=0                            #收集数据库服务器性能参数
    net_read_timeout=3600                           #连接繁忙阶段（query）起作用
    net_write_timeout=3600                          #连接繁忙阶段（query）起作用
    key_buffer_size = 32M                           #设置索引块缓存大小
    max_allowed_packet = 128M                       #通信缓冲大小
    table_open_cache = 1024                         #table高速缓存的数量
    sort_buffer_size = 12M                          #每个connection（session）第一次需要使用这个buffer的时候，一次性分配设置的内存
    read_buffer_size = 8M                           #顺序读取数据缓冲区使用内存
    #sort_buffer_size = 32M
    #read_buffer_size = 32M
    read_rnd_buffer_size = 32M                      #随机读取数据缓冲区使用内存
    myisam_sort_buffer_size = 32M                   #MyISAM表发生变化时重新排序所需的缓冲
    thread_cache_size = 120                         #重新利用保存在缓存中线程的数量
    query_cache_size = 64M
    join_buffer_size = 8M                           #Join操作使用内存
    bulk_insert_buffer_size = 32M                   #批量插入数据缓存大小
    delay_key_write=ON                              #在表关闭之前，将对表的update操作指跟新数据到磁盘，而不更新索引到磁盘，把对索引的更改记录在内存。这样MyISAM表可以使索引更新更快。在关闭表的时候一起更新索引到磁盘
    delayed_insert_limit=4000
    delayed_insert_timeout=600
    delayed_queue_size=4000
    # Try number of CPU's*2 for thread_concurrency
    # The variable only affects Solaris!
    thread_concurrency = 96                          #CPU核数 * 2
    max_connections=1500                            #最大连接（用户）数。每个连接MySQL的用户均算作一个连接
    max_connect_errors=30                           #最大失败连接限制
    interactive_timeout=600                         #服务器关闭交互式连接前等待活动的秒数
    wait_timeout=3600                               #服务器关闭非交互连接之前等待活动的秒数
    slow_query_log                                  #慢查询记录日志
    long_query_time = 0.1                           #慢查询记录时间  0.1秒
    slow_query_log_file=/opt/local/mysql/logs/slow_query.log            #慢查询日志路径
    #log_slow_verbosity=full
    log_slow_verbosity=query_plan                   #
    # Replication Master Server (default)
    # binary logging is required for replication
    log-bin=/opt/local/mysql/binlog/mysql-bin                               #binlog 名称
    log-slave-updates                               #从master取得并执行的二进制日志写入自己的二进制日志文件中
    replicate-ignore-db=mysql                       #不同步的表
    # binary logging format - mixed recommended
    binlog_format=row                               #binlog 格式 分别为 row=行格式 丶 mixed=混合格式 丶 STATEMENT=SQL语句复制模式
    event_scheduler=1                               #计划任务 事件调度器
    # required unique id between 1 and 2^32 - 1
    # defaults to 1 if master-host is not set
    # but will not function as a master if omitted
    server-id= 1                                 #
    # Point the following paths to different dedicated disks
    #tmpdir= /tmp/
    #log-update = /path-to-dedicated-directory/hostname
    # Uncomment the following if you are using InnoDB tables
    #innodb_data_home_dir = /data/mysql-5.1.48/mysql-data/
    #innodb_data_file_path = ibdata1:2000M;ibdata2:10M:autoextend
    #innodb_log_group_home_dir = /data/mysql-5.1.48/mysql-data/
    # You can set .._buffer_pool_size up to 50 - 80 %
    # of RAM but beware of setting memory usage too high
    innodb_file_format=barracuda
    innodb_file_format_max=barracuda
    innodb_file_per_table=1
    innodb_fast_shutdown=0
    innodb_buffer_pool_size = 180000M
    innodb_buffer_pool_instances = 4
    #innodb_additional_mem_pool_size = 20M
    #innodb_use_sys_malloc = 20M
    # Set .._log_file_size to 25 % of buffer pool size
    innodb_log_file_size = 512M
    #innodb_log_buffer_size = 8M
    innodb_log_files_in_group = 3
    innodb_flush_log_at_trx_commit = 2
    innodb_lock_wait_timeout = 3
    innodb_rollback_on_timeout = on
    innodb_flush_method=O_DIRECT
    transaction-isolation=READ-COMMITTED
    innodb_thread_concurrency=0
    innodb_io_capacity=800
    innodb_purge_threads=1
    innodb_open_files=65535
    #innodb_stats_update_need_lock=0
    #innodb_flush_neighbor_pages=0
    #innodb_aio_pending_ios_per_thread=256
    #for binlog_format=row
    innodb_autoinc_lock_mode=2
    #innodb_fast_checksum = 1
    innodb_read_io_threads = 8
    innodb_write_io_threads = 12
    innodb_stats_on_metadata = 0
    #使用线程池处理连接
    thread_handling=pool-of-threads
    thread_pool_oversubscribe=30
    thread_pool_size=64
    thread_pool_idle_timeout=7200
    thread_pool_max_threads=2000
    #查询优化器开关
    #optimizer_switch='index_condition_pushdown=on'
    #optimizer_switch='mrr=on'
    #optimizer_switch='mrr_sort_keys=on'
    #optimizer_switch='mrr_cost_based=off'
    #mrr_buffer_size=32M
    #optimizer_switch='join_cache_incremental=on'
    #optimizer_switch='join_cache_hashed=on'
    #optimizer_switch='join_cache_bka=on'
    #join_cache_level=4
    #join_buffer_size=32M
    #join_buffer_space_limit=32M
    [mysqldump]
    quick
    max_allowed_packet = 16M
    [mysql]
    no-auto-rehash
    # Remove the next comment character if you are not familiar with SQL
    #safe-updates
    [myisamchk]
    key_buffer_size = 256M
    sort_buffer_size = 256M
    read_buffer = 2M
    write_buffer = 2M
    [isamchk]
    key_buffer_size = 256M
    sort_buffer_size = 256M
    read_buffer = 2M
    write_buffer = 2M
    [mysqlhotcopy]
    interactive-timeout


##DIFF
    thread_concurrency = 96                          #CPU核数 * 2
    innodb_buffer_pool_size = 180000M                #内存大小
