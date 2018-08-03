##saltstack之SLS文件
###简述

>SLS（代表SaLt State文件）是Salt State系统的核心。SLS描述了系统的目标状态，由格式简单的数据构成。这经常被称作配置管理

###top.sls

>top.sls 是配置管理的入口文件，一切都是从这里开始，在master 主机上，默认存放在/srv/salt/目录.
top.sls 默认从 base 标签开始解析执行,下一级是操作的目标，可以通过正则，grain模块,或分组名,来进行匹配,再下一级是要执行的state文件，不包换扩展名。

###创建 /srv/salt/top.sls

####通过正则进行匹配的示例，
    base:
      '*':
        - webserver
####通过分组名进行匹配的示例，必须要有 - match: nodegroup
    base:
      group1:
        - match: nodegroup    
        - webserver
####通过grain模块匹配的示例，必须要有- match: grain
    base:
      'os:Fedora':
        - match: grain
        - webserver
>准备好top.sls文件后，编写一个state文件

    /srv/salt/webserver.sls
    apache:                 # 标签定义
      pkg:                  # state declaration
        - installed         # function declaration
    第一行被称为（ID declaration） 标签定义，在这里被定义为安装包的名。注意：在不同发行版软件包命名不同,比如 fedora 中叫httpd的包 Debian/Ubuntu中叫apache2
    第二行被称为（state declaration）状态定义， 在这里定义使用（pkg state module）
    第三行被称为（function declaration）函数定义， 在这里定义使用（pkg state module）调用 installed 函数
>最后可以在终端中执行命令来查看结果：

    salt '*' state.highstate
#####或附件 test=True参数 测试执行

    salt '*' state.highstate -v test=True
>主控端对目标主机（targeted minions）发出指令运行state.highstatem模块，目标主机首先会对top.sls下载，解析，然后按照top.sls内匹配规则内的定义的模块将被下载,解析,执行，然后结果反馈给 master.

##SLS文件命名空间

>注意在以上的例子中,SLS文件 webserver.sls 被简称为webserver. SLS文件命名空间有如下几条基本的规则：

>SLS文件的扩展名 .sls 被省略。 (例如. webserver.sls 变成 webserver)
子目录可以更好的组织,每个子目录都由一个点来表示.(例如 webserver/dev.sls 可以简称为 webserver.dev）
如果子目录创建一个init.sls的文件，引用的时候仅指定该目录即可. (例如 webserver/init.sls 可以简称为 webserver）
如果一个目录下同时存在webserver.sls 和 webserver/init.sls，那么 webserver/init.sls 将被忽略，SLS文件引用的webserver将只引用webserver.sls
state多文件示例

###下面是一个state多文件示例，

    apache/init.sls
    apache/httpd.conf
    ssh/init.sls
    ssh/server.sls
    ssh/banner
    ssh/ssh_config
    ssh/sshd_config
>创建一个引用这些目录的 server.sls

    server:
      - apache
      - ssh
###state的层级关系

####include 示例：

####include 包含某个state文件
    /srv/salt/apache.sls

    apache:
      pkg:
        - installed
      service:
        - running
        - require:
          - pkg: apache
####使用 include 可以包换有state文件而不必重新写

    /srv/salt/apache-custom.sls
    include:
      apache
####extend 示例：

>extend 与include配合使用，作用是 修改，或扩展引用的state文件的某个字段
    /srv/salt/apache.sls

    apache:
      pkg:
        - installed
      service:
        - running
        - require:
          - pkg: apache
>extend默认是替换引用文件的某个字段的属性，如例

    /srv/salt/apache-change.sls
    include:
      - apache
    extend：
      apache  
        pkg:
          - name: vim
          - installed     
>当extend与watch，或require结合使用的时候，则是扩展某个字段的属性，如例：

    /srv/salt/apache-custom.sls
    include:
      - apache
    extend：
      apache  
        service:
          - watch:
            - file: /etc/redis.conf      
###state的逻辑关系列表

    match: 配模某个模块，比如 match: grain match: nodegroup
    require： 依赖某个state，在运行此state前，先运行依赖的state，依赖可以有多个
    watch： 在某个state变化时运行此模块
    order： 优先级比require和watch低，有order指定的state比没有order指定的优先级高
###state的逻辑关系实例

>require：依赖某个state，在运行此state前，先运行依赖的state，依赖可以有多个
    httpd:                                  # maps to "name"
      pkg:    
        - installed  
      file：                                # maps to State module filename
        - managed:                          # maps to the managed function in the file State module
        - name: /etc/httpd/conf/httpd.conf  # one of many options passed to the manage function
        - source: salt://httpd/httpd.conf
        - require:  
          - pkg: httpd
>watch：在某个state变化时运行此模块，watch除具备require功能外，还增了关注状态的功能。
    redis:
      pkg:
        - latest
      file.managed:
        - source: salt://redis/redis.conf
        - name: /etc/redis.conf
        - require:
          - pkg: redis
      service.running:
        - enable: True
        - watch:
          - file: /etc/redis.conf
          - pkg: redis
>order：优先级比require和watch低，有order指定的state比没有order指定的优先级高
    vim:
      pkg.installed:
        - order: 1
>想让某个state最后一个运行，可以用last

##进阶主题：模板

>使用模板来精简SLS，使SLS可以使用python的 循环，分支，判断 等逻辑

    {% for item in ['tmp','test'] %}
    /opt/{{ item }}:
      file.directory:
        - user: root
        - group: root
        - mode: 755
        - makedirs: True
    {% endfor %}
    ```markdown
    httpd:
      pkg.managed:
    {% if grains['os'] == 'Ubuntu' %}
        - name: apache2
    {% elif grains['os'] == 'CentOS' %}
        - name: httpd
    {% endif %}
        - installed
>通过加载jinja模板引擎，可以模板配置文件按照预订条件来生成最终的配置文件

    /opt/test.conf

    {% if grains['os'] == 'Ubuntu' %}
    host: {{ grains['host'] }}
    {% elif grains['os'] == 'CentOS' %}
    host: {{ grains['fqdn'] }}
    {% endif %}
    ```markdown
    /opt/test.conf:
      file.managed:
        - source: salt://test.conf
        - user: root
        - group: root
        - mode: 644
        - template: jinja
