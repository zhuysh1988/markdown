##python对mysql的操作

###Mysql 常见操作
####数据库操作

    创建数据库
        create database fuzjtest
    
    删除数据库
        drop database fuzjtest
    
    查询数据库
        show databases
    
    切换数据库
        use databas 123123 用户授权

    创建用户
        create user '用户名'@'IP地址' identified by '密码';
    
    删除用户
        drop user '用户名'@'IP地址';
    
    修改用户
        rename user '用户名'@'IP地址'; to '新用户名'@'IP地址';;
    
    修改密码
        set password for '用户名'@'IP地址' = Password('新密码')
    
    查看权限
         show grants for '用户'@'IP地址'
    
    授权
        grant 权限 on 数据库.表 to '用户'@'IP地址'
    
    取消权限
    revoke 权限 on 数据库.表 from '用户'@'IP地址'

>PS：用户权限相关数据保存在mysql数据库的user表中，所以也可以直接对其进行操作（不建议）

    授权数据库
    
         相关权限
         对数据库授权
         对用户和IP
     
    
        实例
    
    
        grant all privileges on db1.tb1 TO '用户名'@'IP'
        
        grant select on db1.* TO '用户名'@'IP'
        
        grant select,insert on *.* TO '用户名'@'IP'
        
        revoke select on db1.tb1 from '用户名'@'IP'

 

###表操作

    创建表
    
    语法
        create table 表名(
            列名  类型  是否可以为空，
            列名  类型  是否可以为空
        )
     
    
    参数
    
    1.是否可空，null表示空，非字符串
                  not null    - 不可空
                  null        - 可空
        
    2.默认值，创建列时可以指定默认值，当插入数据时如果未主动设置，则自动添加默认值
                  create table tb1(
                      nid int not null defalut 2,
                      num int not null
                  )
    3.自增，如果为某列设置自增列，插入数据时无需设置此列，默认将自增（表中只能有一个自增列）
                  create table tb1(
                      nid int not null auto_increment primary key,
                      num int null
                  )
                  或
                  create table tb1(
                      nid int not null auto_increment,
                      num int null,
                      index(nid)
                  )
                  注意：1、对于自增列，必须是索引（含主键）。
                       2、对于自增可以设置步长和起始值
                           show session variables like 'auto_inc%';
                           set session auto_increment_increment=2;
                           set session auto_increment_offset=10;
        
                           shwo global  variables like 'auto_inc%';
                           set global auto_increment_increment=2;
                           set global auto_increment_offset=10;
        
    4.主键，一种特殊的唯一索引，不允许有空值，如果主键使用单个列，则它的值必须唯一，如果是多列，则其组合必须唯一。
                  create table tb1(
                      nid int not null auto_increment primary key,
                      num int null
                  )
                  或
                  create table tb1(
                      nid int not null,
                      num int not null,
                      primary key(nid,num)
                  )
        
    5.外键，一个特殊的索引，只能是指定内容
                  creat table color(
                      nid int not null primary key,
                      name char(16) not null
                  )
        
                  create table fruit(
                      nid int not null primary key,
                      smt char(32) null ,
                      color_id int not null,
                      constraint fk_cc foreign key (color_id) references color(nid)
                  )
    
     
    
    删除表
                drop table 表名
    
    清空表
    
        delete from 表名
        truncate table 表名
    
    修改表
    
    添加列：
                alter table 表名 add 列名 类型
    
    删除列：
                alter table 表名 drop column 列名
    
    修改列：
    alter table 表名 modify column 列名 类型; -- 类型
    alter table 表名 change 原列名 新列名 类型; -- 列名，类型
    
    添加主键：
    
    删除主键：
    alter table 表名 drop primary key;
    alter table 表名 modify 列名 int, drop primary key;
    
    添加外键：
    
     
    
                alter table 从表 add constraint 外键名称（形如：FK_从表_主表） foreign key 从表(外键字段) references 主表(主键字段);
    
     
    
    删除外键：
    
     
    
                alter table 表名 drop foreign key 外键名称
    
     
    
    修改默认值：
    
     
    
                ALTER TABLE testalter_tbl ALTER i SET DEFAULT 1000;
    
     
    
    删除默认值：
    
     
    
                ALTER TABLE testalter_tbl ALTER i DROP DEFAULT;
    
     

