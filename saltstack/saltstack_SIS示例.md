##saltstack sls文件语法解释及示例
     1. sls文件本质上是python嵌套字典(键值对)，由salt-master以广播的形式传递给salt-minion，通过sls文件告知使用哪个模块的哪个函数，参数有哪些，在salt-minion一侧进行函数调用
    
     2. 冒号':' 用来分隔键和值， 冒号：与后面的单词如果在一行，一定要有一个空格， 一个单词后面是否有冒号：取决于这个单词是否是key, 后面是否有值或者是嵌套的内容
    
     短横杠 - 表示这项是个列表项， 短横杠与后面的单词有一个空格
    
     缩进： 本层与下一层要有缩进， 缩进不能用tab, 一般是两个空格. 相同一缩进表示相同的层级


###一个sls文件示例：httpd.sls

     httpd:            -------> httpd: sls文件的id,在此sls文件中不能重复，同时也是yum安装的包名和服务名，作为参数name传递给pkg.installed函数和service.running函数
     pkg:            -------> pkg是包管理模块，对应/usr/lib/python2.6/site-packages/salt/states下的模块pkg.py
       - installed        -------> installed是pkg模块下的函数，id(httpd)作为installed的参数进行调用
     service:        ------->service是服务模块，对应/usr/lib/python2.6/site-packages/salt/states下的模块service.py, 由于service是一个key,其下的running, require, watch是列表形式的值，因此service之后有冒号
       - running        -------> running是service.py模块下的函数，id(httpd)作为running的参数进行调用
       - require:        ------->require关键字在 /usr/lib/python2.6/site-packages/salt/state.py里定义的,由于require是key,其下还有子层，因此require后面要有冒号: 且与后面的单词有一个空格
         - pkg: httpd
       - watch:        ------->require关键字在 /usr/lib/python2.6/site-packages/salt/state.py里定义的,由于watch是key,其下还有子层，因此require后面要有冒号：且与后面的单词有一个空格
         - file: /etc/httpd/conf/httpd.conf
    
    /etc/httpd/conf/httpd.conf:
     file:                 ------->file是salt的文件管理模块，对应/usr/lib/python2.6/site-packages/salt/states下的模块file.py
       - managed           -------> managed是file.py模块里的一个函数
       - source: salt://httpd.conf   -------> source是managed函数的参数之一
       - require:
         - pkg: httpd
    
####sls文件的执行： salt '*' state.sls httpd   (注意:是httpd,不是httpd.sls)

###另一个sls文件示例：mysql.sls


     mysql-server:              -------> 这是要安装的包名，也是sls文件的id,不能重复
     pkg:
       - installed              -------> installed的下一行应该是,- name: mysql-server指明要安装的包名,但是由于包名与id(mysql-server)相同，因此, 无须再单独指明installed函数的参数，-name: mysql-server省略
     service.running:
       - name: mysqld           -------> - name 这是service.running函数的参数，如果包名与服务名相同，则- name这项可以省略，但本案例中包名是mysql-server,服务名是mysqld，因此必须有-name 指明running函数的参数是mysqld
       - require:             -------> require是依赖的含义：要运行服务mysqld, 必须安装mysql-server的包    
         - pkg: mysql-server
       - watch:             -------> watch: 表示对文件/etc/my.cnf的监控，当master 向minion传递my.cnf时，新的my.cnf与minion上原有文件不一致时，会重启mysqld服务    
         - file: /etc/my.cnf
    
    /etc/my.cnf:             -------> 这一行同样是id不能重复：表示传递到minion时所处的位置，同时也作为file.managed函数的参数，对应name形参
     file.managed:             -------> 同上一个示例，file.py模块的managed函数，下面的source，user, group, mode都是managed函数的参数
       - source: salt://my.cnf  -------> source 是managed函数的参数，指定要传递到minion端的源文件. salt://my.cnf 表示my.cnf在/srv/salt之下，/srv/salt是saltstack的根目录
       - user: root         -------> 表示文件的属主    
       - group: root         -------> 表示文件的属组    
       - mode: 644             -------> 表示文件的权限
       - require:               -------> 文件从master传递到minion, 需要依赖mysql-server包的安装
         - pkg: mysql-server
    
####sls文件的执行： salt '*' state.sls mysql   (注意:是mysql,不是mysql.sls)

>上面示例文件的格式有点乱，在下面重新写一下：

    [root@salt-master salt]# vim httpd.sls
    
    httpd:
     pkg:
       - installed
     service.running:                #注意: 这种写法时running后面有冒号, 与上面的写法略有不同，但效果相同
       - require:
         - pkg: httpd
       - watch:
         - file: /etc/httpd/conf/httpd.conf
    
    /etc/httpd/conf/httpd.conf:
     file.managed:                    #注意: 这种写法时managed后面有冒号, 与上面的写法略有不同，但效果相同
     - source: salt://httpd.conf
     - require:
         - pkg: httpd
    
    
    [root@salt-master salt]# vim mysql.sls
    
    mysql-server:
     pkg:
       - installed
     service.running:
       - name: mysqld
       - require:
         - pkg: mysql-server
       - watch:
         - file: /etc/my.cnf
    
    /etc/my.cnf:
     file.managed:
       - source: salt://my.cnf
       - user: root
       - group: root
       - mode: 644
       - require:
         - pkg: mysql-server
    

###安装zabbix-agent的示例
    [root@salt-master salt]# vim zabbix-agent.sls
    
    zabbix-agent:
     pkg:
       - installed
     service.running:
       - require:
         - pkg: zabbix-agent
       - watch:
         - file: /etc/zabbix/zabbix_agentd.conf
    
    /etc/zabbix/zabbix_agentd.conf:
     file.managed:
       - source: salt://zabbix_agentd.conf
       - user: root
       - group: root
       - mode: 644
