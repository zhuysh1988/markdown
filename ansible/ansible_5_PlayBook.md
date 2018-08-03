## Playbook

>Playbook的定义，用中文我很难准确的说明它的意思。还是引用官方的吧：

    Playbooks are Ansible’s configuration, deployment, and orchestration language. They can describe a policy you want your remote systems to enforce, or a set of steps in a general IT process.

>大概意思就是说，playbook是集ansible的配置管理、部署动作执行、编排能力于一身的语言文本。它用来编排并执行你想远程节点执行的常规步骤、流程。很拗口，大概大家明白意思就行了。

>另外有个简单点的说法，也是来自官方：

    If Ansible modules are the tools in your workshop, playbooks are your design plans.

>意思就是ansible模块是你工作的伙伴，那么Playbook就是你工作计划。

>一个负责执行，一个负责计划，Nice。

>一个简单的playbook

### 一个简单的playbook应该如下：

    ---    <---playbook的开头
    - hosts: webservers   <--- 声明这个Playbook运行在哪个节点群组
      vars:   <--- 声明 变量
        http_port: 80  <--- 变量http_port 值为80
        max_clients: 200
      remote_user: root  <---声明远程执行的用户为root
      tasks:  <---声明远程执行的任务
      - name: ensure apache is at the latest version <---ansible name模块，用于当文字说明
        yum: pkg=httpd state=latest <---ansible yum模块，以后会讲到
      - name: write the apache config file
        template: src=/srv/httpd.j2 dest=/etc/httpd.conf <---ansible template模块，以后会讲到
        notify:   <---ansible handler用法以后会讲到
        - restart apache
      - name: ensure apache is running (and enable it at boot)
        service: name=httpd state=started enabled=yes <---ansible service模块，以后会讲到
      handlers: <---ansible handler用法以后会讲到
        - name: restart apache
          service: name=httpd state=restarted

>上面这个playbook干了什么事，讲解下task部分，可能熟悉Linux的人也能猜个78成：

    1. 使用yum安装了最新版apache
    2. 将httpd.conf配置文件从ansible执行节点的/srv/httpd.j2覆盖到了/etc/httpd.conf
    3. 调用Handler重启apache
    4. 调用service确认apache已经重启过并且设置为开机就启动apache
    5. 定义handler

>上面这么多事，如果用传统的shell来执行会很麻烦，有多麻烦，玩过shell的都明白。
>能明白点它事做啥的了吧？

>它的格式是YAML语法，可以下来自己看看，很简单的东西。