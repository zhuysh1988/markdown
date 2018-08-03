##MySQL不同数据库不同数据表导入数据

>今天在一个库里面相互到两张表的数据，我之前只会一种方法：

    INSERT INTO A SELECT * FROM B;

>这个方法的意思是将b表的所有数据全部导入到a表中，注意：

    a、b表的数据结构相同；

    相当于复制了b表数据到a表

>这样可以简单完成功能，但是当需求变成这样：

    a、b表数据结构不一样；

    或者只需导一部分数据

    或者导入数据是有重复的

>这个sql就无能为力了，我们以各种情况来说。

####首先有a表，结构如下：
    create table `table_a` (
    `id` bigint(20) not null auto_increment comment '主键，长整型，自增',
    `user_id` varchar(32) default null comment '用户id',
    `name` varchar(50) default null comment '名字',
    `email` varchar(30) not null comment '邮箱',
    primary key (`id`)
    ) engine=innodb default charset=utf8;

>然后是b表，结构如下，

    CREATE TABLE `table_b` (
    `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键，长整型，自增',
    `user_id` varchar(32) DEFAULT NULL COMMENT '用户id',
    `user_name` varchar(50) DEFAULT NULL COMMENT '名字',
    `email` varchar(30) NOT NULL COMMENT '邮箱',
    `course` varchar(30) NOT NULL COMMENT '课程',
    PRIMARY KEY (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

###情形如下：

####（1）导入的数据在a表中完全不存在
    INSERT INTO table_a (id,user_id,name,email) SELECT id,user_id,user_name,email FROM table_b;
    
    或者不需要id的情况，

    INSERT INTO table_a (user_id,name,email) SELECT user_id,user_name,email FROM table_b;

>如果有重复的可以使用replace into 这个，但是请慎重使用replace，保证你对replace有足够的了解！

####（2）导入的数据部分存在

>数据部分存在为了区分需要在两个表添加唯一索引

>两个表中分别为user_name和name字段添加唯一索引

>第一种情形，

>使用replace into的方式进行导入数据（这里根据唯一索引进行判断，如果不添加唯一索引的方式，除了id主键不同外，其他均相同的情况下也视为相同）

>第二种情形，

>忽略重复的，即如果有发现重复的行，则跳过此行数据的插入，必须使用ignore关键字，


    INSERT IGNORE INTO table_a (id,user_id,name,email) SELECT id,user_id,user_name,email FROM table_b;