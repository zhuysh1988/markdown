# Python3.x

部分引用于<http://www.yiibai.com/python3/>

python 标准模块 <https://docs.python.org/3/library/index.html>

#运算符的类型
Python语言支持以下类型的运算符。

#算术运算符
    操作符           描述                               示例
    +               加法 相加运算两侧的值                  a + b = 31
    -               减法 操作符右侧数减去左侧操作数         a – b = -11
    *               乘法 操作符两侧的值相乘                a * b = 210
    /               除法 用运算符右侧的操作数除以左侧操作数    b / a = 2.1
    %               模 用右手操作数除以左手操作数并返回余数    b % a = 1
    **              指数 执行运算符指数(幂)计算              a**b 就是10 的20 次幂
    //              地板除 - 除法不管操作数为何种数值类型，总是会舍去小数部分，返回数字序列中比真正的商小的最接近的数字        9//2 = 4 和 9.0//2.0 = 4.0

#比较(关系)运算符

    ==      如果两个操作数的值相等，则条件计算结果为 true           (a == b) 其值不为 true.
    !=      如果两个操作数的值不相等，则条件变为 false            (a!= b) 其值为 true.
    >       如果左操作数的值大于右操作数的值，则条件为 true          (a > b) 其值不为true.
    <       如果左操作数的值小于右操作数的值，则条件为 true              (a < b) 其值为true.
    >=      如果左操作数的值大于或等于右操作数的值，则条件为 true       (a >= b) 其值不为 true.
    <=      如果左操作数的值小于或等于右操作数的值，则条件为 true       (a <= b) 其值为 true.
#赋值运算符

    =       将右侧的操作数赋值给左侧的操作数                c = a + b 是将 a + b 的值分配到 c
    +=     相加右操作数和左操作数，并分配结果到左操作数       c += a 相当于 c = c + a
    -=     左操作数减去右操作数，并分配结果到左操作数        c -= a 相当于 c = c - a
    *=     右操作数和左操作数相乘，并分配结果到左操作数       c *= a 相当于 c = c * a
    /=     左操作数除以右操作数，并分配结果到左操作数        c /= a 相当于 c = c / a；c /= a相当于 c = c / a
    %=     左操作数模除以右操作数，并分配结果到左操作数       c %= a 相当于 c = c % a
    **=     执行运算符指数(幂)计算并将结果分配值给左操作数    c **= a 相当于c = c ** a
    //=     地板除 对操作数进行地板除，并赋值给左操作数      c //= a 相当于 c = c // a

#逻辑运算符
    例:  a = true b = false
    and     逻辑与 如果两个操作数为真，则条件为true  (a and b) 结果 False.
    or      逻辑或如果两个操作数为非零，条件变为true  (a or b) 结果 True.
    not     逻辑非用来扭转操作数的逻辑状态Not      (a notb) 结果 True.

#位运算符
    例:      a = 60; 且b =13
            a = 0011 1100
            b = 0000 1101
    &     操作符复制一个位到结果如果都存在于两个操作数    (a & b) (二进制为 0000 1100)
    |     它复制一个位，如果存在于其中一个操作数           (a | b) = 61 (二进制为 0011 1101)
    ^     异或运算                                  (a ^ b) = 49 (二进制为 0011 0001)
    ~     它是一元，并具有“翻转”位的作用              (~a ) = -61 (二进制为 1100 00112 以补码形式，由于一个带符号二进制数)
    <<    二进制左移                             7 << 1 = 14  7 >> 1 = 3  
    >>    二进制右移                             111 << 1 == 1110  111 >> 1 = 11
#运算符成员
    in    如果在指定的顺序中找到变量，计算结果为true，否则为 false             x in y,  如果x是序列y的成员，则返回true
    not in    如果在指定的顺序中不能找到变量，计算结果为true，否则为 false     x not in y, 如果x不是序列y的成员，则返回true

#标识运算符
    is    如果操作符两侧是相同的对象，计算结果为true，否则结果为 false           x is y，如果ID(x)等于ID(y)返回 1
    is not    如果操作符两侧的变量是相同的对象，计算结果为false，否则 true       x is not y, 如果ID(x)不等于ID(y)返回 1

