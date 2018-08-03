## template模块

>上一节的第一个小playbook里，涉及到了template模块，大家都很奇怪，这个是干嘛的？
>让我们翻翻官网咋说的（经过了总节翻译）：

    template使用了Jinjia2格式作为文件模版，进行文档内变量的替换的模块。它的每次使用都会被ansible标记为”changed”状态。

## 常用参数
|参数名| 	是否必须| 	默认值| 	选项| 	说明|
|:-|:-|:-|:-|:-|
|backup |	no |	no |	yes/no |	建立个包括timestamp在内的文件备份，以备不时之需.|
|dest |	yes |||			远程节点上的绝对路径，用于放置template文件。|
|group |	no |||			设置远程节点上的的template文件的所属用户组|
|mode |	no |||			设置远程节点上的template文件权限。类似Linux中chmod的用法|
|owner |	no |||			设置远程节点上的template文件所属用户|
|src |	yes |||			本地Jinjia2模版的template文件位置。|

## 案例

- ##### 把/mytemplates/foo.j2文件经过填写参数后，复制到远程节点的/etc/file.conf，文件权限相关略过
      - template: src=/mytemplates/foo.j2 dest=/etc/file.conf owner=bin group=wheel mode=0644

- ##### 跟上面一样的效果，不一样的文件权限设置方式
      - template: src=/mytemplates/foo.j2 dest=/etc/file.conf owner=bin group=wheel mode="u=rw,g=r,o=r"

### 详细说明

>我们可以查看这里。

- ###### roles/templates/server.xml中的template文件关键部分如下：

      <user username="{{ admin_username }}" password="{{ admin_password }}" roles="manager-gui" />


>当这个文件还没被template执行的时候，本地的admin_username及admin_password 都是变量状态。

>当playbook执行完template的时候，远程的admin_username*及admin_password 会变成变量所对应的值。

## 例如：

>前面的那个Playbook,如果我们在tomcat-servers设置了这两个变量如下：

    dmin_username: admin
    admin_password: adminsecret

>那么在执行这个Playbook前，对应的那个template文件（俗称模版），将在本地保持{{ admin_username }}及{{ admin_password }}的状态。在Ansible调用template模版执行的时候，这里将由Jinjia2从”tomcat-servers”读取对应的值，然后替换掉模版里的变量，然后把这个替换变量值后的文件拷贝到远程节点。
