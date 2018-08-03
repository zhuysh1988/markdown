## shell 模块

>这个是一个很神奇的模块，它也是ansible的核心模块之一。它跟command模块一样负责在被ansible控制的节点（服务器）执行命令行。它与command模块有着相似的地方，也有不同的地方，看完这篇文章将告诉你答案。

## shell模块常用参数
|parameter|required|comments|
|:-|:-|:-|
|chdir|no|跟command一样的，运行shell之前cd到某个目录|
|creates|no|跟command一样的，如果某个文件存在则不运行shell|
|removes|no|跟command一样的，如果某个文件不存在则不运行shell|

## shell模块案例

- ### 案例1:
>让所有节点运行somescript.sh并把log输出到somelog.txt。

    $ ansible -i hosts all -m shell -a "sh somescript.sh >> somelog.txt"

- ### 案例2:
>先进入somedir/ ，再在somedir/目录下让所有节点运行somescript.sh并把log输出到somelog.txt。

    $ ansible -i hosts all -m shell -a "somescript.sh >> somelog.txt" chdir=somedir/

- ### 案例3:
>体验shell和command的区别,先cd到某个需要编译的目录，执行condifgure然后,编译，然后安装。

    $ ansible -i hosts all -m shell -a "./configure && make && make insatll" chdir=/xxx/yyy/
