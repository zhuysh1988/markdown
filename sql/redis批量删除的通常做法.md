redis批量删除的通常做法：

    redis-cli keys "blacklist*" | xargs redis-cli del
上面的命令在key的前后没有空格时是可以的，但有空格就不行了：

    $redis-cli keys "blacklist*"
    1) "blacklist:12: 361942420@qq.com "
注意到361942420@qq.com前后都有一个空格

有空格的话，就要把key用双引号括起来，像这样是可以删除的：

    $redis-cli del "blacklist:12: 361942420@qq.com "
那批量的操作怎么做呢？

最后的解决办法是，用引号括起来，为每一个key拼好一个命令：

    $redis-cli keys "blacklist*" > keys.txt
    $awk '$0="redis-cli del \""$0"\""' keys.txt > cmd.txt
    $cat cmd.txt
    redis-cli del "blacklist:12: 361942420@qq.com "
再执行cmd.txt：

    $chmod a+x cmd.txt
    $./cmd.txt
最后要说的是，在key的前后引入的空格是一个失误，实际上应该trim一下


批量删除Key
Redis 中有删除单个 Key 的指令 DEL，但好像没有批量删除 Key 的指令，不过我们可以借助 Linux 的 xargs 指令来完成这个动作


    redis-cli -h ip -p port keys "*"| xargs redis-cli -h ip -p port del

    //如果redis-cli没有设置成系统变量，需要指定redis-cli的完整路径

    //如：/opt/redis/redis-cli
     keys "*" | xargs /opt/redis/redis-cli del
如果要指定 Redis 数据库访问密码，使用下面的命令


    redis-cli
    -h ip -p port -a password keys "*"|
     xargs redis-cli
    -h ip -p port -a password del
如果要访问 Redis 中特定的数据库，使用下面的命令



//下面的命令指定数据序号为0，即默认数据库

    redis-cli
    
    -h ip -p port -n 0 keys "*"|
     xargs redis-cli
    -h ip -p port -n 0 del
删除所有Key

删除所有Key，可以使用Redis的flushdb和flushall命令



//删除当前数据库中的所有Key

    flushdb

//删除所有数据库中的key

    flushall
注：keys 指令可以进行模糊匹配，但如果 Key 含空格，就匹配不到了，暂时还没发现好的解决办法。
