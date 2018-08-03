 在Windows下常用的有两种方式修改最大连接数。
     第一种：命令行修改。
    >mysql -uuser -ppassword(命令行登录MySQL)
    mysql>show variables like 'max_connections';(查可以看当前的最大连接数)
    msyql>set global max_connections=1000;(设置最大连接数为1000，可以再次查看是否设置成功)
    mysql>exit(推出)
    这种方式有个问题，就是设置的最大连接数只在mysql当前服务进程有效，一旦mysql重启，又会恢复到初始状态。因为mysql启动后的初始化工作是从其配置文件中读取数据的，而这种方式没有对其配置文件做更改。
    第二种：修改配置文件。
   这 种方式说来很简单，只要修改MySQL配置文件my.ini 或 my.cnf的参数max_connections，将其改为max_connections=1000，然后重启MySQL即可。但是有一点最难的就是my.ini这个文件在哪找。通常有两种可能，一个是在安装目录下（这是比较理想的情况），另一种是在数据文件的目录下，安装的时候如果没有人为改变目录的话，一般就在C:/ProgramData/MySQL往下的目录下。



   与连接数相关的几个参数：
     在修改最大连接数的时候会有这样一个疑问—这个值是不是越大越好，或者设置为多大才合适？这个参数的大小要综合很多因素来考虑，比如使用的平台所支持的线程库数量（windows只能支持到2048）、服务器的配置（特别是内存大小）、每个连接占用资源（内存和负载）的多少、系统需要的响应时间等。可以在global或session范围内修改这个参数。连接数的增加会带来很多连锁反应，需要在实际中避免由此引发的负面影响。
    首先看一下MySQL的状态：
mysql> status;
--------------
mysql  Ver 14.14 Distrib 5.5.15, for Win32 (x86)
Connection id:          1
Current database:
Current user:           root@localhost
SSL:                    Not in use
Using delimiter:        ;
Server version:         5.5.15 MySQL Community Server (GPL)
Protocol version:       10
Connection:             localhost via TCP/IP
Server characterset:    utf8
Db     characterset:    utf8
Client characterset:    gbk
Conn.  characterset:    gbk
TCP port:               3306
Uptime:                 1 hour 3 min 27 sec
Threads: 12  Questions: 18  Slow queries: 10  Opens: 33  Flush tables: 5  Open tab
les: 34  Queries per second avg: 6.256
--------------
Open tables:34,即当前数据库打开表的数量是34个，注意这个34并不是实际的34个表，因为MySQL是多线程的系统，几个不同的并发连接可能打开同一个表，这就需要为不同的连接session分配独立的内存空间来存储这些信息以避免冲突。因此连接数的增加会导致MySQL需要的文件描述符数目的增加。另外对于MyISAM表，还会建立一个共享的索引文件描述符。
    在MySQL数据库层面，有几个系统参数决定了可同时打开的表的数量和要使用的文件描述符，那就是table_open_cache、max_tmp_tables和open_files_limit。
mysql> show variables like 'table_open%';
+------------------+-------+
| Variable_name    | Value |
+------------------+-------+
| table_open_cache | 256   |
+------------------+-------+
1 row in set (0.00 sec)
table_open_cache:256，这就是说所有的MySQL线程一共能同时打开256个表，我们可以搜集系统的打开表的数量的历史记录和这个参数来对比，决定是否要增加这个参数的大小。查看当前的打开表的数目(Open tables)可用上边提到过的status命令，另外可以直接查询这个系统变量的值：
mysql> show status like 'open_tables';
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| Open_tables   | 3     |
+---------------+-------+
1 row in set (0.00 sec)
Open_tables就是当前打开表的数目，通过flush tables命令可以关闭当前打开的表。 这个值如果过大，并且如果没有经常的执行flush tables命令，可以考虑增加table_open_cache参数的大小。
 
接下来看max_tmp_tables:
mysql> show variables like 'max_tmp%';
+----------------+-------+
| Variable_name  | Value |
+----------------+-------+
| max_tmp_tables | 32    |
+----------------+-------+
1 row in set (0.00 sec)
max_tmp_tables:32即单个客户端连接能打开的临时表数目。查看当前已打开的临时表的信息：
mysql> show global status like '%tmp%table%';
+-------------------------+-------+
| Variable_name           | Value |
+-------------------------+-------+
| Created_tmp_disk_tables | 0     |
| Created_tmp_tables      | 11    |
+-------------------------+-------+
2 rows in set (0.00 sec)
根据这两个值可以判断临时表的创建位置，一般选取BLOB和TEXT列、Group by 和 Distinct语句的数据量超过512 bytes，或者union的时候select某列的数据超过512 bytes的时候，就直接在磁盘上创建临时表了，另外内存中的临时表变大的时候，也可能被MySQL自动转移到磁盘上（由tmp_table_size和max_heap_table_size参数决定）。
 
