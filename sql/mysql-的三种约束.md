###PRI主键约束；
#####PRI   primary key  表示主键,唯一    写法: id bigint(20) unsigned primary key not null  ,
###UNI唯一约束；
#####uni   UNIQUE  表示唯一  写法   id      bigint(20) unsigned  UNIQUE  default NULL
###MUL可以重复。
#####mul  添加了索引  写法: alter table test add index suoyin (col_name1);
