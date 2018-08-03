#python configparser

#1，函数介绍
#1.1.读取配置文件
    -read(filename) 直接读取ini文件内容
    -sections() 得到所有的section，并以列表的形式返回
    -options(section) 得到该section的所有option
    -items(section) 得到该section的所有键值对
    -get(section,option) 得到section中option的值，返回为string类型
    -getint(section,option) 得到section中option的值，返回为int类型

#1.2.写入配置文件
    -add_section(section) 添加一个新的section
    -set( section, option, value) 对section中的option进行设置
      需要调用write将内容写入配置文件。
#2，测试实例
#2.1，测试1
配置文件test.cfg

    [sec_a]
    a_key1 = 20
    a_key2 = 10

    [sec_b]
    b_key1 = 121
    b_key2 = b_value2
    b_key3 = $r
    b_key4 = 127.0.0.1

测试文件test.py

    # -* - coding: UTF-8 -* -
    import ConfigParser
    #生成config对象
    conf = ConfigParser.ConfigParser()
    #用config对象读取配置文件
    conf.read("test.cfg")
    #以列表形式返回所有的section
    sections = conf.sections()
    print 'sections:', sections         #sections: ['sec_b', 'sec_a']
    #得到指定section的所有option
    options = conf.options("sec_a")
    print 'options:', options           #options: ['a_key1', 'a_key2']
    #得到指定section的所有键值对
    kvs = conf.items("sec_a")
    print 'sec_a:', kvs                 #sec_a: [('a_key1', '20'), ('a_key2', '10')]
    #指定section，option读取值
    str_val = conf.get("sec_a", "a_key1")
    int_val = conf.getint("sec_a", "a_key2")

    print "value for sec_a's a_key1:", str_val   #value for sec_a's a_key1: 20
    print "value for sec_a's a_key2:", int_val   #value for sec_a's a_key2: 10

    #写配置文件
    #更新指定section，option的值
    conf.set("sec_b", "b_key3", "new-$r")
    #写入指定section增加新option和值
    conf.set("sec_b", "b_newkey", "new-value")
    #增加新的section
    conf.add_section('a_new_section')
    conf.set('a_new_section', 'new_key', 'new_value')
    #写回配置文件
    conf.write(open("test.cfg", "w"))


#2.2，测试2
配置文件test.cfg


    [info]
    age = 21
    name = chen
    sex = male

测试文件test.py

    from __future__ import with_statement
    import ConfigParser
    config=ConfigParser.ConfigParser()
    with open("test.cfg","rw") as cfgfile:
        config.readfp(cfgfile)
        name=config.get("info","name")
        age=config.get("info","age")
        print name
        print age
        config.set("info","sex","male")
        config.set("info","age","55")
        age=config.getint("info","age")
        print name
        print type(age)
        print age

分析

其中[ ] 中的info是这段配置的名字。

其中age,name都是属性。

首先，config=ConfigParser.ConfigParser() 得到一个配置config对象.下面打开一个配置文件 cfgfile. 用readfp()读取这个文件.这样配置的内容就读到config对象里面了。

接下来一个问题是如何读取值.常用的方法是get() 和getint() . get()返回文本. getint()返回整数。

其次，name=config.get(''info'',''name'')  意思就是.读取config中info段中的name变量值。

最后讲讲如何设置值.使用set(段名,变量名,值) 来设置变量.config.set(''info'',''age'',''21'') 表示把info段中age变量设置为21。



from:<http://blog.csdn.net/gexiaobaohelloworld/article/details/7976944>