#Python运算优先级
    **    幂(指数)
    ~ + -    补，一元加号和减号(方法名的最后两个+@和 -@)
    * / % //    乘，除，取模和地板除
    + -    加法和减法
    >> <<    左，右转向按位
    &    位元“与”
    ^ |    按位异或`'和常规`或'
    <= < > >=    比较运算符
    <> == !=    操作符比较
    = %= /= //= -= += *= **=    赋值运算符
    is is not    操作符标识
    in not in    操作符成员
    not or and    逻辑运算符


#Class List 常用 Functions:
#'append', 'clear', 'copy', 'count', 'extend', 'index', 'insert', 'pop', 'remove', 'reverse', 'sort'

    aList.append(obj)                   #添加obj至aList最后,等同于 aList[len(aList):len(aList)] = [obj]
    aList.clear()                       #清空aList
    aList.copy()                        #复制aList,浅copy
    aList.count(obj)                    #计算aList中obj的个数,OR 返回aList[i] == obj中的索引i的个数
    aList.extend(sequence)              #将bList扩展至aList,等同于aList[len(aList):len(aList)] = sequence
    aList.index(obj)                    #返回aList[i]==obj中最小的i,(如果i存在会引发ValueError异常)
    aList.insert(index,obj)             #如果index>0,等同于aList[index:index] == obj;如果index=0,将obj置于aList最前面,如果index<0,将obj置于aList[i+-1]
    aList.pop(index)                    #移除并且返回给定索引的项(默认为-1)
    aList.remove(obj)                   #删除aList中的obj ,obj 等同于 aList[aList.index(obj)]
    aList.reverse()                     #原地反转aList中的项
    aList.sort(cmp,key,reverse)         #对aList中的项进行原地排序.可以提供比较函数cmp,创建用于排序的键的key函数和reverse标志(bool)进行自定义

#Class Dict 常用 Functions:
# 'clear', 'copy', 'fromkeys', 'get', 'items', 'keys', 'pop', 'popitem', 'setdefault', 'update', 'values'
    dict.clear()                        删除字典 dict 中的所有元素
    dict.copy()                         返回字典 dict 的浅表副本
    dict.fromkeys()                     使用seq的键和值来设置创建新字典
    dict.get(key, default=None)         对于键key，返回其值或default如果键不存在于字典中
    dict.has_key(key)                   返回true如果在字典dict有存在键key，否则为false
    dict.items()                        返回 dict (键，值)元组对的列表
    dict.keys()                         返回字典 dict 的键列表
    dict.setdefault(key, default=None)  类似于get()方法，但会设定dict[key]=default，如果键不存在于dict中
    dict.update(dict2)添加字典dict2的键值对到dict
    dict.values()返回字典dict值列表

#Class Str 常用 Functions:
#转义字符
下面的表格转义或不可打印字符的列表，可以用反斜杠符号来表示。

转义字符被解析; 带单引号以及双引号的字符串。

    反斜线符号  十六进制 字符描述
        \a    0x07    响铃或警报
        \b    0x08    Backspace键
        \cx           Control-x
        \C-x          Control-x
        \e    0x1b    Escape
        \f    0x0c    Formfeed
        \M-\C-x       Meta-Control-x
        \n    0x0a    新行
        \nnn          Octal notation, where n is in the range 0.7
        \r    0x0d    Carriage return
        \s    0x20    空格
        \t    0x09    Tab
        \v    0x0b    Vertical tab
        \x            Character x
        \xnn          十六进制表示法，其中n的范围是从 0.9, a.f, 或 A.F

#字符串特殊操作符
    +        拼接 - 操作符两边值相连接                         a + b =' HelloPython'
    *        重复 - 创建新的字符串，链接相同的字符串多个副本      a*2 = 'HelloHello'
    []        切片 - 提供从给定索引对应的字符                     a[1] = 'e'
    [ : ]        范围切片 - 提供从给定的范围内字符                 a[1:4] =' ell'
    in        成员操作符 - 如果一个字符在给定字符串中存在，则返回true       H in a = 1
    not in        成员操作符 - 如果一个字符在给定的字符串中不存在，则返回true     M not in = 1
    r/R        原始字符串 - 禁止转义字符实际意义。 字母“r”这是引号前导。        print r'\n' 打印 \n ， print R'\n' 打印 \n
    %        格式 - 执行字符串格式化                                      参见下一节

