Python中的heapq模块提供了一种堆队列heapq类型,这样实现堆排序等算法便相当方便,

这里我们就来详解Python中heapq模块的用法,需要的朋友可以参考下

heapq 模块提供了堆算法。heapq是一种子节点和父节点排序的树形数据结构。

这个模块提供heap[k] <= heap[2*k+1] and heap[k] <= heap[2*k+2]。

为了比较不存在的元素被人为是无限大的。heap最小的元素总是[0]。

打印 heapq 类型

    import math
    import random
    from cStringIO import StringIO

    def show_tree(tree, total_width=36, fill=' '):
       output = StringIO()
       last_row = -1
       for i, n in enumerate(tree):
         if i:
           row = int(math.floor(math.log(i+1, 2)))
         else:
           row = 0
         if row != last_row:
           output.write('\n')
         columns = 2**row
         col_width = int(math.floor((total_width * 1.0) / columns))
         output.write(str(n).center(col_width, fill))
         last_row = row
       print output.getvalue()
       print '-' * total_width
       print
       return

    data = random.sample(range(1,8), 7)
    print 'data: ', data
    show_tree(data)

打印结果

    data: [3, 2, 6, 5, 4, 7, 1]

         3
      2      6
    5    4  7     1
    -------------------------
#heapq.heappush(heap, item)

push一个元素到heap里, 修改上面的代码

    heap = []
    data = random.sample(range(1,8), 7)
    print 'data: ', data

    for i in data:
      print 'add %3d:' % i
      heapq.heappush(heap, i)
      show_tree(heap)

打印结果

    data: [6, 1, 5, 4, 3, 7, 2]
    add  6:
             6
     ------------------------------------
    add  1:
          1
       6
    ------------------------------------
    add  5:
          1
       6       5
    ------------------------------------
    add  4:
            1
        4       5
      6
    ------------------------------------
    add  3:
            1
        3       5
      6    4
    ------------------------------------
    add  7:
            1
        3        5
      6    4    7
    ------------------------------------
    add  2:
            1
        3        2
      6    4    7    5
    ------------------------------------
根据结果可以了解，子节点的元素大于父节点元素。而兄弟节点则不会排序。

#heapq.heapify(list)
将list类型转化为heap, 在线性时间内, 重新排列列表。

    print 'data: ', data
    heapq.heapify(data)
    print 'data: ', data

    show_tree(data)

打印结果

    data: [2, 7, 4, 3, 6, 5, 1]
    data: [1, 3, 2, 7, 6, 5, 4]

          1
       3         2
    7    6    5    4
    ------------------------------------
#heapq.heappop(heap)

删除并返回堆中最小的元素, 通过heapify() 和heappop()来排序。

    data = random.sample(range(1, 8), 7)
    print 'data: ', data
    heapq.heapify(data)
    show_tree(data)

    heap = []
    while data:
      i = heapq.heappop(data)
      print 'pop %3d:' % i
      show_tree(data)
      heap.append(i)
    print 'heap: ', heap

打印结果

    data: [4, 1, 3, 7, 5, 6, 2]

             1
        4         2
      7    5    6    3
    ------------------------------------

    pop  1:
             2
        4         3
      7    5    6
    ------------------------------------
    pop  2:
             3
        4         6
      7    5
    ------------------------------------
    pop  3:
             4
        5         6
      7
    ------------------------------------
    pop  4:
             5
        7         6
    ------------------------------------
    pop  5:
             6
        7
    ------------------------------------
    pop  6:
            7
    ------------------------------------
    pop  7:

    ------------------------------------
    heap: [1, 2, 3, 4, 5, 6, 7]

可以看到已排好序的heap。
#heapq.heapreplace(iterable, n)
删除现有元素并将其替换为一个新值。

    data = random.sample(range(1, 8), 7)
    print 'data: ', data
    heapq.heapify(data)
    show_tree(data)

    for n in [8, 9, 10]:
      smallest = heapq.heapreplace(data, n)
      print 'replace %2d with %2d:' % (smallest, n)
      show_tree(data)

打印结果

    data: [7, 5, 4, 2, 6, 3, 1]

             1
        2         3
      5    6    7    4
    ------------------------------------

    replace 1 with 8:

             2
        5         3
      8    6    7    4
    ------------------------------------

    replace 2 with 9:

             3
        5         4
      8    6    7    9
    ------------------------------------

    replace 3 with 10:

             4
        5         7
      8    6    10    9
    ------------------------------------

#heapq.nlargest(n, iterable) 和 heapq.nsmallest(n, iterable)
返回列表中的n个最大值和最小值

    data = range(1,6)
    l = heapq.nlargest(3, data)
    print l     # [5, 4, 3]

    s = heapq.nsmallest(3, data)
    print s     # [1, 2, 3]

#PS：一个计算题
构建元素个数为 K=5 的最小堆代码实例:

    #!/usr/bin/env python
    # -*- encoding: utf-8 -*-
    # Author: kentzhan
    #

    import heapq
    import random

    heap = []
    heapq.heapify(heap)
    for i in range(15):
     item = random.randint(10, 100)
     print "comeing ", item,
     if len(heap) >= 5:
      top_item = heap[0] # smallest in heap
      if top_item < item: # min heap
       top_item = heapq.heappop(heap)
       print "pop", top_item,
       heapq.heappush(heap, item)
       print "push", item,
     else:
      heapq.heappush(heap, item)
      print "push", item,
     pass
     print heap
    pass
    print heap

    print "sort"
    heap.sort()

    print heap


