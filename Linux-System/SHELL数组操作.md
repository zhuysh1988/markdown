Shell脚本数组操作小结
转载  2014-07-19   投稿：junjie     我要评论

这篇文章主要介绍了Shell脚本数组操作小结,包含数组定义、读取、替换、删除、复制、计算等,需要的朋友可以参考下
Linux Shell在编程方面比Windows批处理强大很多，无论是在循环、运算。

bash支持一维数组（不支持多维数组），并且没有限定数组的大小。类似与C语言，数组元素的下标由0开始编号。获取数组中的元素要利用下标，下标可以是整数或算术表达式，其值应大于或等于0。

定义数组

在Shell中，用括号来表示数组，数组元素用“空格”符号分割开。定义数组的一般形式为：
复制代码 代码如下:
数组名=(值1 值2 ... 值n)

例如：
复制代码 代码如下:

array_name=(value0 value1 value2 value3)

或者 
复制代码 代码如下:

array_name=(
value0
value1
value2
value3
)
还可以单独定义数组的各个分量： 
复制代码 代码如下:

array_name[0]=value0
array_name[1]=value1
array_name[n]=valuen
可以不使用连续的下标，而且下标的范围没有限制。

读取数组

读取数组元素值的一般格式是：

复制代码 代码如下:

${数组名[下标]}
例如： 
复制代码 代码如下:

valuen=${array_name[n]}
使用@符号可以获取数组中的所有元素，例如：

复制代码 代码如下:

echo ${array_name[@]}
获取数组的长度

获取数组长度的方法与获取字符串长度的方法相同，例如： 
复制代码 代码如下:

# 取得数组元素的个数
length=${#array_name[@]}
# 或者
length=${#array_name[*]}
# 取得数组单个元素的长度
lengthn=${#array_name[n]}
附：shell数组小结

不知道 是什么时候写的东西，整理文档时被考古发现,给那些闲着蛋疼之人，一笑而过吧。如果本文中的错误给您带来所有的精神损失，请找保险公司理陪！当然你可以告诉我 (倾诉)

数组作为一种特殊的数据结构在任何一种编程语言中都有它的一席之地，当然bash shell也不例外。本文就shell数组来做一个小的总结。
在这里只讨论一维数组的情况，关于多维数组(事实上，你得用一维数组的方法来模拟)，不涉及。这里包括数组的复制，计算，删除，替换。

数组的声明:

复制代码 代码如下:
array[key]=value # array[0]=one,array[1]=two
declare -a array # array被当作数组名

array=( value1 value2 value3 ... )

array=( [1]=one [2]=two [3]=three ... )

array="one two three" # echo ${array[0|@|*]},把array变量当作数组来处理，但数组元素只有字符串本身
数组的访问:

复制代码 代码如下:
${array[key]} # ${array[1]}
数组的删除

复制代码 代码如下:
unset array[1] # 删除数组中第一个元素
unset array # 删除整个数组

计算数组的长度:

复制代码 代码如下:
${#array}
${#array[0]} #同上。 ${#array[*]} 、${#array[@]}。注意同#{array:0}的区别
数组的提取

从尾部开始提取:
复制代码 代码如下:
array=( [0]=one [1]=two [2]=three [3]=four )
${array[@]:1} # two three four,除掉第一个元素后所有元素，那么${array[@]:0}表示所有元素
${array[@]:0:2} # one two
${array[@]:1:2} # two three
子串删除

复制代码 代码如下:

[root@localhost dev]# echo ${array[@]:0}
one two three four
[root@localhost dev]# echo ${array[@]#t*e} # 左边开始最短的匹配:"t*e",这将匹配到"thre"
one two e four

[root@localhost dev]# echo ${array[@]##t*e} # 左边开始最长的匹配,这将匹配到"three"

[root@localhost dev]# array=( [0]=one [1]=two [2]=three [3]=four )

[root@localhost dev]# echo ${array[@] %o} # 从字符串的结尾开始最短的匹配
one tw three four

[root@localhost dev]# echo ${array[@] %%o} # 从字符串的结尾开始最长的匹配
one tw three four
子串替换

复制代码 代码如下:
[root@localhost dev]# array=( [0]=one [1]=two [2]=three [3]=four )
第一个匹配到的，会被删除
复制代码 代码如下:
[root@localhost dev]# echo ${array[@] /o/m}
mne twm three fmur
所有匹配到的，都会被删除
复制代码 代码如下:
[root@localhost dev]# echo ${array[@] //o/m}
mne twm three fmur
没有指定替换子串，则删除匹配到的子符
复制代码 代码如下:
[root@localhost dev]# echo ${array[@] //o/}
ne tw three fur
替换字符串前端子串
复制代码 代码如下:
[root@localhost dev]# echo ${array[@] /#o/k}
kne two three four
替换字符串后端子串
复制代码 代码如下:
[root@localhost dev]# echo ${array[@] /%o/k}
one twk three four