#字符串格式化操作
    %c        字符
    %s        通过str()来转换格式化字符串
    %i        有符号十进制整数
    %d        有符号十进制整数
    %u        无符号十进制整数
    %o        八进制整数
    %x        十六进制整数(小写字母)
    %X        十六进制整数(大写字母)
    %e        指数符号(小写“e”)
    %E        指数计数法(以大写“E”)
    %f        浮点实数
    %g        %f和%e的简写
    %G        %f和%E的简写

#其它支持的符号和功能都列在下表中 -
    符号        功能描述
    *        参数指定宽度或精度
    -        左对齐
    +        显示符号
    <sp>        在一个正数前留一个空格
    #        添加前导零('0')八进制或前导0x“或”0X“十六进制，取决于是否使用了'x'或'X'。
    0        垫留下了零(而不是空格)
    %        '%%'保留一个常量“%”
    (var)        映射变量(字典参数)
    m.n.        m是最小总宽度和n是小数点后显示数量(如果appl)
#python str function
'capitalize', 'casefold', 'center', 'count', 'encode', 'endswith', 'expandtabs', 'find', 'format', 'format_map', 'index', 'isalnum', 'isalpha', 'isdecimal',

'isdigit', 'isidentifier', 'islower', 'isnumeric', 'isprintable', 'isspace', 'istitle', 'isupper', 'join', 'ljust', 'lower', 'lstrip', 'maketrans', 'partition',

