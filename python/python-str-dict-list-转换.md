#1、字典（dict）

    dict = {‘name’: ‘Zara’, ‘age’: 7, ‘class’: ‘First’}

#1.1 字典——字符串

    type(str(dict))

#1.2 字典——元组

    tuple(dict)

#1.3 字典——元组

    tuple(dict.values())

#1.4 字典——列表


    list(dict)

#1.5 字典——列表

    dict.values



#2、元组

    tup=(1, 2, 3, 4, 5)

#2.1 元组——字符串

    tup.__str__()

#2.2 元组——列表

     list(tup)

#2.3 元组不可以转为字典



#3、列表

    nums=[1, 3, 5, 7, 8, 13, 20];

#3.1 列表——字符串

    str(nums)

#3.2 列表——元组

    tuple(nums)

#3.3 列表不可以转为字典



#4、字符串

#4.1 字符串——元组

    tuple(eval("(1,2,3)"))

#4.2 字符串——列表

     list(eval("(1,2,3)"))

#4.3 字符串——字典

    type(eval("{'name':'ljq', 'age':24}"))
    
from:<http://blog.csdn.net/violet_echo_0908/article/details/52486689>
