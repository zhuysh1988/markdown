## SHELL IF 比较和检测选项
 Linux shell if [ -n ] 正确使用方法

if [ str1 = str2 ]　　　　　  当两个串有相同内容、长度时为真 
if [ str1 != str2 ]　　　　　 当串str1和str2不等时为真 
if [ -n str1 ]　　　　　　 当串的长度大于0时为真(串非空) 
if [ -z str1 ]　　　　　　　 当串的长度为0时为真(空串) 
if [ str1 ]　　　　　　　　 当串str1为非空时为真

shell 中利用 -n 来判定字符串非空。

错误用法：

ARGS=$*

if [ -n $ARGS  ]

then

   print "with argument"

fi

print " without argument"

不管传不传参数，总会进入if里面。

原因：因为不加“”时该if语句等效于if [ -n ]，shell 会把它当成if [ str1 ]来处理，-n自然不为空，所以为正。

 

正确用法：需要在$ARGS上加入双引号，即"$ARGS".

 

ARGS=$*

if [ -n "$ARGS"  ]

then

   print "with argument"

fi

print " without argument"


    [ -f "somefile" ] ：判断是否是一个文件
    [ -x "/bin/ls" ] ：判断/bin/ls是否存在并有可执行权限
    [ -n "$var" ] ：判断$var变量是否有值
    [ "$a" = "$b" ] ：判断$a和$b是否相等
    -r file　　　　　用户可读为真
    -w file　　　　　用户可写为真
    -x file　　　　　用户可执行为真
    -f file　　　　　文件为正规文件为真
    -d file　　　　　文件为目录为真
    -c file　　　　　文件为字符特殊文件为真
    -b file　　　　　文件为块特殊文件为真
    -s file　　　　　文件大小非0时为真
    -t file　　　　　当文件描述符(默认为1)指定的设备为终端时为真

    含条件选择的shell脚本 对于不含变量的任务简单shell脚本一般能胜任。但在执行一些决策任务时，就需要包含if/then的条件判断了。shell脚本编程支持此类运算，包括比较运算、判断文件是否存在等。
    基本的if条件命令选项有： - eq —比较两个参数是否相等（例如，if [ 2 –eq 5 ]）
    -ne —比较两个参数是否不相等
    -lt —参数1是否小于参数2
    -le —参数1是否小于等于参数2
    -gt —参数1是否大于参数2
    -ge —参数1是否大于等于参数2
    -f — 检查某文件是否存在（例如，if [ -f "filename" ]）
    -d — 检查目录是否存在
    几乎所有的判断都可以用这些比较运算符实现。脚本中常用-f命令选项在执行某一文件之前检查它是否存在。
### A - Z     

    [-a file] 如果file存在则为真
    [-b file] 如果file存在且是一个块特殊文件则为真
    [-c file] 如果file存在且是一个字特殊文件则为真
    [-d file] 如果file文件存在且是一个目录则为真
    -d前的!是逻辑非
    例如：
    if [ ! -d $lcd_path/$par_date ]
    表示后面的那个目录不存在，则执行后面的then操作
    [-e file] 如果file文件存在则为真
    [-f file] 如果file存在且是一个普通文件则为真
    [-g file] 如果file存在且已经设置了SGID则为真（SUID 是 Set User ID, SGID 是 Set Group ID的意思）
    [-h file] 如果file存在且是一个符号连接则为真
    [-k file] 如果file存在且已经设置粘制位则为真
    当一个目录被设置为"粘制位"(用chmod a+t),则该目录下的文件只能由
    一、超级管理员删除
    二、该目录的所有者删除
    三、该文件的所有者删除
    也就是说,即便该目录是任何人都可以写,但也只有文件的属主才可以删除文件。
    具体例子如下：
    #ls -dl /tmp
    drwxrwxrwt 4 root    root  .........
    注意other位置的t，这便是粘连位。
    [-p file] 如果file存在且是一个名字管道（F如果O）则为真
    管道是linux里面进程间通信的一种方式，其他的还有像信号（signal）、信号量、消息队列、共享内存、套接字（socket）等。
    [-r file] 如果file存在且是可读的则为真
    [-s file] 如果file存在且大小不为0则为真
    [-t FD] 如果文件描述符FD打开且指向一个终端则为真
    [-u file] 如果file存在且设置了SUID（set userID）则为真
    [-w file] 如果file存在且是可写的则为真
    [-x file] 如果file存在且是可执行的则为真
    [-O file] 如果file存在且属有效用户ID则为真
    [-G file] 如果file存在且属有效用户组则为真
    [-L file] 如果file存在且是一个符号连接则为真
    [-N file] 如果file存在and has been mod如果ied since it was last read则为真
    [-S file] 如果file存在且是一个套接字则为真
    [file1 –nt file2] 如果file1 has been changed more recently than file2或者file1 exists and file2 does not则为真
    [file1 –ot file2] 如果file1比file2要老，或者file2存在且file1不存在则为真
    [file1 –ef file2] 如果file1和file2指向相同的设备和节点号则为真
    [-o optionname] 如果shell选项“optionname”开启则为真
    [-z string] “string”的长度为零则为真
    [-n string] or [string] “string”的长度为非零non-zero则为真
    [sting1==string2] 如果2个字符串相同。“=”may be used instead of “==”for strict posix compliance则为真
    [string1!=string2] 如果字符串不相等则为真
    [string1<string2] 如果“string1”sorts before“string2”lexicographically in the current locale则为真
    [arg1 OP arg2] “OP”is one of –eq,-ne,-lt,-le,-gt or –ge.These arithmetic binary oprators return true if “arg1”is equal to,not equal to,less than,less than or equal to,greater than,or greater than or equal to“agr2”,respectively.“arg1”and “agr2”are integers. 