'replace', 'rfind', 'rindex', 'rjust', 'rpartition', 'rsplit', 'rstrip', 'split', 'splitlines', 'startswith', 'strip', 'swapcase', 'title', 'translate', 'upper', 'zfill'


    1
    capitalize()    将字符串的第一个字母大写
                    返回首字母大写的字符串的副本
    2
    center(width, fillchar)     返回以fillchar填充的字符串以及原始字符串中心到总 width 列
                                返回一个长充为max(len(string),width)且其中sting的副本居中的字符串,两侧使用fillchar(默认为空字符)填充
    3
    count(str, beg= 0,end=len(string))  计数str有多少次出现在在字符串中;或如果开始索引beg和结束索引 end 给出，则计算子字符串在一个字符串中出现的次数
    4
    decode(encoding='UTF-8',errors='strict')    利用注册编解码器解码编码字符串。编码默认是系统默认字符串编码
                                                返回使用给定编码方式的字符串的解码版本,,在出错时，默认引发 ValueError 错误，除非用“ignore”或“replace”
    5
    encode(encoding='UTF-8',errors='strict')    返回字符串的编码字符串版本; 在出错时，默认引发 ValueError 错误，除非用“ignore”或“replace”
                                                返回使用给定编码方式的字符串的编码版本,,在出错时，默认引发 ValueError 错误，除非用“ignore”或“replace”
    6
    endswith(suffix, beg=0, end=len(string))    确定是否字符串或字符串的子串(如果开始索引beg和结束索引end给出)以 suffix 结束; 如果是这样返回true，否则为false
                                                检查String是否以suffix结尾,可使用给定的索引start和end来选择匹配的范围
    7
    expandtabs(tabsize=8)   扩展制表符字符串到多个空格; 默认每个制表符为8个空格，如果不提供制表符的大小
                            返回字符串的副本,其中tab(\t)字符 会使用空格进行扩展,可选择使用给定的tabsize(默认为8)
    8
    find(str, beg=0 end=len(string))    确定是否在字符串或字符串找到一个子字符str(如果开始索引beg和结束索引end给出)，如果找到则返回索引，否则返回-1
                                        返回要查找的字符串的第一个索引,如果不存在,返回-1,可以通过索引自定范围
    9
    index(str, beg=0, end=len(string))  同 find()方法，如果str没有找到则引发异常
                                        返回要查找的字符串的第一个索引,如果不存在,ValueError,可以通过索引自定范围
    10
    isalnum()   如果string至少有1个字符，所有字符是字母数字则返回true，否则返回false
                检查string是否由字母或数字字符组成,是返回True, 不是返回False
    11
    isalpha()   如果string至少有1个字符，所有字符是字母则返回true，否则为false
                检查string是否由字母字符组成,是返回True, 不是返回False
    12
    isdigit()   如果字符串仅包含数字返回true，否则为false
                检查string是否由数字字符组成,是返回True, 不是返回False
    13
    islower()   如果string至少有1个可转大小写字符，所有可转大小字符是小写字母则返回true，否则为false
                检查string是中所有字母字符是否为小写,是小写字母则返回true，否则为false
    14
    isnumeric() 如果一个Unicode字符串只包含数字字符则返回true，否则为false
                snumeric() 方法检查字符串是否只包含数字字符。这种方法目前只在Unicode对象中使用。
                注：不像Python 2，在Python3所有的字符串都是Unicode格式
    15
    isspace()   如果字符串只包含空格字符则返回true，否则为false
                检查string是否由空格组成,必须全部是空格才会返回True,否则返回False
    16
    istitle()   如果字符串是否正确“titlecased”(首字母大写)返回true，否则为false
                例:
                str = "This Is String Example...Wow!!!"
                print (str.istitle())
                True
                str = "This is string example....wow!!!"
                print (str.istitle())
                False

    17
    isupper()   如果string至少有1个可转大小写字符，所有可转大小字符是大写字母则返回true，否则为false
                检查string是中所有字母字符是否为大写,是小写字母则返回true，否则为false
    18
    join(seq)   合并(符连接)序列 seq 融入一个字符串，以及使用分隔符字符串的字符串表示。
                join()方法返回该序列串元素加入到以 str 作为分隔符的字符串
                例:
                s = "-"
                seq = ("a", "b", "c") # This is sequence of strings.
                print (s.join( seq ))

                当我们运行上面的程序，会产生以下结果 -
                a-b-c
    19
    len(string) 返回字符串的长度
    20
    ljust(width[, fillchar])    返回一个空格填充字符串与原字符串左对齐到总宽度列
                示例
                下面的示例显示 ljust()方法的使用。
                #!/usr/bin/python3

                str = "this is string example....wow!!!"

                print str.ljust(50, '*')
                当我们运行上面的程序，会产生以下结果 -
                this is string example....wow!!!******************
    21
    lower() 字符串中所有大写字母转换为小写
    22
    lstrip()    删除字符串的所有前导空格
    23
    maketrans() 返回要在转换函数使用的转换表
                示例
                下面的例子显示 maketrans() 方法的使用。 在此，在一个字符串中的每个元音字母是由它的元音位取代 -

                #!/usr/bin/python3

                intab = "aeiou"
                outtab = "12345"
                trantab = str.maketrans(intab, outtab)

                str = "this is string example....wow!!!"
                print (str.translate(trantab))
                当我们运行上面的程序，会产生以下结果 -
                th3s 3s str3ng 2x1mpl2....w4w!!!
    24
    max(str)    从字符串str返回最大拼音/字母字符
    25
    min(str)    从字符串str返回最小拼音/字母字符
    26
    replace(old, new [, max])   使用 new 替换所有出现在字符串中的 old 或 如果 max 给定，替换现的 max
                str.replace(old, new[, max])
                参数
                old -- 这是要替换旧字符串

                new -- 这是新的字符串，这将用于取代旧的子字符串。

                max -- 如果给定可选参数max，只有第一个匹配项被取代

                返回值
                此方法返回所有出现被新的取代旧的子串的字符串副本。如果可选参数max给定，只有第一个匹配项取代。

                示例
                下面的示例显示 replace()方法的使用说明。
                #!/usr/bin/python3
                str = "this is string example....wow!!! this is really string"
                print (str.replace("is", "was"))
                print (str.replace("is", "was", 3))

                当我们运行上面的程序，会产生以下结果 -
                thwas was string example....wow!!! thwas was really string
                thwas was string example....wow!!! thwas is really string
    27
    rfind(str, beg=0,end=len(string))   类似于 find()，但在字符串中是从后向前搜索,返回Str第一个索引
    28
    rindex( str, beg=0, end=len(string))    类似于 index()，但在字符串中是从后向前搜索,返回Str第一个索引
    29
    rjust(width,[, fillchar])   返回一个空格填充字符串，以及原始字符串以总宽度列向右对齐  ,和ljust相反
    30
    rstrip()    删除字符串结尾的所有空格
    31
    split(str="", num=string.count(str))    根据分隔符str(如果未提供则默认为空格)分裂字符串并返回子字符串列表; 如果num给定，则分割成至多num个子字符串
                split()方法使用str作为分隔符(如果未指定则使用空格分割)在字符串返回所有单词的列表。可选 num 限制拆分数量。
                语法
                以下是 split()方法的语法 -
                str.split(str="", num=string.count(str)).
                参数
                str -- 这是分隔符，默认情况下使用空格

                num -- 这是指定要作出的行数

                返回值
                此方法返回行的列表。
                示例
                下面的示例显示 split()方法的使用。
                #!/usr/bin/python3
                str = "this is string example....wow!!!"
                print (str.split( ))
                print (str.split('i',1))
                print (str.split('w'))

                当我们运行上面的程序，会产生以下结果 -
                ['this', 'is', 'string', 'example....wow!!!']
                ['th', 's is string example....wow!!!']
                ['this is string example....', 'o', '!!!']
    32
    splitlines( num=string.count('\n')) 拆分所有(或num)字符串换行符，并返回每行去除换行后的列表
                splitlines()方法返回字符串的所有行列表，可选包括换行符(如果num提供那么为true)
                语法
                下面是 splitlines()方法的语法 -
                str.splitlines( num=string.count('\n'))
                参数
                num -- 这可以是任何数目，如果存在则它将假设换行符需要包括在行中。

                返回值
                如果找到匹配的字符串该方法返回true，否则为false。
                示例
                下面的例子显示 splitlines()方法的使用。
                #!/usr/bin/python3
                str = "this is \nstring example....\nwow!!!"
                print (str.splitlines( ))

                当我们运行上面的程序，会产生以下结果 -
                ['this is ', 'string example....', 'wow!!!']
    33
    startswith(str, beg=0,end=len(string))  确定字符串或字符串的子串是否以(如果开始索引beg和结束索引end给出)子字串str开头; 如果是返回true，否则为false
                startswith()方法检查字符串是否以str开始，可选限制在使用给定start和end的索引内匹配。
                语法
                以下是 startswith()方法的语法：
                str.startswith(str, beg=0,end=len(string));
                参数
                str -- 这是要检查的字符串

                beg -- 这是可选的参数用来设置匹配的边界开始的索引

                end -- 这是可选的参数用来设置匹配的边界结束索引

                返回值
                如果找到匹配的字符串该方法返回true，否则为false。
                示例
                下面的示例显示startswith()方法的使用。
                #!/usr/bin/python3
                str = "this is string example....wow!!!"
                print (str.startswith( 'this' ))
                print (str.startswith( 'string', 8 ))
                print (str.startswith( 'this', 2, 4 ))
                当我们运行上面的程序，会产生以下结果 -
                True
                True
                False
    34
    strip([chars])  对字符串同时执行lstrip()和rstrip()
    35
    swapcase()  反转在字符串中的所有字母大小写(大写转小写，小写转大写)
    36
    title() 返回“titlecased”字符串的版本，也就是所有的字开头大写，其余小写
    37
    translate(table, deletechars="")    根据翻译表str(256字母)转换字符串，删除那些在del字符串
    38
    upper() 将字符串的小写字母转换为大写
    39
    zfill (width)   返回原字符串左边用零填充到总宽度的字符; zfill()保留给任何正负号(少一个零)
            zfill()方法用零来填充垫字符串左侧宽度。
            语法
            以下是zfill()方法的语法 -
            str.zfill(width)
            参数
            width -- 这是字符串的最终宽度。填充零之后的总宽度。

            返回值
            此方法返回填充字符串
            示例
            下面的示例显示 zfill()方法的使用
            #!/usr/bin/python3
            str = "this is string example....wow!!!"
            print ("str.zfill : ",str.zfill(40))
            print ("str.zfill : ",str.zfill(50))
            当我们运行上面的程序，会产生以下结果 -
            str.zfill :  00000000this is string example....wow!!!
            str.zfill :  000000000000000000this is string example....wow!!!
    40
    isdecimal()
    如果一个Unicode字符串只包含小数点字符则返回 true，否则为 false
            isdecimal()方法检查字符串是否只包含小数字符。 这个方法只在Unicode对象存在。
            注：不像在Python2，在Python3所有的字符串表示为Unicode，如下面的例子。
            语法
            以下是 isdecimal() 方法的语法 -
            str.isdecimal()
            参数
            NA

            返回值
            如果字符串中的所有字符都是十进制的该方法返回：true，否则为：false。
            示例
            下面的示例显示 isdecimal()方法的使用。
            #!/usr/bin/python3
            str = "this2016"
            print (str.isdecimal())

            str = "23443434"
            print (str.isdecimal())
            当我们运行上面的程序，会产生以下结果 -
            False
            True
