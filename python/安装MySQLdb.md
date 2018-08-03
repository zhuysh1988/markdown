MySQLdb是Python连接MySQL的模块，下面介绍一下源码方式安装MySQLdb：

    MySQLdb.connection():
    Create a connection to the database. It is strongly recommended
        that you only use keyword parameters. Consult the MySQL C API
        documentation for more information.

        host
          string, host to connect

        user
          string, user to connect as

        passwd
          string, password to use

        db
          string, database to use

        port
          integer, TCP/IP port to connect to

        unix_socket
          string, location of unix_socket to use

        conv
          conversion dictionary, see MySQLdb.converters

        connect_timeout
          number of seconds to wait before the connection attempt
          fails.

        compress
          if set, compression is enabled

        named_pipe
          if set, a named pipe is used to connect (Windows only)

        init_command
          command which is run once the connection is created

        read_default_file
          file from which default client values are read

        read_default_group
          configuration group to use from the default file

        cursorclass
          class object, used to create cursors (keyword only)

        use_unicode
          If True, text-like columns are returned as unicode objects
          using the connection's character set.  Otherwise, text-like
          columns are returned as strings.  columns are returned as
          normal strings. Unicode objects will always be encoded to
          the connection's character set regardless of this setting.

        charset
          If supplied, the connection character set will be changed
          to this character set (MySQL-4.1 and newer). This implies
          use_unicode=True.

        sql_mode
          If supplied, the session SQL mode will be changed to this
          setting (MySQL-4.1 and newer). For more details and legal
          values, see the MySQL documentation.

        client_flag
          integer, flags to use or 0
          (see MySQL docs or constants/CLIENTS.py)

        ssl
          dictionary or mapping, contains SSL connection parameters;
          see the MySQL documentation for more details
          (mysql_ssl_set()).  If this is set, and the client does not
          support SSL, NotSupportedError will be raised.

        local_infile
          integer, non-zero enables LOAD LOCAL INFILE; zero disables

        autocommit
          If False (default), autocommit is disabled.
          If True, autocommit is enabled.
          If None, autocommit isn't set and server default is used.




windows AND linux :

    pip install MySQLdb


其它情况:

    安装完成，到你的python安装目录下的site-packages目录里检查以下文件是否存在，如果存在即代表安装成功了
    Linux：MySQL_python-1.2.3c1-py2.6-linux-i686.egg
    Mac OS X：MySQL_python-1.2.3c1-py2.6-macosx-10.4-x86_64.egg
    注：如果碰到mysql_config not found的问题，有两种方法解决：
    1）ln -s /usr/local/mysql/bin/mysql_config /usr/local/bin/mysql_config
    将mysql_confi从你的安装目录链接到/usr/local/bin目录下，这样就可以在任意目录下访问了（也可以放到/usr/bin）
    2）编辑源码文件夹的site.cfg文件，去掉#mysql_config = /usr/local/bin/mysql_config前的注释＃，修改后面的路径为你的mysql_config真正的目录就可以了。（如果不知道mysql_config在哪里，运行命令：whereis mysql_config）

        注:如果碰到import error: libmysqlclient.so.18: cannot open shared object file: No such file or directory

         解决方法: locate or find libmysqlclient.so.18

         link path/libmysqlclient.so.18 /usr/lib/libmysqlclient.so.18

         vi /etc/ld.so.conf    //加入libmysqlclient.so.18 所在的目录

         插入: /usr/lib/

         保存退出后执行/sbin/ldconfig生效



 


测试方法
1）运行命令python进入python运行环境
2）输入以下python代码进行测试

    import MySQLdb

    test=MySQLdb.connect(db='mydb',host='myhost',user='u',passwd='p')

    cur = test.cursor()

    cur.execute('show databases;')

    for data in cur.fetchall():

        print data

3）如果你在屏幕上看到了你几个数据库的库名的输出代表你安装成功了

