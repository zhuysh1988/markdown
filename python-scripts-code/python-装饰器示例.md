#没有参数

    def w1(func):
        def inner():
            # 验证1
            # 验证2
            # 验证3
            return func(arg)
        return inner
                
    @w1
    def f1():
        print 'f1'

#一个参数

    def w1(func):
        def inner(arg):
            # 验证1
            # 验证2
            # 验证3
            return func(arg)
        return inner
     
    @w1
    def f1(arg):
        print 'f1'

#两个参数

    def w1(func):
        def inner(arg1,arg2):
            # 验证1
            # 验证2
            # 验证3
            return func(arg1,arg2)
        return inner
     
    @w1
    def f1(arg1,arg2):
        print 'f1'

#三个参数

    def w1(func):
        def inner(arg1,arg2,arg3):
            # 验证1
            # 验证2
            # 验证3
            return func(arg1,arg2,arg3)
        return inner
     
    @w1
    def f1(arg1,arg2,arg3):
        print 'f1'

#问题：可以装饰具有处理n个参数的函数的装饰器？

    def w1(func):
        def inner(*args,**kwargs):
            # 验证1
            # 验证2
            # 验证3
            return func(*args,**kwargs)
        return inner
     
    @w1
    def f1(arg1,arg2,arg3):
        print 'f1'

#问题：一个函数可以被多个装饰器装饰吗？

    def w1(func):
        def inner(*args,**kwargs):
            # 验证1
            # 验证2
            # 验证3
            return func(*args,**kwargs)
        return inner
     
    def w2(func):
        def inner(*args,**kwargs):
            # 验证1
            # 验证2
            # 验证3
            return func(*args,**kwargs)
        return inner
     
     
    @w1
    @w2
    def f1(arg1,arg2,arg3):
        print 'f1'

#问题：还有什么更吊的装饰器吗？

    #!/usr/bin/env python
    #coding:utf-8
      
    def Before(request,kargs):
        print 'before'
          
    def After(request,kargs):
        print 'after'
      
      
    def Filter(before_func,after_func):
        def outer(main_func):
            def wrapper(request,kargs):
                  
                before_result = before_func(request,kargs)
                if(before_result != None):
                    return before_result;
                  
                main_result = main_func(request,kargs)
                if(main_result != None):
                    return main_result;
                  
                after_result = after_func(request,kargs)
                if(after_result != None):
                    return after_result;
                  
            return wrapper
        return outer
          
    @Filter(Before, After)
    def Index(request,kargs):
        print 'index'