###基本操作

    增
    insert into 表 (列名,列名...) values (值,值,值...)
    insert into 表 (列名,列名...) values (值,值,值...),(值,值,值...)
    insert into 表 (列名,列名...) select (列名,列名...) from 表
     
    
    删
    delete from 表
    delete from 表 where id＝1 and name＝'fuzj'
     
    
    改
     update 表 set name ＝ 'fuzj' where id>1
     
    
    查
    select * from 表
    select * from 表 where id > 1
    select nid,name,gender as gg from 表 where id > 1
     
    
    高级操作
    
    条件
    
    
    select * from 表 where id > 1 and name != 'alex' and num = 12;
    
    select * from 表 where id between 5 and 16;
    
    select * from 表 where id in (11,22,33)
    select * from 表 where id not in (11,22,33)
    select * from 表 where id in (select nid from 表)
    
     
    
    通配符
    
    select * from 表 where name like 'ale%' - ale开头的所有（多个字符串）
    select * from 表 where name like 'ale_' - ale开头的所有（一个字符）
     
    
    限制
    
    select * from 表 limit 5; - 前5行
    select * from 表 limit 4,5; - 从第4行开始的5行
    select * from 表 limit 5 offset 4 - 从第4行开始的5行
     
    
    排序
    
    select * from 表 order by 列 asc - 根据 “列” 从小到大排列
    select * from 表 order by 列 desc - 根据 “列” 从大到小排列
    select * from 表 order by 列1 desc,列2 asc - 根据 “列1” 从大到小排列，如果相同则按列2从小到大排序
     
    
    分组
    
    
    select num from 表 group by num
    select num,nid from 表 group by num,nid
    select num,nid from 表 where nid > 10 group by num,nid order nid desc
    select num,nid,count(*),sum(score),max(score),min(score) from 表 group by num,nid
    
    select num from 表 group by num having max(id) > 10
    
    特别的：group by 必须在where之后，order by之前
    
     
    
    连表
    
    
    无对应关系则不显示
    select A.num, A.name, B.name
    from A,B
    Where A.nid = B.nid
    
    无对应关系则不显示
    select A.num, A.name, B.name
    from A inner join B
    on A.nid = B.nid
    
    A表所有显示，如果B中无对应关系，则值为null
    select A.num, A.name, B.name
    from A left join B
    on A.nid = B.nid
    
    B表所有显示，如果B中无对应关系，则值为null
    select A.num, A.name, B.name
    from A right join B
    on A.nid = B.nid
    
     
    
    组合
    
    
    组合，自动处理重合
    select nickname
    from A
    union
    select name
    from B
    
    组合，不处理重合
    select nickname
    from A
    union all
    select name
    from B

 

