#python time datetime模块常用

    #_*_coding:utf-8_*_
    __author__ = 'Alex Li'

    import time

    # time.strftime("%Y-%m-%d %H:%I:%S", time.localtime( time.time() ) ) 
    # print(time.clock()) #返回处理器时间,3.3开始已废弃 , 改成了time.process_time()测量处理器运算时间,不包括sleep时间,不稳定,mac上测不出来
    # print(time.altzone)  #返回与utc时间的时间差,以秒计算\
    # print(time.asctime()) #返回时间格式"Fri Aug 19 11:14:16 2016",
    # print(time.localtime()) #返回本地时间 的struct time对象格式
    # print(time.gmtime(time.time()-800000)) #返回utc时间的struc时间对象格式

    # print(time.asctime(time.localtime())) #返回时间格式"Fri Aug 19 11:14:16 2016",
    #print(time.ctime()) #返回Fri Aug 19 12:38:29 2016 格式, 同上



    # 日期字符串 转成  时间戳
    # string_2_struct = time.strptime("2016/05/22","%Y/%m/%d") #将 日期字符串 转成 struct时间对象格式
    # print(string_2_struct)
    # #
    # struct_2_stamp = time.mktime(string_2_struct) #将struct时间对象转成时间戳
    # print(struct_2_stamp)



    #将时间戳转为字符串格式
    # print(time.gmtime(time.time()-86640)) #将utc时间戳转换成struct_time格式
    # print(time.strftime("%Y-%m-%d %H:%M:%S",time.gmtime()) ) #将utc struct_time格式转成指定的字符串格式





    #时间加减
    import datetime

    # print(datetime.datetime.now()) #返回 2016-08-19 12:47:03.941925
    #print(datetime.date.fromtimestamp(time.time()) )  # 时间戳直接转成日期格式 2016-08-19
    # print(datetime.datetime.now() )
    # print(datetime.datetime.now() + datetime.timedelta(3)) #当前时间+3天
    # print(datetime.datetime.now() + datetime.timedelta(-3)) #当前时间-3天
    # print(datetime.datetime.now() + datetime.timedelta(hours=3)) #当前时间+3小时
    # print(datetime.datetime.now() + datetime.timedelta(minutes=30)) #当前时间+30分


    #
    # c_time  = datetime.datetime.now()
    # print(c_time.replace(minute=3,hour=2)) #时间替换

#    Directive        Meaning        Notes
    %a        Locale’s abbreviated weekday name.
    %A        Locale’s full weekday name.
    %b        Locale’s abbreviated month name.
    %B        Locale’s full month name.
    %c        Locale’s appropriate date and time representation.
    %d        Day of the month as a decimal number [01,31].
    %H        Hour (24-hour clock) as a decimal number [00,23].
    %I        Hour (12-hour clock) as a decimal number [01,12].
    %j        Day of the year as a decimal number [001,366].
    %m        Month as a decimal number [01,12].
    %M        Minute as a decimal number [00,59].
    %p        Locale’s equivalent of either AM or PM.        (1)
    %S        Second as a decimal number [00,61].        (2)
    %U        Week number of the year (Sunday as the first day of the week) as a decimal number [00,53]. All days in a new year preceding the first Sunday are considered to be in week 0.        (3)
    %w        Weekday as a decimal number [0(Sunday),6].
    %W        Week number of the year (Monday as the first day of the week) as a decimal number [00,53]. All days in a new year preceding the first Monday are considered to be in week 0.        (3)
    %x        Locale’s appropriate date representation.
    %X        Locale’s appropriate time representation.
    %y        Year without century as a decimal number [00,99].
    %Y        Year with century as a decimal number.
    %z        Time zone offset indicating a positive or negative time difference from UTC/GMT of the form +HHMM or -HHMM, where H represents decimal hour digits and M represents decimal minute digits [-23:59, +23:59].
    %Z        Time zone name (no characters if no time zone exists).
    %%        A literal '%' character.