可能碰到的问题

    问题：ImportError: libmysqlclient_r.so.16: cannot open shared object file: No such file or directory
    原因是python无法找到mysql目录下的libmysqlclient_r.so.16动态库,其实MySQLdb是调用mysql的c函数库.所以本机上首先得安装了mysql
    然后: export LD_LIBRARY_PATH=/usr/local/mysql/lib/mysql:$LD_LIBRARY_PATH
    并且将/usr/local/mysql5.1/lib/mysql 放入/etc/ld.so.conf中
    /etc/ld.so.conf改后内容为：
    include ld.so.conf.d/*.conf
    /usr/local/mysql5.1/lib/mysql
    最后重新再测试一下，就不会有上面的问题了

 

MySQLdb操作:

Python代码
#MySQLdb : create database
    #!/usr/bin/env python

    #coding=utf-8

    ###################################

    #MySQLdb create database

    #

    ##################################

    import MySQLdb


    #建立和数据库系统的连接

    conn = MySQLdb.connect(host='localhost', user='root',passwd='longforfreedom')


    #获取操作游标

    cursor = conn.cursor()

    #执行SQL,创建一个数据库.

    cursor.execute("""create database python """)


    #关闭连接，释放资源

    cursor.close();


#创建数据库，创建表，插入数据，插入多条数据

Python代码:

    #!/usr/bin/env python

    #coding=utf-8

    ###################################

    #MySQLdb 示例

    #

    ##################################

    import MySQLdb


    #建立和数据库系统的连接

    conn = MySQLdb.connect(host='localhost', user='root',passwd='longforfreedom')


    #获取操作游标

    cursor = conn.cursor()

    #执行SQL,创建一个数据库.

    cursor.execute("""create database if not exists python""")


    #选择数据库

    conn.select_db('python');

    #执行SQL,创建一个数据表.

    cursor.execute("""create table test(id int, info varchar(100)) """)


    value = [1,"inserted ?"];


    #插入一条记录

    cursor.execute("insert into test values(%s,%s)",value);


    values=[]



    #生成插入参数值

    for i in range(20):

    values.append((i,'Hello mysqldb, I am recoder ' + str(i)))

    #插入多条记录


    cursor.executemany("""insert into test values(%s,%s) """,values);


    #关闭连接，释放资源

    cursor.close();

 

    #!/usr/bin/env python

    #coding=utf-8

    ###################################

    #MySQLdb 示例 #

    ##################################

    import MySQLdb

    #建立和数据库系统的连接

    conn = MySQLdb.connect(host='localhost', user='root',passwd='longforfreedom')

    #获取操作游标

    cursor = conn.cursor()

    #执行SQL,创建一个数据库.

    cursor.execute("""create database if not exists python""")

    #选择数据库

    conn.select_db('python');

    #执行SQL,创建一个数据表.

    cursor.execute("""create table test(id int, info varchar(100)) """)

    value = [1,"inserted ?"];

    #插入一条记录

    cursor.execute("insert into test values(%s,%s)",value);

    values=[]

    #生成插入参数值

    for i in range(20):

        values.append((i,'Hello mysqldb, I am recoder ' + str(i)));

        #插入多条记录

        cursor.executemany("""insert into test values(%s,%s) """,values);

        #关闭连接，释放资源

        cursor.close();

查询和插入的流程差不多，只是多了一个得到查询结果的步骤

 

    Python代码:

    #!/usr/bin/env python

    #coding=utf-8

    #

    # MySQLdb 查询

    #

    #######################################


    import MySQLdb

    conn = MySQLdb.connect(host='localhost', user='root', passwd='longforfreedom',db='python')


    cursor = conn.cursor()

    count = cursor.execute('select * from test')


    print '总共有 %s 条记录',count

    #获取一条记录,每条记录做为一个元组返回

    print "只获取一条记录:"

    result = cursor.fetchone();

    print result

    #print 'ID: %s info: %s' % (result[0],result[1])

    print 'ID: %s info: %s' % result


    #获取5条记录，注意由于之前执行有了fetchone()，所以游标已经指到第二条记录了，也就是从第二条开始的所有记录

    print "只获取5条记录:"

    results = cursor.fetchmany(5)

    for r in results:

    print r


    print "获取所有结果:"

    #重置游标位置，0,为偏移量，mode＝absolute | relative,默认为relative,

    cursor.scroll(0,mode='absolute')

    #获取所有结果

    results = cursor.fetchall()

    for r in results:

    print r

    conn.close()

 

 


默认mysqldb返回的是元组，这样对使用者不太友好，也不利于维护
下面是解决方法

    import MySQLdb

    import MySQLdb.cursors


    conn = MySQLdb.Connect (

    host = 'localhost', user = 'root' ,

    passwd = '', db = 'test', compress = 1,

    cursorclass = MySQLdb.cursors.DictCursor, charset='utf8') // <- important



    cursor = conn.cursor()

    cursor.execute ("SELECT name, txt FROM table")

    rows = cursor.fetchall()

    cursor.close()

    conn.close()


    for row in rows:

        print row ['name'], row ['txt'] # bingo!

 

# another (even better) way is:


    conn = MySQLdb . Connect (

    host = ' localhost ', user = 'root' ,

    passwd = '', db = 'test' , compress = 1)

    cursor = conn.cursor (cursorclass = MySQLdb.cursors.DictCursor)

    # ...

    # results by field name

    cursor = conn.cursor()

    # ...

    # ...results by field number
