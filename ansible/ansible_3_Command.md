### command 模块
>这里需要说明下的就是，ansible本身是没有部署能力的，它只是个框架，它的模块才有真正的部署能力。

>安装完ansible我们执行的第一条命令行：

    ansible -i hosts all -m ping

>它就是用的ansible命令行.

    -i 表示使用当前目录下的hosts文件
    all表示Host文件内声明的所有服务器
    -m ping 表示使用module名为ping的module，这个module没有参数，所以就这样调用就行了。


>我们从官网默认的模块顺序开始（当然也是经常用的）。

### Command 模块

>command 模块用于运行系统命令，比如echo hello, 你安装在系统里的Python，或者make 一类。大家能领悟就行了。

### 常用参数：

|parameter|required|comments|
|:-|:-|:-|
|chdir|no|运行command命令前先cd到这个目录|
|creates|no|如果这个参数对应的文件存在，就不运行command|
|executable|no|将shell切换为command执行，这里的所有命令需要使用绝对路径|
|removes|no|如果这个参数对应的文件不存在，就不运行command|

### 案例：

- ### ansible 命令调用command:

    ansible -i hosts all -m command -a "/sbin/shutdown -t now"

>ansible命令行调用-m command模块 -a表示使用参数 “”内的为执行的command命令，该命令为关机。
>那么对应的节点(192.168.10.12,127.152.112.13)都会执行关机。

- ### Run the command if the specified file does not exist.
      ansible -i hosts all -m command -a "/usr/bin/make_database.sh arg1 arg2 creates=/path/to/database"

>利用creates参数，判断/path/to/database这个文件是否存在，存在就跳过command命令，不存在就执行command命令。