#例:

    import heapq
    # 接受 list tuple  中包含的int和str型dict
    # 也接受中文,不过不清楚是怎么对比的
    nums = [1,2,3,213,23123,213,21,33,434,53,342,344,-324]
    # nums = ['2017-12-22', '2014-12-22', '2016-03-22', '2015-04-22', '2017-04-25', '2017-05-22',]
    # nums = ['p9','s8','a0','9z','0z']
    # nums = ['我','人','有','的','这']
    # print(heapq.nlargest(2,nums))  # 返回 nums 中包含2个最大的元素的列表
    # print(heapq.nsmallest(3,nums))  # 返回 nums 中包含3个最小的元素的列表

    #结果
    # [23123, 434]
    # [-324, 1, 2]

    # ['2017-12-22', '2017-05-22']
    # ['2014-12-22', '2015-04-22', '2016-03-22']

    # ['s8', 'p9']
    # ['0z', '9z', 'a0']

    # ['这', '的']
    # ['人', '我', '有']

    info = [
        {'name':'a0','time':'2014-09-23','price':231.2},
        {'name':'0b','time':'2017-03-23','price':231.2},
        {'name':'z1','time':'2019-09-23','price':231.2},
        {'name':'2z','time':'2010-09-23','price':231.2},
        {'name':'2a','time':'2017-12-23','price':231.2}
    ]
    l_names = heapq.nsmallest(2,info,key=lambda di:di['name'])
    l_times = heapq.nsmallest(2,info,key=lambda di:di['time'])
    l_prices = heapq.nsmallest(2,info,key=lambda di:di['price'])
    b_names = heapq.nlargest(2, info, key=lambda di: di['name'])
    b_times = heapq.nlargest(2, info, key=lambda di: di['time'])
    b_prices = heapq.nlargest(2, info, key=lambda di: di['price'])

    # print(l_names, b_names,l_times, b_times,l_prices,b_prices,sep='\n')

    # [{'price': 231.2, 'name': '0b', 'time': '2017-03-23'}, {'price': 231.2, 'name': '2a', 'time': '2017-12-23'}]
    # [{'price': 231.2, 'name': 'z1', 'time': '2019-09-23'}, {'price': 231.2, 'name': 'a0', 'time': '2014-09-23'}]
    # [{'price': 231.2, 'name': '2z', 'time': '2010-09-23'}, {'price': 231.2, 'name': 'a0', 'time': '2014-09-23'}]
    # [{'price': 231.2, 'name': 'z1', 'time': '2019-09-23'}, {'price': 231.2, 'name': '2a', 'time': '2017-12-23'}]
    # [{'price': 231.2, 'name': 'a0', 'time': '2014-09-23'}, {'price': 231.2, 'name': '0b', 'time': '2017-03-23'}]
    # [{'price': 231.2, 'name': 'a0', 'time': '2014-09-23'}, {'price': 231.2, 'name': '0b', 'time': '2017-03-23'}]

    # 堆数据结构
    heapq.heapify(nums)

    for i in range(len(nums)):
        print(heapq.heappop(nums))  #取出最小的元素

    '''
    -324
    1
    2
    3
    21
    33
    53
    213
    213
    342
    344
    434
    23123
    '''
# 实现一个优先级队列

    import heapq
    
    class PriorityQueue:
        ""
        def __init__(self):
            ""
            self._queue = []
            self._index = 0
    
        def push(self,item,priority):
            print(item,-priority)
            print('+'*20)
            heapq.heappush(self._queue,(-priority,self._index,item))
            self._index +=1
            print(self._queue,self._index)
    
        def pop(self):
            print(self._queue)
            return heapq.heappop(self._queue)[-1]
    
    class Item:
        def __init__(self,name):
            self.name = name
    
        def __repr__(self):
            # print(r'Item({!r})'.format(self.name))
            return 'Item({!r})'.format(self.name)
    
    q = PriorityQueue()
    q.push(Item('foo'),1)
    q.push(Item('bar'),5)
    q.push(Item('spam'),4)
    q.push(Item('grok'),100)
    print('_'*20)
    print(q.pop())
    print(q.pop())
    print(q.pop())
    print(q.pop())
    
    # Item('foo') - 1
    # ++++++++++++++++++++
    # [(-1, 0, Item('foo'))]
    # 1
    # Item('bar') - 5
    # ++++++++++++++++++++
    # [(-5, 1, Item('bar')), (-1, 0, Item('foo'))]
    # 2
    # Item('spam') - 4
    # ++++++++++++++++++++
    # [(-5, 1, Item('bar')), (-1, 0, Item('foo')), (-4, 2, Item('spam'))]
    # 3
    # Item('grok') - 100
    # ++++++++++++++++++++
    # [(-100, 3, Item('grok')), (-5, 1, Item('bar')), (-4, 2, Item('spam')), (-1, 0, Item('foo'))]
    # 4
    # ____________________
    # [(-100, 3, Item('grok')), (-5, 1, Item('bar')), (-4, 2, Item('spam')), (-1, 0, Item('foo'))]
    # Item('grok')
    # [(-5, 1, Item('bar')), (-1, 0, Item('foo')), (-4, 2, Item('spam'))]
    # Item('bar')
    # [(-4, 2, Item('spam')), (-1, 0, Item('foo'))]
    # Item('spam')
    # [(-1, 0, Item('foo'))]
    # Item('foo')

FROM: <http://www.jb51.net/article/87552.htm>
