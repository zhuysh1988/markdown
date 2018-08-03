#A.将日期转换为Unix时间戳
将当前时间以Unix时间戳表示：
    
    date +%s
    输出如下：
    1361542433

转换指定日期为Unix时间戳：
    
    date -d '2013-2-22 22:14' +%s
    输出如下：
    1361542440
    
#B.将Unix时间戳转换为日期时间
不指定日期时间的格式：

    date -d @1361542596
    输出如下：
    Fri Feb 22 22:16:36 CST 2013 指定日期格式的转换：
指定日期格式:

    date -d @1361542596 +"%Y-%m-%d %H:%M:%S"
    输出如下：
    2013-02-22 22:16:36

#Linux date日期格式及加减运算

 
显示时间是个常用的命令，在写shell脚本中也经常会用到与日期相关文件名或时间显示。

无论是linux还是windows下都是date命令。 

#Linux下date命令用法

    date [OPTION]… [+FORMAT]
    date [-u|--utc|--universal] [MMDDhhmm[[CC]YY][.ss]]
 
#date命令参数
    -d, –date=STRING  显示STRING指定的时间
    -f, –file=DATEFILE  类似–date参数显示DATEFILE文件中的每行时间
    -ITIMESPEC, –iso-8601[=TIMESPEC]  以ISO  8601 格式显示日期/时间。TIMESPEC为”date”(只显示日期)、”hours”、”minutes”、”senconds”(显示时间精度)之一，默认为”date”。
    -r, –reference=FILE  显示文件的最后修改时间
    -R, –rfc-2822  以RFC-2822兼容日期格式显示时间
    -s, –set=STRING  设置时间为STRING
    -u, –utc, –universal  显示或设定为Coordinated Universal Time时间格式
    date命令输出显示格式
    %%    字符%
    %a     星期的缩写(Sun..Sat)
    %A    星期的完整名称 (Sunday..Saturday)
    %b     月份的缩写(Jan..Dec)
    %B     月份的完整名称(January..December)
    %c     日期时间(Sat Nov 04 12:02:33 EST 1989)
    %C     世纪(年份除100后去整) [00-99]
    %d     一个月的第几天(01..31)
    %D     日期(mm/dd/yy)
    %e     一个月的第几天 ( 1..31)
    %F    日期，同%Y-%m-%d
    %g     年份(yy)
    %G     年份(yyyy)
    %h     同%b
    %H    小时(00..23)
    %I     小时(01..12)
    %j     一年的第几天(001..366)
    %k     小时( 0..23)
    %l      小时( 1..12)
    %m    月份(01..12)
    %M    分钟(00..59)
    %n     换行
    %N     纳秒(000000000..999999999)
    %p     AM or PM
    %P     am or pm
    %r     12小时制时间(hh:mm:ss [AP]M)
    %R    24小时制时间(hh:mm)
    %s     从00:00:00 1970-01-01 UTC开始的秒数
    %S     秒(00..60)
    %t     制表符
    %T    24小时制时间(hh:mm:ss)
    %u     一周的第几天(1..7);  1 表示星期一
    %U     一年的第几周，周日为每周的第一天(00..53)
    %V     一年的第几周，周一为每周的第一天 (01..53)
    %w     一周的第几天 (0..6);  0 代表周日
    %W    一年的第几周，周一为每周的第一天(00..53)
    %x     日期(mm/dd/yy)
    %X     时间(%H:%M:%S)
    %y     年份(00..99)
    %Y     年份 (1970…)
    %z     RFC-2822 风格数字格式时区(-0500)
    %Z     时区(e.g., EDT), 无法确定时区则为空
 
