#nova 为何要做互信

##1.计算节点为什么要做nova 的互信？

###nova 做resize 或者冷迁移需要两台计算节点做互信。

###原因：resize（冷迁移）实际上是运行scp 文件到另一台主机上，如下的命令

    Command: ssh 172.16.170.177 mkdir -p /var/lib/nova/instances/a7b26c11-d879-4aa1-b585-6e8e455df1ec



##2.如何验证是否做了互信？

###首先说明的是每个用户都有自己的public key，所以互信是针对某个用户的，我们常用的是root的互信

###在 /root/.ssh/authtication 里面



###切换nova用户 ssh到目标计算节点，如果需要输入密码则没有做互信。

###而nova 的互信，切换到nova用户，在计算节点 /var/lib/nova/.ssh

    bash-4.2$ cd /var/lib/nova/.ssh/

    bash-4.2$ ls

    authorized_keys  id_rsa  id_rsa.pub  known_hosts



##3.做完互信还不够，第一次登陆会要求你输入yes/no

###目的是加密，会在$HOME/.ssh/known_hosts 下生成host加密信息

###

###为了保证迁移认证成功，必须要取消手动输入yes/no

###当然有人说手动刷掉，对，是可以的，但是记录的是对应到host的哪个网卡？这个就很不方便调查了。

###

###方法我试了下有两种

####1.进入nova用户（也可以不进入，但要注意 文件的权限）

    su nova

    vim $HOME/.ssh/config

    即vim /var/lib/nova/.ssh/config  （没有的话自己创建）

    StrictHostKeyChecking no



####2.直接在root用户下改

    vim /etc/ssh/ssh_config

    StrictHostKeyChecking no
