###MySQL timestamp自动更新时间分享


>在mysql中timestamp数据类型是一个比较特殊的数据类型，他可以自动在你不使用程序更新情况下只要你更新了记录timestamp会自动更新时间
通常表中会有一个Create date 创建日期的字段，其它数据库均有默认值的选项。MySQL也有默认值timestamp，但在MySQL中，不仅是插入就算是修改也会更新timestamp的值！
这样一来，就不是创建日期了，当作更新日期来使用比较好！

>因此在MySQL中要记录创建日期还得使用datetime 然后使用NOW() 函数完成！

    1，TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
>在创建新记录和修改现有记录的时候都对这个数据列刷新

    2，TIMESTAMP DEFAULT CURRENT_TIMESTAMP  在创建新记录的时候把这个
>字段设置为当前时间，但以后修改时，不再刷新它

    3，TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  在创建新记录的时候把这个字段设置为0

###1 自动UPDATE 和INSERT 到当前的时间：
    表：
    ---------------------------------
    Table Create Table
    ------ --------------------------
    CREATE TABLE `t1` (   `p_c` int(11) NOT NULL,  `p_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP   ) ENGINE=InnoDB DEFAULT CHARSET=gb2312
    数据：
    1 2007-10-08 11:53:35
    2 2007-10-08 11:54:00

    insert into t1(p_c) select 3;update t1 set p_c = 2 where p_c = 2;
    数据：
    1 2007-10-08 11:53:35
    2 2007-10-08 12:00:37
    3 2007-10-08 12:00:37
###2、自动INSERT 到当前时间，不过不自动UPDATE。
    表：
    ---------------------------------
    Table Create Table
    ------ ---------------------------
    CREATE TABLE `t1` (   `p_c` int(11) NOT NULL,  `p_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP  ) ENGINE=InnoDB DEFAULT CHARSET=gb2312
    数据：
    insert into t1(p_c) select 4;update t1 set p_c = 3 where p_c = 3;
    1 2007-10-08 11:53:35
    2 2007-10-08 12:00:37
    3 2007-10-08 12:00:37
    4 2007-10-08 12:05:19
    
###3、一个表中不能有两个字段默认值是当前时间，否则就会出错。不过其他的可以。
    表：
    ---------------------------------
    Table Create Table
    ------ --------------------------
     CREATE TABLE `t1` (   `p_c` int(11) NOT NULL,  `p_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,  `p_timew2` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00'  ) ENGINE=InnoDB DEFAULT CHARSET=gb2312
    数据：
    1 2007-10-08 11:53:35 0000-00-00 00:00:00
    2 2007-10-08 12:00:37 0000-00-00 00:00:00
    3 2007-10-08 12:00:37 0000-00-00 00:00:00
    4 2007-10-08 12:05:19 0000-00-00 00:00:00

>比较之下，我的语句少了“on update CURRENT_TIMESTAMP”或多了“default CURRENT_TIMESTAMP”。如此一来，这个timestamp字段只是在数据insert的时间建立时间，而update时就不会有变化了。当然，如果你就是想达到这个目的倒也无所谓

    1： 如果定义时DEFAULT CURRENT_TIMESTAMP和ON UPDATE CURRENT_TIMESTAMP子句都有，列值为默认使用当前的时间戳，并且自动更新。
    2： 如果不使用DEFAULT或ON UPDATE子句，那么它等同于DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP。
    3： 如果只有DEFAULT CURRENT_TIMESTAMP子句，而没有ON UPDATE子句，列值默认为当前时间戳但不自动更新。
    4： 如果没用DEFAULT子句，但有ON UPDATE CURRENT_TIMESTAMP子句，列默认为0并自动更新。
    5： 如果有一个常量值DEFAULT，该列会有一个默认值，而且不会自动初始化为当前时间戳。如果该列还有一个ON UPDATE CURRENT_TIMESTAMP子句，这个时间戳会自动更新，否则该列有一个默认的常量但不会自动更新。
        换句话说，你可以使用当前的时间戳去初始化值和自动更新，或者是其中之一，也可以都不是。（比如，你在定义的时候可以指定自动更新，但并不初始化。）下面的字段定义说明了这些情况：
