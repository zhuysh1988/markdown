# python list copy
#测试代码
    import copy
    a = [1,2,3,['a','b']]
    b = a
    c = a[:]
    d = copy.copy(a)
    e = copy.deepcopy(a)

    print "a         ",a
    print "=         ",b
    print "[:]         ",c
    print "copy      ",d
    print "deepcopy ",e
    print 
     
    a[0] = 9
    print "a         ",a
    print "=         ",b
    print "[:]         ",c
    print "copy      ",d
    print "deepcopy ",e
    print 
    a[-1][0] = 'x'
     
    print "a         ",a
    print "=         ",b
    print "[:]         ",c
    print "copy      ",d
    print "deepcopy ",e
     
#输出：
    a          [1, 2, 3, ['a', 'b']]
    =          [1, 2, 3, ['a', 'b']]
    [:]          [1, 2, 3, ['a', 'b']]
    copy       [1, 2, 3, ['a', 'b']]
    deepcopy  [1, 2, 3, ['a', 'b']]
     
    a          [9, 2, 3, ['a', 'b']]
    =          [9, 2, 3, ['a', 'b']]
    [:]          [1, 2, 3, ['a', 'b']]
    copy       [1, 2, 3, ['a', 'b']]
    deepcopy  [1, 2, 3, ['a', 'b']]
     
    a          [9, 2, 3, ['x', 'b']]
    =          [9, 2, 3, ['x', 'b']]
    [:]          [1, 2, 3, ['x', 'b']]
    copy       [1, 2, 3, ['x', 'b']]
    deepcopy  [1, 2, 3, ['a', 'b']]
