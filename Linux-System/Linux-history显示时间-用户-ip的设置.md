###Linux history显示时间/用户/ip的设置
 
     在使用linux服务器的时候发生一些不知道谁操作的问题，google一下说history命令可以查看到历史记录，用过之后发现还是不够详细，再google，原来可以自己设置history的显示。
      记录设置过程以备换系统用
 
#1.用vi编辑器打开/etc/profile
#2.加两句代码
代码代码 
 
    USER_IP=`who -u am i 2>/dev/null| awk '{print $NF}'|sed -e 's/[()]//g'`  

    export HISTTIMEFORMAT="[%F %T][`whoami`][${USER_IP}] "  
 
3
    
    .source /etc/profile

4.执行

    history
     显示如下：
    1000  [2012-09-08 04:05:09][root][192.168.10.136] history
     1001  [2012-09-08 04:14:24][root][192.168.10.136] cd root
     1002  [2012-09-08 04:14:27][root][192.168.10.136] ls
     1003  [2012-09-08 04:14:30][root][192.168.10.136] cd /opt
