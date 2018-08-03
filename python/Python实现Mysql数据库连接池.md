##Python实现Mysql数据库连接池

##python连接Mysql数据库：

>python编程中可以使用MySQLdb进行数据库的连接及诸如查询/插入/更新等操作，但是每次连接mysql数据库请求时，都是独立的去请求访问，相当浪费资源，而且访问数量达到一定数量时，对mysql的性能会产生较大的影响。因此，实际使用中，通常会使用数据库的连接池技术，来访问数据库达到资源复用的目的。

##数据库连接池

>python的数据库连接池包 DBUtils：

 

>DBUtils是一套Python数据库连接池包，并允许对非线程安全的数据库接口进行线程安全包装。DBUtils来自Webware for Python。


###DBUtils提供两种外部接口：
    * PersistentDB ：提供线程专用的数据库连接，并自动管理连接。
    * PooledDB ：提供线程间可共享的数据库连接，并自动管理连接。
##下载地址：DBUtils 下载解压后，使用python setup.py install 命令进行安装

>下面利用MySQLdb和DBUtils建立自己的mysql数据库连接池工具包

>在工程目录下新建package命名为:dbConnecttion，并新建module命名为MySqlConn，下面是MySqlConn.py，该模块创建Mysql的连接池对象，并创建了如查询/插入等通用的操作方法。该部分代码实现如下：

    # -*- coding: UTF-8 -*-
    """
    Created on 2016年5月7日

    @author: baocheng
    1、执行带参数的ＳＱＬ时，请先用sql语句指定需要输入的条件列表，然后再用tuple/list进行条件批配
    ２、在格式ＳＱＬ中不需要使用引号指定数据类型，系统会根据输入参数自动识别
    ３、在输入的值中不需要使用转意函数，系统会自动处理
    """

    import MySQLdb
    from MySQLdb.cursors import DictCursor
    from DBUtils.PooledDB import PooledDB
    #from PooledDB import PooledDB
    import Config

    """
    Config是一些数据库的配置文件
    """

    class Mysql(object):
        """
        MYSQL数据库对象，负责产生数据库连接 , 此类中的连接采用连接池实现获取连接对象：conn = Mysql.getConn()
                释放连接对象;conn.close()或del conn
        """
        #连接池对象
        __pool = None
        def __init__(self):
            #数据库构造函数，从连接池中取出连接，并生成操作游标
            self._conn = Mysql.__getConn()
            self._cursor = self._conn.cursor()

        @staticmethod
        def __getConn():
            """
            @summary: 静态方法，从连接池中取出连接
            @return MySQLdb.connection
            """
            if Mysql.__pool is None:
                __pool = PooledDB(creator=MySQLdb, mincached=1 , maxcached=20 ,
                                  host=Config.DBHOST , port=Config.DBPORT , user=Config.DBUSER , passwd=Config.DBPWD ,
                                  db=Config.DBNAME,use_unicode=False,charset=Config.DBCHAR,cursorclass=DictCursor)
            return __pool.connection()

        def getAll(self,sql,param=None):
            """
            @summary: 执行查询，并取出所有结果集
            @param sql:查询ＳＱＬ，如果有查询条件，请只指定条件列表，并将条件值使用参数[param]传递进来
            @param param: 可选参数，条件列表值（元组/列表）
            @return: result list(字典对象)/boolean 查询到的结果集
            """
            if param is None:
                count = self._cursor.execute(sql)
            else:
                count = self._cursor.execute(sql,param)
            if count>0:
                result = self._cursor.fetchall()
            else:
                result = False
            return result

        def getOne(self,sql,param=None):
            """
            @summary: 执行查询，并取出第一条
            @param sql:查询ＳＱＬ，如果有查询条件，请只指定条件列表，并将条件值使用参数[param]传递进来
            @param param: 可选参数，条件列表值（元组/列表）
            @return: result list/boolean 查询到的结果集
            """
            if param is None:
                count = self._cursor.execute(sql)
            else:
                count = self._cursor.execute(sql,param)
            if count>0:
                result = self._cursor.fetchone()
            else:
                result = False
            return result

        def getMany(self,sql,num,param=None):
            """
            @summary: 执行查询，并取出num条结果
            @param sql:查询ＳＱＬ，如果有查询条件，请只指定条件列表，并将条件值使用参数[param]传递进来
            @param num:取得的结果条数
            @param param: 可选参数，条件列表值（元组/列表）
            @return: result list/boolean 查询到的结果集
            """
            if param is None:
                count = self._cursor.execute(sql)
            else:
                count = self._cursor.execute(sql,param)
            if count>0:
                result = self._cursor.fetchmany(num)
            else:
                result = False
            return result

        def insertOne(self,sql,value):
            """
            @summary: 向数据表插入一条记录
            @param sql:要插入的ＳＱＬ格式
            @param value:要插入的记录数据tuple/list
            @return: insertId 受影响的行数
            """
            self._cursor.execute(sql,value)
            return self.__getInsertId()

        def insertMany(self,sql,values):
            """
            @summary: 向数据表插入多条记录
            @param sql:要插入的ＳＱＬ格式
            @param values:要插入的记录数据tuple(tuple)/list[list]
            @return: count 受影响的行数
            """
            count = self._cursor.executemany(sql,values)
            return count

        def __getInsertId(self):
            """
            获取当前连接最后一次插入操作生成的id,如果没有则为０
            """
            self._cursor.execute("SELECT @@IDENTITY AS id")
            result = self._cursor.fetchall()
            return result[0]['id']

        def __query(self,sql,param=None):
            if param is None:
                count = self._cursor.execute(sql)
            else:
                count = self._cursor.execute(sql,param)
            return count

        def update(self,sql,param=None):
            """
            @summary: 更新数据表记录
            @param sql: ＳＱＬ格式及条件，使用(%s,%s)
            @param param: 要更新的  值 tuple/list
            @return: count 受影响的行数
            """
            return self.__query(sql,param)

        def delete(self,sql,param=None):
            """
            @summary: 删除数据表记录
            @param sql: ＳＱＬ格式及条件，使用(%s,%s)
            @param param: 要删除的条件 值 tuple/list
            @return: count 受影响的行数
            """
            return self.__query(sql,param)

        def begin(self):
            """
            @summary: 开启事务
            """
            self._conn.autocommit(0)

        def end(self,option='commit'):
            """
            @summary: 结束事务
            """
            if option=='commit':
                self._conn.commit()
            else:
                self._conn.rollback()

        def dispose(self,isEnd=1):
            """
            @summary: 释放连接池资源
            """
            if isEnd==1:
                self.end('commit')
            else:
                self.end('rollback');
            self._cursor.close()
            self._conn.close()

