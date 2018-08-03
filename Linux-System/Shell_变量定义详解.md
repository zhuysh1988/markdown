Shell编程之Shell变量学习总结
作者： 字体：[增加 减小] 类型：转载 时间：2014-03-05 我要评论
这篇文章主要介绍了Shell脚本编程中Shell变量的学习总结,需要的朋友可以参考下
1.	一、变量操作
A.变量显示、打印
语法：echo $var
B.变量设置
语法：var=value
变量的设置规则：
1．变量两端不能直接接空格符
2．变量名称只能是因为字母与数字，但开头不能使数字
3．双引号内的特殊字符如$等，保持原本特性
复制代码代码如下:
[root@bogon ~]# var="lang is $LANG"
[root@bogon ~]# echo %var
root@bogon ~]# echo $var
lang is zh_CN.UTF-8

1. 单引号内的特殊字符则仅为一般字符
复制代码代码如下:
[root@bogon ~]#
[root@bogon ~]# var='lang is $LANG';echo $var
lang is $LANG

2. 在一串命令中，还需要通过其他命令提供的信息，可用单引号‘命令'或&（命令），举例：指令1在执行的过程中需要先知道指令2的的值，但是指令1,2在一串指令中
复制代码代码如下:
[root@bogon ~]# uname -r
2.6.18-371.el5
[root@bogon ~]# cd /lib/modules/$(uname -r)/kernel
[root@bogon kernel]#

3. 变量的累加
复制代码代码如下:
[root@bogon kernel]# var=${var}yes
[root@bogon kernel]# echo $var
lang is $LANGyes

4. 数组变量设置与读取
复制代码代码如下:
[root@bogon ~]# array[1]=a
[root@bogon ~]# array[2]=b
[root@bogon ~]# array[3]=c
[root@bogon ~]# echo ${array[1]}
a
[root@bogon ~]# echo ${array[2]}

[root@bogon ~]# echo ${array[3]}
c
C.取消变量(unset)
语法: unset var
D.变量查看(set)
语法：set
比较重要的几个自定义变量
HISTFILE:历史记录存储位置
MAILCHECK:多少秒扫描次邮箱，查看是否有新邮件
PS1:提示符设置
$:目前这个shell的PID
?:刚才执行完命令的回传码。0为正确，非0为错误
举例：
复制代码代码如下:

比较重要的几个自定义变量
HISTFILE:历史记录存储位置
MAILCHECK:多少秒扫描次邮箱，查看是否有新邮件
PS1:提示符设置
$:目前这个shell的PID
?:刚才执行完命令的回传码。0为正确，非0为错误
E.变量键盘读取(read)
语法：read [-pt] var
选项与参数：
-p:后可跟提示信息
-t:后跟等待输入的描述

举例：
复制代码代码如下:

[plain] view plaincopyprint?
[root@bogon ~]# read atest  
this is a test  
[root@bogon ~]# echo $atest  
this is a test  
[root@bogon ~]# read -p "please input.. " attest    
please input.. hello world      =>提示信息  
[root@bogon ~]# echo $atest  
hello world  
[root@bogon ~]# read -p "please input.. " -t 5  atest  
please input..  =>5秒未输入回到命令行模式  
[root@bogon ~]#   
[root@bogon ~]# echo $atest  
hello world
F.变量声明(declare)
语法：declare [-aixr] var
选项与参数 
declare后不接任何内容，代表查询所有变量，作用和set一致
-a  ：将后面名为 variable的变量定义成为数组 (array)类型
-i  ：将后面名为 variable的变量定义成为整数数字 (integer)类型
-x  ：用法与 export一样，就是将后面的 variable变成环境变量；
+x ：将环境变量变为自定义变量
-r  ：将变量配置成为 readonly类型，该变量不可被更改内容，也不能 unset（需要注销后再登陆才能变回）

