#python json pickle 模块持久化

    #!/usr/bin/env python
    # -*- coding:utf-8 -*-

    __author__ = "jihongrui@jsqix.com"

    # 使用pickle模块将数据对象保存到文件

    import pickle
    import json

    data1 = {'a': [1, 2.0, 3, '4 + 6j'],
             'b': ('string', u'Unicode string'),
             'c': None}

    selfref_list = [1, 2, 3]

    ###########################################################
    # pickle

    with open('data.txt','wb') as f:
        pickle.dump(data1,f) #写入
        pickle.dump(selfref_list,f) #写入

    with open('data.txt', 'rb') as f:
        print(pickle.load(f))   #读出
        print(pickle.load(f))   #读出

    ##########################################################
    # json

    #写入原始数据
    with open('json1.json','w') as f:
        json.dump(data1,f)

    #读出数据
    with open('json1.json', 'r') as f:
        j = json.load(f)

    #修改再写入
    j['b'].append('thello')

    with open('json1.json','w') as f:
        json.dump(j,f)