##python操作Mysql

    python3中第三方模块pymysql，提供python对mysql的操作
    pip3 install pymysql
    
    执行sql语句
    
    
    import pymysql
    
     创建连接
    conn = pymysql.connect(host='127.0.0.1', port=3306, user='fuzj', passwd='123123', db='fuzj')
    
     创建游标
    cursor = conn.cursor()
    
    conn.set_charset('utf-8')
     执行SQL，并返回收影响行数
    effect_row = cursor.execute("create table user (id int not NULL auto_increment primary key  ,name char(16) not null) ")    创建一个user表
    print(effect_row)
     执行SQL，并返回受影响行数，使用占位符 实现动态传参
    cursor.execute('SET CHARACTER SET utf8;')
    effect_row = cursor.execute("insert into user (name) values (%s) ", ('323'))
    effect_row = cursor.executemany("insert into user (name) values (%s) ", [('123',),('456',),('789',),('0',),('1',),('2',),('3',)])
    
    print(effect_row)
     执行多个SQL，并返回受影响行数，列表中每个元素都相当于一个条件
    effect_row = cursor.executemany("update user set name = %s WHERE  id = %s", [("fuzj",1),("jeck",2)])
    print(effect_row)
    
     
    
    获取新创建数据自增ID
    使用游标的lastrowid方法获取
    new_id = cursor.lastrowid
     
    
    获取查询数据
    
    import pymysql
    
     创建连接
    conn = pymysql.connect(host='127.0.0.1', port=3306, user='fuzj', passwd='123123', db='fuzj')
    
     创建游标
    cursor = conn.cursor()
    
    
    cursor.execute("select * from user")
    
     获取第一行数据
    row_1 = cursor.fetchone()
    print(row_1)
     获取前n行数据
    row_2 = cursor.fetchmany(3)
    print(row_2)
     获取所有数据
    row_3 = cursor.fetchall()
    print(row_3)
    conn.commit()
    cursor.close()
    conn.close()import pymysql
    
     创建连接
    conn = pymysql.connect(host='127.0.0.1', port=3306, user='fuzj', passwd='123123', db='fuzj')
    
     创建游标
    cursor = conn.cursor()
    
    
    cursor.execute("select * from user")
    
     获取第一行数据
    row_1 = cursor.fetchone()
    print(row_1)
     获取前n行数据
    row_2 = cursor.fetchmany(3)
    print(row_2)
     获取所有数据，返回元组形式
    row_3 = cursor.fetchall()
    print(row_3)
    conn.commit()
    cursor.close()
    conn.close()
    
     
    
    输出：
    
    (1, 'fuzj')
    ((2, 'jeck'), (3, '323'), (4, '123'))
    ((5, '456'), (6, '789'), (7, '0'), (8, '1'), (9, '2'), (10, '3'), (11, '323'), (12, '123'), (13, '456'), (14, '789'), (15, '0'), (16, '1'), (17, '2'), (18, '3'), (19, '323'), (20, '123'), (21, '456'), (22, '789'), (23, '0'), (24, '1'), (25, '2'), (26, '3'))
     
    
    注：在fetch数据时按照顺序进行，可以使用cursor.scroll(num,mode)来移动游标位置，如：
    
    cursor.scroll(1,mode='relative')  相对当前位置移动
    cursor.scroll(2,mode='absolute')  相对绝对位置移动
    
    fetch数据类型
    
    import pymysql
    
     创建连接
    conn = pymysql.connect(host='127.0.0.1', port=3306, user='fuzj', passwd='123123', db='fuzj')
    
     创建游标
    cursor = conn.cursor()
    cursor = conn.cursor(cursor=pymysql.cursors.DictCursor)
    
    cursor.execute("select * from user")
    
    row_1 = cursor.fetchone()
    print(row_1)
     获取前n行数据
    row_2 = cursor.fetchmany(3)
    print(row_2)
     获取所有数据
    row_3 = cursor.fetchall()
    print(row_3)
    conn.commit()
    cursor.close()
    conn.close()
    
     
    
    输出结果：
    
    
    {'id': 1, 'name': 'fuzj'}
    [{'id': 2, 'name': 'jeck'}, {'id': 3, 'name': '323'}, {'id': 4, 'name': '123'}]
    [{'id': 5, 'name': '456'}, {'id': 6, 'name': '789'}, {'id': 7, 'name': '0'}, {'id': 8, 'name': '1'}, {'id': 9, 'name': '2'}, {'id': 10, 'name': '3'}, {'id': 11, 'name': '323'}, {'id': 12, 'name': '123'}, {'id': 13, 'name': '456'}, {'id': 14, 'name': '789'}, {'id': 15, 'name': '0'}, {'id': 16, 'name': '1'}, {'id': 17, 'name': '2'}, {'id': 18, 'name': '3'}, {'id': 19, 'name': '323'}, {'id': 20, 'name': '123'}, {'id': 21, 'name': '456'}, {'id': 22, 'name': '789'}, {'id': 23, 'name': '0'}, {'id': 24, 'name': '1'}, {'id': 25, 'name': '2'}, {'id': 26, 'name': '3'}]
    
     

