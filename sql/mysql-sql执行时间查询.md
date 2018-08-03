##mysql sql执行时间查询
 
###第一种：

####开启profile

    mysql> set profiling=1;
    Query OK, 0 rows affected (0.00 sec)
    eg：
    mysql> select * from test_1;
    mysql> show profiles;
    +----------+------------+----------------------+
    | Query_ID | Duration   | Query                |
    +----------+------------+----------------------+
    |        1 | 0.84718100 | select * from test_1 |
    +----------+------------+----------------------+
    1 row in set (0.00 sec)
###第二种：(通过时间差查看)
    delimiter // set @d=now();
    select * from comment;
    select timestampdiff(second,@d,now());
    delimiter ;
    
    
    Query OK, 0 rows affected (1 min 55.58 sec)
    
    
    +----------------------------------+
    | timestampdiff(second, @d, now()) |
    +----------------------------------+
    |                                2 |
    +----------------------------------+
    1 row in set (1 min 55.58 sec)
