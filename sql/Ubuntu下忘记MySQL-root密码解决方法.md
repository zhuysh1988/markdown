##Ubuntu下忘记MySQL root密码解决方法


>Linux下忘记MySQL root密码解决方法，基于Ubuntu 12.04 LTS。
>
>忘了mysql密码，从网上找到的解决方案记录在这里。

###编辑mysql的配置文件
    
    vim /etc/mysql/my.cnf
    在[mysqld]段下加入一行“skip-grant-tables”。
    [mysqld]
    skip-grant-table



###重启mysql服务

    www.linuxidc.com @ubuntu:~$ sudo service mysql restart  
    mysql stop/waiting  
    mysql start/running, process 18669 

###用空密码进入mysql管理命令行，切换到mysql库。

    www.linuxidc.com @ubuntu:~$ mysql  
    Welcome to the MySQL monitor.  Commands end with ; or \g.  
      
    mysql> use mysql  
    Database changed 

    mysql> update user set password=PASSWORD("new_pass") where user='root';    
    Query OK, 0 rows affected (0.00 sec)    
    Rows matched: 4  Changed: 0  Warnings: 0    
    mysql>quit 

>回到vim /etc/mysql/my.cnf，把刚才加入的那一行“skip-grant-tables”注释或删除掉。

>再次重启mysql服务sudo service mysql restart，使用新的密码登陆，修改成功。

    www.linuxidc.com @ubuntu:~$ mysql -uroot -pnew_pass  
    Welcome to the MySQL monitor.  Commands end with ; or \g.  
    mysql> 