##ORM框架
    SQLAlchemy是Python编程语言下的一款ORM框架，该框架建立在数据库API之上，使用关系对象映射进行数据库操作，简言之便是：将对象转换成SQL，然后使用数据API执行SQL并获取执行结果。
    ?
    SQLAlchemy本身无法操作数据库，其必须以来pymsql等第三方插件，Dialect用于和数据API进行交流，根据配置文件的不同调用不同的数据库API，从而实现对数据库的操作，如：
    
    
    MySQL-Python
        mysql+mysqldb://<user>:<password>@<host>[:<port>]/<dbname>
      
    pymysql
        mysql+pymysql://<username>:<password>@<host>/<dbname>[?<options>]
      
    MySQL-Connector
        mysql+mysqlconnector://<user>:<password>@<host>[:<port>]/<dbname>
      
    cx_Oracle
        oracle+cx_oracle://user:pass@host:port/dbname[?key=value&key=value...]
      
    更多详见：http://docs.sqlalchemy.org/en/latest/dialects/index.html
    
     
    
    底层处理
    使用 Engine/ConnectionPooling/Dialect 进行数据库操作，Engine使用ConnectionPooling连接数据库，然后再通过Dialect执行SQL语句。
    
    
    from sqlalchemy import create_engine
    
    创建引擎
    engine = create_engine("mysql+pymysql://fuzj:123123@127.0.0.1:3306/fuzj", max_overflow=5)
    执行sql语句
    engine.execute("INSERT INTO user (name) VALUES ('dadadadad')")
    
    result = engine.execute('select * from user')
    res = result.fetchall()
    print(res)
    
     
    
    ORM功能使用
    使用 ORM/Schema Type/SQL Expression Language/Engine/ConnectionPooling/Dialect 所有组件对数据进行操作。根据类创建对象，对象转换成SQL，执行SQL。
    
    创建表
    
    from sqlalchemy.ext.declarative import declarative_base
    from sqlalchemy import Column, Integer, String, ForeignKey, UniqueConstraint, Index
    from sqlalchemy.orm import sessionmaker, relationship
    from sqlalchemy import create_engine
    
    engine = create_engine("mysql+pymysql://fuzj:123123@127.0.0.1:3306/123", max_overflow=5)
    
    Base = declarative_base()
    
     创建单表
    class Users(Base):
    __tablename__ = 'users'
    id = Column(Integer, primary_key=True)
    name = Column(String(32))
    extra = Column(String(16))
    
    __table_args__ = (
    UniqueConstraint('id', 'name', name='uix_id_name'),
       Index('ix_id_name', 'name', 'extra'),
    )
    
     一对多
    class Favor(Base):
    __tablename__ = 'favor'
    nid = Column(Integer, primary_key=True)
    caption = Column(String(50), default='red', unique=True)
    
    class Person(Base):
    __tablename__ = 'person'
    nid = Column(Integer, primary_key=True)
    name = Column(String(32), index=True, nullable=True)
    favor_id = Column(Integer, ForeignKey("favor.nid"))
    
     多对多
    class ServerToGroup(Base):
    __tablename__ = 'servertogroup'
    nid = Column(Integer, primary_key=True, autoincrement=True)
    server_id = Column(Integer, ForeignKey('server.id'))
    group_id = Column(Integer, ForeignKey('group.id'))
    
    class Group(Base):
    __tablename__ = 'group'
    id = Column(Integer, primary_key=True)
    name = Column(String(64), unique=True, nullable=False)
    
    class Server(Base):
    __tablename__ = 'server'
    
    id = Column(Integer, primary_key=True, autoincrement=True)
    hostname = Column(String(64), unique=True, nullable=False)
    port = Column(Integer, default=22)
    
    Base.metadata.create_all(engine)  创建表
     Base.metadata.drop_all(engine)   删除表 
    
     
    
    增
    
    obj = Users(name="alex0", extra='sb')
    session.add(obj)
    session.add_all([
        Users(name="alex1", extra='sb'),
        Users(name="alex2", extra='sb'),
    ])
    session.commit()
    
     
    
    删
    session.query(Users).filter(Users.id > 2).delete()
    session.commit()
     
    
    改
    session.query(Users).filter(Users.id > 2).update({"name" : "099"})
    session.query(Users).filter(Users.id > 2).update({Users.name: Users.name + "099"}, synchronize_session=False)
    session.query(Users).filter(Users.id > 2).update({"num": Users.num + 1}, synchronize_session="evaluate")
    session.commit()
     
    
    查
    ret = session.query(Users).all()
    ret = session.query(Users.name, Users.extra).all()
    ret = session.query(Users).filter_by(name='alex').all()
    ret = session.query(Users).filter_by(name='alex').first()
     
    
    其它
    
        条件
    ret = session.query(Users).filter_by(name='alex').all()
    ret = session.query(Users).filter(Users.id > 1, Users.name == 'eric').all()
    ret = session.query(Users).filter(Users.id.between(1, 3), Users.name == 'eric').all()
    ret = session.query(Users).filter(Users.id.in_([1,3,4])).all()
    ret = session.query(Users).filter(~Users.id.in_([1,3,4])).all()
    ret = session.query(Users).filter(Users.id.in_(session.query(Users.id).filter_by(name='eric'))).all()
    from sqlalchemy import and_, or_
    ret = session.query(Users).filter(and_(Users.id > 3, Users.name == 'eric')).all()
    ret = session.query(Users).filter(or_(Users.id < 2, Users.name == 'eric')).all()
    ret = session.query(Users).filter(
        or_(
            Users.id < 2,
            and_(Users.name == 'eric', Users.id > 3),
            Users.extra != ""
        )).all()
    
    
     通配符
    ret = session.query(Users).filter(Users.name.like('e%')).all()
    ret = session.query(Users).filter(~Users.name.like('e%')).all()
    
     限制
    ret = session.query(Users)[1:2]
    
     排序
    ret = session.query(Users).order_by(Users.name.desc()).all()
    ret = session.query(Users).order_by(Users.name.desc(), Users.id.asc()).all()
    
     分组
    from sqlalchemy.sql import func
    
    ret = session.query(Users).group_by(Users.extra).all()
    ret = session.query(
        func.max(Users.id),
        func.sum(Users.id),
        func.min(Users.id)).group_by(Users.name).all()
    
    ret = session.query(
        func.max(Users.id),
        func.sum(Users.id),
        func.min(Users.id)).group_by(Users.name).having(func.min(Users.id) >2).all()
    
     连表
    
    ret = session.query(Users, Favor).filter(Users.id == Favor.nid).all()
    
    ret = session.query(Person).join(Favor).all()
    
    ret = session.query(Person).join(Favor, isouter=True).all()
    
    
     组合
    q1 = session.query(Users.name).filter(Users.id > 2)
    q2 = session.query(Favor.caption).filter(Favor.nid < 2)
    ret = q1.union(q2).all()
    
    q1 = session.query(Users.name).filter(Users.id > 2)
    q2 = session.query(Favor.caption).filter(Favor.nid < 2)
    ret = q1.union_all(q2).all()
    
     
    
    ORM解决中文编码问题 sqlalchemy 默认使用latin-1进行编码。所以当出现中文时就会报如下错误：
    UnicodeEncodeError: 'latin-1' codec can't encode characters in position 39-41: ordinal not in range(256)
     
    
    
    解决方法：
    在连接数据库的时候直接指定字符编码：
    
    engine = create_engine("mysql+pymysql://fuzj:123.com@127.0.0.1:3306/fuzj?charset=utf8", max_overflow=5,encoding='utf-8')
     
    
    参考：http://firefish.blog.51cto.com/298258/112794
    
    ORM 指定查询返回数据格式 默认使用query查询返回的结果为一个对象
    
    res = session.query(User).all()
    print(res)
    使用for循环遍历列表才能取出name
    for i in res:
        print(i.name)
    
    输出结果：
    [<__main__.User object at 0x10385c438>, <__main__.User object at 0x10385c4a8>, <__main__.User object at 0x10385c550>, <__main__.User object at 0x10385c5f8>, <__main__.User object at 0x10385c6a0>]
    fuzj
    jie
    张三
    李四
    王五
    
     
    
    使用__repr__定义返回的数据
    
    
    class User(Base):
        __tablename__ = 'user'
        nid = Column(Integer,primary_key=True,autoincrement=True)
        name = Column(String(10),nullable=False)
        role = Column(Integer,ForeignKey('role.rid'))
        group = relationship("Role",backref='uuu')    Role为类名
    
        def __repr__(self):
            output = "(%s,%s,%s)" %(self.nid,self.name,self.role)
            return output
            
    res = session.query(User).all()
    print(res)
    
    输出：
    [(1,fuzj,1), (2,jie,2), (3,张三,2), (4,李四,1), (5,王五,3)]
    
     
    
    ORM 一对多具体使用
    
    mysql表中一对多指的是表A中的数据和表B中的数据存在对应的映射关系，表A中的数据在表B中对应存在多个对应关系，如表A存放用户的角色 DBA，SA，表B中存放用户，表B通过外键关联之表A中，多个用户可以属于同一个角色
    
    设计两张表，user表和role表，
    
    user 表中存放用户，role表中存放用户角色，role表中角色对应user表中多个用户，user表中一个用户只对应role表中一个角色，中间通过外键约束
    
    
    from sqlalchemy.ext.declarative import declarative_base
    from sqlalchemy import Column, Integer, String,ForeignKey
    from sqlalchemy.orm import sessionmaker,relationship
    from sqlalchemy import create_engine
    
    engine = create_engine("mysql+pymysql://fuzj:123.com@127.0.0.1:3306/fuzj?charset=utf8", max_overflow=5,encoding='utf-8') 
    Base = declarative_base()
    
    class Role(Base):
        __tablename__ = 'role'
        rid = Column(Integer, primary_key=True, autoincrement=True)    主键，自增
        role_name = Column(String(10))
    
        def __repr__(self):
            output = "(%s,%s)" %(self.rid,self.role_name)
            return output
    
    class User(Base):
        __tablename__ = 'user'
        nid = Column(Integer,primary_key=True,autoincrement=True)
        name = Column(String(10),nullable=False)
        role = Column(Integer,ForeignKey('role.rid'))  外键关联
    
        def __repr__(self):
            output = "(%s,%s,%s)" %(self.nid,self.name,self.role)
            return output
    Base.metadata.create_all(engine)
    
    Session = sessionmaker(bind=engine)
    session = Session()
    
    添加角色数据
    session.add(Role(role_name='dba'))
    session.add(Role(role_name='sa'))
    session.add(Role(role_name='net'))
    
    添加用户数据
    session.add_all([
        User(name='fuzj',role='1'),
        User(name='jie',role='2'),
        User(name='张三',role='2'),
        User(name='李四',role='1'),
        User(name='王五',role='3'),
    ])
    session.commit()
    session.close()
    
     
    
    普通连表查询
    
    res = session.query(User,Role).join(Role).all()    查询所有用户,及对应的role id
    res1 = session.query(User.name,Role.role_name).join(Role).all()  查询所有用户和角色,
    res2 = session.query(User.name,Role.role_name).join(Role,isouter=True).filter(Role.role_name=='sa').all() 查询所有DBA的用户
    print(res)
    print(res1)
    print(res2)
    
    输出结果：
    [((1,fuzj,1), (1,dba)), ((2,jie,2), (2,sa)), ((3,张三,2), (2,sa)), ((4,李四,1), (1,dba)), ((5,王五,3), (3,net))]
    [('fuzj', 'dba'), ('jie', 'sa'), ('张三', 'sa'), ('李四', 'dba'), ('王五', 'net')]
    [('jie', 'sa'), ('张三', 'sa')]
    
     
    
    使用relationship 添加影射关系进行查询
    
    首先在User表中添加relationship影射关系
    class User(Base):
        __tablename__ = 'user'
        nid = Column(Integer,primary_key=True,autoincrement=True)
        name = Column(String(10),nullable=False)
        role = Column(Integer,ForeignKey('role.rid'))
        group = relationship("Role",backref='uuu')    Role为类名
     
    
    查询
    
    正向查询
    print('正向查询')
    res = session.query(User).all()  查询所有的用户和角色
    for i in res:
        print(i.name,i.group.role_name)    此时的i.group 就是role表对应的关系
    res = session.query(User).filter(User.name=='fuzj').first()  查询fuzj用户和角色
    print(res.name,res.group.role_name)
    
    print('反向查找')
    反向查找
    res = session.query(Role).filter(Role.role_name =='dba').first()   查找dba组下的所有用户
    print(res.uuu)   此时 print的结果为[(1,fuzj,1), (4,李四,1)]
    for i in res.uuu:
        print(i.name,res.role_name)
    
    输出结果：
    正向查询
    fuzj dba
    jie sa
    张三 sa
    李四 dba
    王五 net
    fuzj dba
    反向查找
    [(1,fuzj,1), (4,李四,1)]
    fuzj dba
    李四 dba
    
     
    
    说明
    
    relationship 在user表中创建了新的字段，这个字段只用来存放user表中和role表中的对应关系，在数据库中并不实际存在
    正向查找： 先从user表中查到符合name的用户之后，此时结果中已经存在和role表中的对应关系，group对象即role表，所以直接使用obj.group.role_name就可以取出对应的角色
    反向查找：relationship参数中backref='uuu'，会在role表中的每个字段中加入uuu，而uuu对应的就是本字段在user表中对应的所有用户，所以，obj.uuu.name会取出来用户名
    所谓正向和反向查找是对于relationship关系映射所在的表而说，如果通过该表（user表）去查找对应的关系表（role表），就是正向查找，反正通过对应的关系表（role表）去查找该表（user表）即为反向查找。而relationship往往会和ForeignKey共存在一个表中。
    
    ORM 多对多具体使用
    
    Mysql多对多关系指的是两张表A和B本没有任何关系，而是通过第三张表C建立关系，通过关系表C，使得表A在表B中存在多个关联数据，表B在表A中同样存在多个关联数据
    
    创建三张表 host表 hostuser表 host_to_hostuser表
    host表中存放主机，hostuser表中存放主机的用户， host_to_hostuser表中存放主机用户对应的主机，hostuser表中用户对应host表中多个主机，host表中主机对应hostuser表中多个用户，中间关系通过host_to_hostuser表进行关联。host_to_hostuser和host表、user表进行外键约束
    
    
    from sqlalchemy.ext.declarative import declarative_base
    from sqlalchemy import Column, Integer, String,ForeignKey
    from sqlalchemy.orm import sessionmaker,relationship
    from sqlalchemy import create_engine
    class Host(Base):
        __tablename__ = 'host'
        nid = Column(Integer, primary_key=True,autoincrement=True)
        hostname = Column(String(32))
        port = Column(String(32))
        ip = Column(String(32))
    
    class HostUser(Base):
        __tablename__ = 'host_user'
        nid = Column(Integer, primary_key=True,autoincrement=True)
        username = Column(String(32))
    
    class HostToHostUser(Base):
        __tablename__ = 'host_to_host_user'
        nid = Column(Integer, primary_key=True,autoincrement=True)
    
        host_id = Column(Integer,ForeignKey('host.nid'))
        host_user_id = Column(Integer,ForeignKey('host_user.nid'))
    
    Base.metadata.create_all(engine)
    
    Session = sessionmaker(bind=engine)
    session = Session()
    
    添加数据
    session.add_all([
        Host(hostname='c1',port='22',ip='1.1.1.1'),
        Host(hostname='c2',port='22',ip='1.1.1.2'),
        Host(hostname='c3',port='22',ip='1.1.1.3'),
        Host(hostname='c4',port='22',ip='1.1.1.4'),
        Host(hostname='c5',port='22',ip='1.1.1.5'),
    ])
    
    session.add_all([
        HostUser(username='root'),
        HostUser(username='db'),
        HostUser(username='nb'),
        HostUser(username='sb'),
    ])
    
    session.add_all([
        HostToHostUser(host_id=1,host_user_id=1),
        HostToHostUser(host_id=1,host_user_id=2),
        HostToHostUser(host_id=1,host_user_id=3),
        HostToHostUser(host_id=2,host_user_id=2),
        HostToHostUser(host_id=2,host_user_id=4),
        HostToHostUser(host_id=2,host_user_id=3),
    ])
    
    session.commit()
    session.close()
    
     
    
    普通多次查询
    
    host_id = session.query(Host.nid).filter(Host.hostname=='c2').first()   查找hostbane对应的hostid,返回结果为元组(2,)
    user_id_list = session.query(HostToHostUser.host_user_id).filter(HostToHostUser.host_id==host_id[0]).all()  查询hostid对应的所有userid
    user_id_list = zip(*user_id_list)   user_id_list 初始值为[(2,), (4,), (3,)],使用zip转换为[2,4,3]对象
    print(list(user_id_list))    结果为[(2, 4, 3)]
    user_list = session.query(HostUser.username).filter(HostUser.nid.in_(list(user_id_list)[0])).all()  查询符合条件的用户
    print(user_list)
    
    或者：
    user_id_list = session.query(HostToHostUser.host_user_id).join(Host).filter(Host.hostname=='c2').all()
    user_id_list = zip(*user_id_list)
    user_list = session.query(HostUser.username).filter(HostUser.nid.in_(list(user_id_list)[0])).all()
    print(user_list)
    
     
    
    
    
    输出结果：
    [('db',), ('nb',), ('sb',)]
     
    
    使用relationship映射关系查询
    
    首先在关系表Host_to_hostuser中加入relationship关系映射
    
    class HostToHostUser(Base):
        __tablename__ = 'host_to_host_user'
        nid = Column(Integer, primary_key=True,autoincrement=True)
    
        host_id = Column(Integer,ForeignKey('host.nid'))
        host_user_id = Column(Integer,ForeignKey('host_user.nid'))
        host = relationship('Host',backref='h') 对应host表
        host_user = relationship('HostUser',backref='u') 对应host_user表
    
     
    
    查询
    
    查找一个服务器上有哪些用户
    res = session.query(Host).filter(Host.hostname=='c2').first()  返回的是符合条件的服务器对象
    res2 = res.h    通过relationship反向查找 Host_to_Hostuser中的对应关系
    for i in res2:   i为host_to_hostuser表和host表中c2主机有对应关系的条目
        print(i.host_user.username)        正向查找, 通过relationship ,找到host_to_hostuser中对应的hostuser 即i.host_user
    
    查找此用户有哪些服务器
    res = session.query(HostUser).filter(HostUser.username=='sb').first()
    for i in res.u:
        print(i.host.hostname)
    
     
    
    扩展查询
    
    不查询关系表，直接在hostuser表中指定关系表，然后获取host表
    
    在host表中使用 relationship的secondary指定关系表。
    
    
    class Host(Base):
        __tablename__ = 'host'
        nid = Column(Integer, primary_key=True,autoincrement=True)
        hostname = Column(String(32))
        port = Column(String(32))
        ip = Column(String(32))
        host_user = relationship('HostUser',secondary=lambda :HostToHostUser.__table__,backref='h')
    
    注意使用lambda是为了使表的顺序不在闲置
    
    查询：
    
    host_obj = session.query(Host).filter(Host.hostname=='c1').first()
    for i in host_obj.host_user:
        print(i.username)
