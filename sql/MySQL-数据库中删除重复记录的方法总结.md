####MySQL 数据库中删除重复记录的方法总结

###演示数据

####表结构：

    mysql> desc demo;
    +-------+------------------+------+-----+---------+----------------+
    | Field | Type             | Null | Key | Default | Extra          |
    +-------+------------------+------+-----+---------+----------------+
    | id    | int(11) unsigned | NO   | PRI | NULL    | auto_increment |
    | site  | varchar(100)     | NO   | MUL |         |                |
    +-------+------------------+------+-----+---------+----------------+
    2 rows in set (0.00 sec)
####数据：

    mysql> select * from demo order by id;
    +----+------------------------+
    | id | site                   |
    +----+------------------------+
    |  1 | http://www.CodeBit.cn  |
    |  2 | http://YITU.org        |
    |  3 | http://www.ShuoWen.org |
    |  4 | http://www.CodeBit.cn  |
    |  5 | http://www.ShuoWen.org |
    +----+------------------------+
    5 rows in set (0.00 sec)
######当没有创建表或创建索引权限的时候，可以用下面的方法：
######
######如果你要删除较旧的重复记录，可以使用下面的语句：

    mysql> delete from a
        -> using demo as a, demo as b
        -> where (a.id > b.id)
        -> and (a.site = b.site);
    Query OK, 2 rows affected (0.12 sec)
    
    mysql> select * from demo order by id;
    +----+------------------------+
    | id | site                   |
    +----+------------------------+
    |  1 | http://www.CodeBit.cn  |
    |  2 | http://YITU.org        |
    |  3 | http://www.ShuoWen.org |
    +----+------------------------+
    3 rows in set (0.00 sec)
####如果你要删除较新的重复记录，可以使用下面的语句：

    mysql> delete from a
        -> using demo as a, demo as b
        -> where (a.id < b.id)
        -> and (a.site = b.site);
    Query OK, 2 rows affected (0.12 sec)
    
    mysql> select * from demo order by id;
    +----+------------------------+
    | id | site                   |
    +----+------------------------+
    |  2 | http://YITU.org        |
    |  4 | http://www.CodeBit.cn  |
    |  5 | http://www.ShuoWen.org |
    +----+------------------------+
    3 rows in set (0.00 sec)
#####你可以用下面的语句先确认将被删除的重复记录：

    mysql> SELECT a.*
        -> FROM demo a, demo b
        -> WHERE a.id > b.id
        -> AND (a.site = b.site);
    +----+------------------------+
    | id | site                   |
    +----+------------------------+
    |  1 | http://www.CodeBit.cn  |
    |  3 | http://www.ShuoWen.org |
    +----+------------------------+
    2 rows in set (0.00 sec)
######如果有创建索引的权限，可以用下面的方法：
######
######在表上创建唯一键索引：

    mysql> alter ignore table demo add unique index ukey (site);
    Query OK, 5 rows affected (0.46 sec)
    Records: 5  Duplicates: 2  Warnings: 0
    
    mysql> select * from demo order by id;
    +----+------------------------+
    | id | site                   |
    +----+------------------------+
    |  1 | http://www.CodeBit.cn  |
    |  2 | http://YITU.org        |
    |  3 | http://www.ShuoWen.org |
    +----+------------------------+
    3 rows in set (0.00 sec)
######重复记录被删除后，如果需要，可以删除索引：

    mysql> alter table demo drop index ukey;
    Query OK, 3 rows affected (0.37 sec)
    Records: 3  Duplicates: 0  Warnings: 0
######如果有创建表的权限，可以用下面的方法：

#####创建一个新表，然后将原表中不重复的数据插入新表：

    mysql> create table demo_new as select * from demo group by site;
    Query OK, 3 rows affected (0.19 sec)
    Records: 3  Duplicates: 0  Warnings: 0
    
    mysql> show tables;
    +----------------+
    | Tables_in_test |
    +----------------+
    | demo           |
    | demo_new       |
    +----------------+
    2 rows in set (0.00 sec)
    
    mysql> select * from demo order by id;
    +----+------------------------+
    | id | site                   |
    +----+------------------------+
    |  1 | http://www.CodeBit.cn  |
    |  2 | http://YITU.org        |
    |  3 | http://www.ShuoWen.org |
    |  4 | http://www.CodeBit.cn  |
    |  5 | http://www.ShuoWen.org |
    +----+------------------------+
    5 rows in set (0.00 sec)
    
    mysql> select * from demo_new order by id;
    +----+------------------------+
    | id | site                   |
    +----+------------------------+
    |  1 | http://www.CodeBit.cn  |
    |  2 | http://YITU.org        |
    |  3 | http://www.ShuoWen.org |
    +----+------------------------+
    3 rows in set (0.00 sec)
####然后将原表备份，将新表重命名为当前表：

    mysql> rename table demo to demo_old, demo_new to demo;
    Query OK, 0 rows affected (0.04 sec)
    
    mysql> show tables;
    +----------------+
    | Tables_in_test |
    +----------------+
    | demo           |
    | demo_old       |
    +----------------+
    2 rows in set (0.00 sec)
    
    mysql> select * from demo order by id;
    +----+------------------------+
    | id | site                   |
    +----+------------------------+
    |  1 | http://www.CodeBit.cn  |
    |  2 | http://YITU.org        |
    |  3 | http://www.ShuoWen.org |
    +----+------------------------+
    3 rows in set (0.00 sec)
####注意：使用这种方式创建的表会丢失原表的索引信息！

    mysql> desc demo;
    +-------+------------------+------+-----+---------+-------+
    | Field | Type             | Null | Key | Default | Extra |
    +-------+------------------+------+-----+---------+-------+
    | id    | int(11) unsigned | NO   |     | 0       |       |
    | site  | varchar(100)     | NO   |     |         |       |
    +-------+------------------+------+-----+---------+-------+
    2 rows in set (0.00 sec)
####如果要保持和原表信息一致，你可以使用 show create table demo; 来查看原表的创建语句，然后使用原表的创建语句创建新表，接着使用 insert … select 语句插入数据，再重命名表即可。
