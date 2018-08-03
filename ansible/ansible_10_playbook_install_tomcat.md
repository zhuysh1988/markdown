## playbook install tomcat 
### 实际案例：

### tomcat批量配置

#### 实际场景

>某公司申请了云计算100台虚拟机，需要进行环境搭建。先不过问这个环境搭建来干啥，我们先聚焦在环境搭建其中一步：tomcat安装配置。
步骤分析

- #### tomcat安装很简单，大家都懂。
      1. 安装jdk
      2. 创建tomcat用户等等
      3. 安装tomcart
      4. 配置tomcat，重启。

- #### 那么我们如何写playbook？
      1. 定义Hosts
      2. 定义roles
      3. 定义vars
      4. 编排playbook

>既然都分析到这了，我们就开始吧？以下的playbook可以在我的csdn代码库找到。

#### 定义Host

> 新建hosts文件，这个文件名字推荐你固定记住它。

      [tomcat-servers]
      webserver1
      webserver2
      webserver3


> 这就定义好了host,这里的xx.xx.xx.xx可以等于localhost,127.0.0.1，192.168.1.1等等。jdk标签下可以指定多个服务器ip。

#### 定义roles

> 新建site.yml文件，当然名字可以自己定义。

    ---
    # This playbook deploys a simple standalone Tomcat 7 server. 

    - hosts: tomcat-servers 
      user: root

      roles:
        - tomcat

>这就定义好了我们这个playbook的第一个最简单的主“函数”——site.yml。它告诉ansible，要在hosts文件里的jdk标签下得所有服务器以root身份执行jdk这个roles定义的动作。

#### 定义var

>既然是编排，我们肯定希望jdk的安装位置，或者版本信息可以自定义吧？

    # Here are variables related to the Tomcat installation
    
    http_port: 8080
    https_port: 8443
    
    # This will configure a default manager-gui user:
    
    admin_username: admin
    admin_password: adminsecret


>这定义的就是vars，处于group_vars/tomcat-servers，tomcat-servers需要与hosts里面的标签一致。否则默认是找不到vars的。


#### 编排playbook

    ---
    - name: Install Java 1.7
      yum: name=java-1.7.0-openjdk state=present
    
    - name: add group "tomcat"
      group: name=tomcat
    
    - name: add user "tomcat"
      user: name=tomcat group=tomcat home=/usr/share/tomcat
      sudo: True
    
    - name: delete home dir for symlink of tomcat
      shell: rm -fr /usr/share/tomcat
      sudo: True
    
    - name: Download Tomcat
      get_url: url=http://www.us.apache.org/dist/tomcat/tomcat-7/v7.0.55/bin/apache-tomcat-7.0.55.tar.gz dest=/opt/apache-tomcat-7.0.55.tar.gz
    
    - name: Extract archive
      command: chdir=/usr/share /bin/tar xvf /opt/apache-tomcat-7.0.55.tar.gz -C /opt/ creates=/opt/apache-tomcat-7.0.55
    
    - name: Symlink install directory
      file: src=/opt/apache-tomcat-7.0.55 path=/usr/share/tomcat state=link
    
    - name: Change ownership of Tomcat installation
      file: path=/usr/share/tomcat/ owner=tomcat group=tomcat state=directory recurse=yes
    
    - name: Configure Tomcat server
      template: src=server.xml dest=/usr/share/tomcat/conf/
      notify: restart tomcat
    
    - name: Configure Tomcat users
      template: src=tomcat-users.xml dest=/usr/share/tomcat/conf/
      notify: restart tomcat
    
    - name: Install Tomcat init script
      copy: src=tomcat-initscript.sh dest=/etc/init.d/tomcat mode=0755
    
    - name: Start Tomcat
      service: name=tomcat state=started enabled=yes
    
    - name: deploy iptables rules
      template: src=iptables-save dest=/etc/sysconfig/iptables
      notify: restart iptables
    
    - name: wait for tomcat to start
      wait_for: port={{http_port}}
    

>按照上面编排就行了。其中有些模块前面没做介绍，作为大家自己研究的课题：）。

>上面的playbook位于roles/tomcat/tasks/main.yml。

#### playbook的附件

>上面playbook中有template还有file模块
2个都是用来把配置文件从本地拷贝到远程节点上。其区别后面章节专门介绍。

###### template的配置文件在roles/templates/里。

###### file的配置文件在roles/files里。

>也有Handler,就是notify开头的部分，也是后面章节介绍。

    ---
    - name: restart tomcat 
      service: name=tomcat state=restarted
    
    - name: restart iptables
      service: name=iptables state=restarted


>上面的handler位于roles/handlers/main.yml。

>这就简单的完成了，tomcat的部署。还可定义节点以及tomcat-manager的管理员密码：）。
