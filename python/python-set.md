set 顾明思义，就是个集合，集合的元素是唯一的，无序的。一个{ }里面放一些元素就构成了一个集合，

set里面可以是多种数据类型（但不能是列表，集合，字典，可以是元组）
#set 的创建：

    >>> L1 = [1,1,2,4,3]  
    >>> T1 = (2,4,6,6,6,7)  
    >>> s = {1}  
    >>> type(s)  
    <class 'set'>  
    >>> s = set(L1) #从列表到集合  
    >>> s  
    {1, 2, 3, 4}  
    >>> s = set(T1) #从tuple到set  
    >>> s  
    {2, 4, 6, 7}  
    >>> s = {1,2.3,'a'}  

#set 基本函数与操作：
#s.add( x ) 
将元素 x 添加到集合s中，若重复则不进行任何操作
 
    >>> s = {1,2,'a'}  
    >>> s.add('b')  
    >>> s  
    {1, 'a', 2, 'b'}  
    >>> s.add(1)  
    >>> s  
    {1, 'a', 2, 'b'}  

#s.update( x )   
将集合 x 并入原集合s中，x 还可以是列表，元组，字典等，x 可以有多个，用逗号分开
 
    >>> s  
    {1, 'a', 2, 'b'}  
    >>> s.update({1,3})  
    >>> s  
    {1, 'a', 3, 'b', 2}  
    >>> s.update([1,4])  
    >>> s  
    {1, 'a', 3, 4, 'b', 2}  
    >>> s.update(1)  
    Traceback (most recent call last):  
      File "<pyshell#264>", line 1, in <module>  
        s.update(1)  
    TypeError: 'int' object is not iterable  

#s.discard( x ）
将 x 从集合s中移除，若x不存在，不会引发错误

    >>> s  
    {1, 'a', 3, 4, 'b', 2}  
    >>> s.discard(1)  
    >>> s  
    {'a', 3, 4, 'b', 2}  
    >>> s.discard(1)  
    >>> s  
    {'a', 3, 4, 'b', 2}  

#s.remove( x ) 
将 x 从集合s中移除，若x不存在，会引发错误

    >>> s  
    {'a', 3, 4, 'b', 2}  
    >>> s.remove('a')  
    >>> s  
    {3, 4, 'b', 2}  
    >>> s.remove('a')  
    Traceback (most recent call last):  
      File "<pyshell#273>", line 1, in <module>  
        s.remove('a')  
    KeyError: 'a'  

#s.pop() 
随机删除并返回集合s中某个值，注意，因为set是无序的，不支持下标操作，没有所谓的最后一个，pop()移除随机一个元素，这和其他数据结构不同

    >>> s  
    {3, 4, 'b', 2}  
    >>> s.pop()  
    3  

#s.clear() 
清空

#len(s) 
set支持len操作

    >>> s = {1,2,3}  
    >>> len(s)  
    3  
     
#in  
set同样支持in操作

    >>> s  
    {4, 'b', 2}  
    >>> 1 in s  
    False  
    >>> 2 in s  
    True  

#s.union( x ) 
返回s与集合x的交集，不改变原集合s，x 也可以是列表，元组，字典。
  
    >>> s1 = {1,2,3}  
    >>> s2 = {'a','b'}  
    >>> s1.union(s2)  
    {1, 2, 3, 'a', 'b'}  
    >>> s1  
    {1, 2, 3}  

#s.intersection( x ) 
返回s与集合x的并集，不改变s， x 也可以是列表，元组，字典。
  
    >>> s1  
    {1, 2, 3}  
    >>> s2  
    {2, 3, 4}  
    >>> s1.intersection(s2)  
    {2, 3}  
    >>> s1  
    {1, 2, 3}  

#s.difference( x ）
返回在集合s中而不在集合 x 中的元素的集合，不改变集合s， x 也可以是列表，元组，字典。
  
    >>> s1  
    {1, 2, 3}  
    >>> s2  
    {2, 3, 4}  
    >>> s1.difference(s2)  
    {1}  
    >>> s1  
    {1, 2, 3}  

#s.symmetric_difference( x ) 
返回s和集合x的对称差集，即只在其中一个集合中出现的元素，不改变集合s， x 也可以是列表，元组，字典。
  
    >>> s1  
    {1, 2, 3}  
    >>> s2  
    {2, 3, 4}  
    >>> s1.symmetric_difference(s2)  
    {1, 4}  
    >>> s1  
    {1, 2, 3}  

#s.issubset( x ) 
判断 集合s 是否是 集合x 子集
#s.issuperset( x ） 
判断 集合x 是否是集合s的子集
  
    >>> s1 = {1,2,3}  
    >>> s2 = {1,3}  
    >>> s2.issubset(s1)  
    True  
    >>> s1.issubset(s2)  
    False  
    >>> s1.issuperset(s2)  
    True  

#求交集，并集，差集，对称差集的另一种方法：
  
    >>> s1 = {1,2,3,'a'}  
    >>> s2 = {3,4,'b'}  
    >>> s1 & s2  #交集  
    {3}  
    >>> s1 | s2   #并集  
    {1, 'a', 3, 4, 'b', 2}  
    >>> s1 - s2  #差集  
    {1, 'a', 2}  
    >>> s1 ^ s2  #对称差集  
    {1, 2, 4, 'b', 'a'}  

{ } 在布尔运算中表示 False，其他均为 True