举例：
复制代码代码如下:
[plain] view plaincopyprint?
[root@bogon ~]# echo $sum  
100+50+10 =>默认当做字符串处理  
[root@bogon ~]# declare -i sum=100+50+10   
[root@bogon ~]# echo $sum  
160 =>声明为int 因此可以做加法  
[root@bogon ~]# declare -x sum  
[root@bogon ~]# export | grep sum  
declare -ix sum="160" =>查询到是环境变量  
[root@bogon ~]# declare +x sum  
[root@bogon ~]# export | grep sum= >查询不到是环境变量  
[root@bogon ~]# declare -r sum;sum=test  
bash: sum: readonly variable =>只读允许修改 
G.变量内容删除
语法
${var#/key}:从前往后删除符合key最短的那一个
${var##/key}:从前往后删除符合key最长的那一个
${var%/key}:从后往前删除符合key最短的那一个
${var%%/key}:从后往前删除符合key最短的那一个

举例：${var#/key}
复制代码代码如下:
[plain] view plaincopyprint?
[root@bogon ~]# path=${PATH};echo $path  
/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/X11R6/bin:/root/bin  
[root@bogon ~]# echo ${path#/*:}        =>key为*.(*为通配符)  
/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/X11R6/bin:/root/bin 


举例：${var##/key}
复制代码代码如下:
[plain] view plaincopyprint?
[root@bogon ~]# path=${PATH};echo $path  
/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/X11R6/bin:/root/bin  
[root@bogon ~]# echo ${path##/*:}  
/root/bin 
H.变量内容替换
语法：
${var/旧字符串/新字符串}:替换第一个满足条件的字符串
${var//旧字符串/新字符串}:替换所有满足条件的字符串
举例：${var/旧字符串/新字符串}
复制代码代码如下:
[plain] view plaincopyprint?
root@bogon ~]# path=${PATH};echo $path  
/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/X11R6/bin:/root/bin  
[root@bogon ~]# echo ${path/sbin/SBIN}  
/usr/kerberos/SBIN:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/X11R6/bin:/root/bin 


举例：${var//旧字符串/新字符串}
复制代码代码如下:
[plain] view plaincopyprint?
[root@bogon ~]# path=${PATH};echo $path  
/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/X11R6/bin:/root/bin  
[root@bogon ~]# echo ${path//sbin/SBIN}  
/usr/kerberos/SBIN:/usr/kerberos/bin:/usr/local/SBIN:/usr/local/bin:/SBIN:/bin:/usr/SBIN:/usr/bin:/usr/X11R6/bin:/root/bin 
2.	二、环境变量

普通变量可以理解为局部变量，环境变量可以理解为全局变量，登陆成功获得的bash shell就是一个进程，在此情况下再去打开一个新SHELL就是他的子进程，子进程是无法获取父进程的自定义变量，但是可以获取父进程的环境变量

A.环境变量导出(export )
语法：export  var

B.环境变量查看(env )

语法：env

比较重要的几个环境变量
HOME:代表用户的主文件夹
SHELL:代表目前使用的shell是哪个程序，我现在使用的是/bin/bash
HISTSIZE:历史记录最大存储条数
MAIL:mail命令系统收信时，系统会读取的信箱文件
PATH:执行文件查找路径
LANG:语系信息
RANDOM:随机数变量（0~32767）

三、提示符的设置(PS1)

变量PS1='[\u@\h \W]\$ '记录了命令提示符的显示格式 [root@bogon ~]#

符号意义
\d ：可显示出[星期月日]的日期格式，如："Mon Feb 2"
\H ：完整的主机名。
\h ：仅取主机名在第一个小数点之前的名字
\t ：显示时间，为 24小时格式的[HH:MM:SS]
\T ：显示时间，为 12小时格式的[HH:MM:SS]
\A ：显示时间，为 24小时格式的[HH:MM]
\@ ：显示时间，为 12小时格式的[am/pm]样式
\u ：目前使用者的账号名称，如[root]；
\v ：BASH的版本信息，如鸟哥的测试主板本为 3.2.25(1)，仅取[3.2]显示
\w ：完整的工作目录名称，由根目录写起的目录名称。但家目录会以 ~取代；
\W ：利用 basename函数取得工作目录名称，所以仅会列出最后一个目录名。
\# ：下达的第几个命令。
\$ ：提示字符，如果是 root时，提示字符为 #，否则就是 $

举例：
复制代码代码如下:
[root@bogon ~]# PS1='[\u@\h\A \W \#]\$ '
[root@bogon23:45 ~ 82]#