###配置文件模块Cnofig,包括数据库的连接信息/用户名密码等：

    #coding:utf-8
    '''
    Created on 2016年5月7日

    @author: baocheng
    '''
    DBHOST = "localhost"
    DBPORT = 33606
    DBUSER = "zbc"
    DBPWD = "123456"
    DBNAME = "test"
    DBCHAR = "utf8"

###创建test模块，测试一下使用连接池进行mysql访问

    #coding:utf-8
    '''

    @author: baocheng
    '''
    from MySqlConn import Mysql
    from _sqlite3 import Row

    #申请资源
    mysql = Mysql()

    sqlAll = "SELECT tb.uid as uid, group_concat(tb.goodsname) as goodsname FROM ( SELECT goods.uid AS uid, IF ( ISNULL(goodsrelation.goodsname), goods.goodsID, goodsrelation.goodsname ) AS goodsname FROM goods LEFT JOIN goodsrelation ON goods.goodsID = goodsrelation.goodsId ) tb GROUP BY tb.uid"
    result = mysql.getAll(sqlAll)
    if result :
        print "get all"
        for row in result :
            print "%s\t%s"%(row["uid"],row["goodsname"])
    sqlAll = "SELECT tb.uid as uid, group_concat(tb.goodsname) as goodsname FROM ( SELECT goods.uid AS uid, IF ( ISNULL(goodsrelation.goodsname), goods.goodsID, goodsrelation.goodsname ) AS goodsname FROM goods LEFT JOIN goodsrelation ON goods.goodsID = goodsrelation.goodsId ) tb GROUP BY tb.uid"
    result = mysql.getMany(sqlAll,2)
    if result :
        print "get many"
        for row in result :
            print "%s\t%s"%(row["uid"],row["goodsname"])


    result = mysql.getOne(sqlAll)
    print "get one"
    print "%s\t%s"%(result["uid"],result["goodsname"])

    #释放资源
    mysql.dispose()

###当然，还有很多其他参数可以配置：
 

    dbapi ：数据库接口
    mincached ：启动时开启的空连接数量
    maxcached ：连接池最大可用连接数量
    maxshared ：连接池最大可共享连接数量
    maxconnections ：最大允许连接数量
    blocking ：达到最大数量时是否阻塞
    maxusage ：单个连接最大复用次数 根据自己的需要合理配置上述的资源参数，以满足自己的实际需要。
###至此，python中的mysql连接池实现完了，下次就直接拿来用就好了。