以下是做的一些实验，便于理解  www.2cto.com  
 
    $ date -d "2010-11-15 23:00:01"
    Mon Nov 15 23:00:01 PST 2010
    $ date -d "2010/11/15 23:0:2"
    Mon Nov 15 23:00:02 PST 2010
    $ date -d "2010/11/15T23:0:2"
    Mon Nov 15 08:00:02 PST 2010
    $
    $ echo "2010-11-15 23:00:01" > date.txt
    $ echo "2010/11/15 23:00:02" >> date.txt
    $ cat date.txt
    2010-11-15 23:00:01
    2010/11/15 23:00:02
    $ date -f date.txt
    Mon Nov 15 23:00:01 PST 2010
    Mon Nov 15 23:00:02 PST 2010
    $
    $ ls -l
    total 4
    -rw-r--r-- 1 znan sybase    40 Nov 15 21:14 date.txt
    $ date -r date.txt
    Mon Nov 15 21:14:36 PST 2010
    $
    $ date -I
    2010-11-15
    $ date -Ihours
    2010-11-15T21-0800
    $ date -Iminutes
    2010-11-15T21:16-0800
    $ date -Iseconds
    2010-11-15T21:16:24-0800
    $
    $ date -R
    Mon, 15 Nov 2010 21:47:08 -0800
    $ date -u
    Tue Nov 16 05:47:13 UTC 2010
    $
    $ date +"Today is %A."
    Today is Monday.
    $ date +"Date:%b. %e, %G"
    Date:Nov. 15, 2010
    $ date +"Date: %b.%e, %G"
    Date: Nov.15, 2010
    $ date +"%x %X"
    11/15/2010 09:50:21 PM
    $ date +"%Y-%m-%d %H:%M:%S"
    2010-11-15 21:51:32
    $ date +"%Y-%m-%d %I:%M:%S %p"
    2010-11-15 09:51:55 PM
 
------------------------------------
    Linux date 常用时间格式
    date=$(date "+%Y-%m-%d___%H:%M:%S")
    echo date
    2012-08-16___05:52:20
     
    date "+%Y-%m-%d"
    2012-08-16
------------------------------------
#Linux date 日期加减运算
    date            // 默认时间格式
    Thu Aug 16 05:42:38 UTC 2012
     
    date +"%b %e, %G"            // 定制格式
    Aug 16, 2012
     
    date +"%b %e, %G" -d'-1 day'      或  date -d'-1 day' +"%b %e, %G"    // 减一天（加一天类似）
    Aug 15, 2012
     
    date +"%b %e, %G" -d'+1 month'  或  date -d'+1 month' +"%b %e, %G"      // 加一月（减一月类似）
    Sep 16, 2012
     
    date +"%Y年%m月%d日"
    2012年08月20日
     
    date +"%Y年%m月%d日" -d'-1 day'    // 同上面加减1天（或加减1月）
    2012年08月19日
     
    date +"%Y年%-m月%d日"     // %-m 去除月份对其的零
    2012年8月20日


    date +"%Y%m%d" -d "20170831 +1 day" 
    20170901

------------------------------------
#Ubuntu 修改系统时间
    sudo date -s MM/DD/YY
    sudo date -s hh:mm:ss
    注意，这里说的是系统时间，是linux由操作系统维护的。
 
在系统启动时，Linux操作系统将时间从CMOS中读到系统时间变量中，以后修改时间通过修改系统时间实现。为了保持系统时间与CMOS时间的一致性，Linux每隔一段时间会将系统时间写入CMOS。由于该同步是每隔一段时间（大约是11分钟）进行的，在我们执行date -s后，如果马上重起机器，修改时间就有可能没有被写入CMOS,这就是问题的原因。
 
#如果要确保修改的硬件时间生效，可以执行如下命令。
    sudo dwclock -w   或 
    sudo clock -w（ubuntu下有时候无法用clock -w 
    没有这个命令 如果没有就 使用这个hwclock -w）
这个命令强制把系统时间写入CMOS。
 
#查看硬件时间

     sudo hwclock --show
    $ sudo hwclock --show
    Thursday, August 16, 2012 PM04:46:32 UTC  -0.664019 seconds
 
核心提示：让VMware虚拟机上的ubuntu10.10时间与网络同步
 每次启动虚拟机后，ubuntu10.10的时间都不合适，发现需要这样设置：
系统–>系统管理–>时间和日期
时区选择：Asia/Chongqing
配置选择：与互联网服务器保持同步（这时提示需要安装名称为ntp的软件，安装即可，安装后提示要替换一个文件，选择“替换“）
时间服务器选择：time.nuri.net(Korea,Asia)