增加table_open_cache或max_tmp_tables 参数的大小后，从操作系统的角度看，mysqld进程需要使用的文件描述符的个数就要相应的增加，这个是由open_files_limit参数控制的。
mysql> show variables like 'open_files%';
+------------------+-------+
| Variable_name    | Value |
+------------------+-------+
| open_files_limit | 2670  |
+------------------+-------+
1 row in set (0.00 sec)
但是这个参数是OS限制的，所以我们设定的值并不一定总是生效。如果OS限制MySQL不能修改这个值，那么置为0。如果是专用的MySQL服务器上，这个值一般要设置的尽量大，就是设为没有报Too many open files错误的最大值，这样就能一劳永逸了。当操作系统无法分配足够的文件描述符的时候，mysqld进程会在错误日志里记录警告信息。
相应的，有两个状态变量记录了当前和历史的文件打开信息：
mysql> show global status like '%open%file%';
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| Open_files    | 0     |
| Opened_files  | 76    |
+---------------+-------+
2 rows in set (0.00 sec)
MySQL为每个连接分配线程来处理，可以通过threads_connected参数查看当前分配的线程数量：
mysql> show status like '%thread%';
+------------------------------------------+-------+
| Variable_name                            | Value |
+------------------------------------------+-------+
| Delayed_insert_threads                   | 0     |
| Performance_schema_thread_classes_lost   | 0     |
| Performance_schema_thread_instances_lost | 0     |
| Slow_launch_threads                      | 0     |
| Threads_cached                           | 0     |
| Threads_connected                        | 1     |
| Threads_created                          | 1     |
| Threads_running                          | 1     |
+------------------------------------------+-------+
8 rows in set (0.00 sec)
比较threads_connected参数和前面提到的max_connections参数，也可以作为目前的系统负载的参照，决定是否需要修改连接数。
查看每个线程的详细信息：mysql>show processlist;对影响系统运行的线程：kill connection|query threadid的命令杀死。



命令： show status;
命令：show status like '%下面变量%';
Aborted_clients 由于客户没有正确关闭连接已经死掉，已经放弃的连接数量。 
Aborted_connects 尝试已经失败的MySQL服务器的连接的次数。 
Connections 试图连接MySQL服务器的次数。 
Created_tmp_tables 当执行语句时，已经被创造了的隐含临时表的数量。 
Delayed_insert_threads 正在使用的延迟插入处理器线程的数量。 
Delayed_writes 用INSERT DELAYED写入的行数。 
Delayed_errors 用INSERT DELAYED写入的发生某些错误(可能重复键值)的行数。 
Flush_commands 执行FLUSH命令的次数。 
Handler_delete 请求从一张表中删除行的次数。 
Handler_read_first 请求读入表中第一行的次数。 
Handler_read_key 请求数字基于键读行。 
Handler_read_next 请求读入基于一个键的一行的次数。 
Handler_read_rnd 请求读入基于一个固定位置的一行的次数。 
Handler_update 请求更新表中一行的次数。 
Handler_write 请求向表中插入一行的次数。 
Key_blocks_used 用于关键字缓存的块的数量。 
Key_read_requests 请求从缓存读入一个键值的次数。 
Key_reads 从磁盘物理读入一个键值的次数。 
Key_write_requests 请求将一个关键字块写入缓存次数。 
Key_writes 将一个键值块物理写入磁盘的次数。 
Max_used_connections 同时使用的连接的最大数目。 
Not_flushed_key_blocks 在键缓存中已经改变但是还没被清空到磁盘上的键块。 
Not_flushed_delayed_rows 在INSERT DELAY队列中等待写入的行的数量。 
Open_tables 打开表的数量。 
Open_files 打开文件的数量。 
Open_streams 打开流的数量(主要用于日志记载） 
Opened_tables 已经打开的表的数量。 
Questions 发往服务器的查询的数量。 
Slow_queries 要花超过long_query_time时间的查询数量。 
Threads_connected 当前打开的连接的数量。 
Threads_running 不在睡眠的线程数量。 
Uptime 服务器工作了多少秒。
 
 
 
My.ini配置 虚拟内存
 
 
 
innodb_buffer_pool_size=576M   ->128M InnoDB引擎缓冲区
query_cache_size=100M             ->32 查询缓存
tmp_table_size=102M                  ->32M 临时表大小
key_buffer_size=16m                  ->8M