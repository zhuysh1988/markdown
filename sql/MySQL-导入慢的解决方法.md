##MySQL 导入慢的解决方法


>MySQL导出的SQL语句在导入时有可能会非常非常慢，在导出时合理使用几个参数，可以大大加快导 入的速度。
###导入注意点：
>使用phpmyadmin或navicat之类的工具的导入功能还是会相当慢，可以直接使用mysql进行导入
>导入命令如下：

    mysql> -uroot -psupidea jb51.net<E:\www.jb51.net.sql
>说明：mysql> -umysql用户名 -pmysql密码 要导入到的数据库名<要导入MYSQL的SQL文件路径
>这样导入将会非常快，之前数小时才能导入的sql现在几十秒就可以完成了。

###导出时候注意点：
    -e 使用包括几个VALUES列表的多行INSERT语法;
    --max_allowed_packet=XXX 客户端/服务器之间通信的缓存区的最大大小;
    --net_buffer_length=XXX  TCP/IP和套接字通信缓冲区大小,创建长度达net_buffer_length的行。
###注意：max_allowed_packet和net_buffer_length不能比目标数据库的设定数值 大，否则可能出错。
###首先确定目标库的参数值
    mysql>show variables like 'max_allowed_packet';
    mysql>show variables like 'net_buffer_length';
###根据参数值书写mysqldump命令，如：
    mysql>mysqldump -uroot -psupidea jb51.net goodclassification -e --max_allowed_packet=1048576 --net_buffer_length=16384 >www.jb51.net.sql


##source db.sql


>在mysql的安装目录下 找到 my.ini文件 加入以下代码：

###代码如下
     interactive_timeout = 120
     wait_timeout = 120
     max_allowed_packet = 32M   #这个值越大越快,看内存
