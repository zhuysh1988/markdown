###python最易用的并发处理--multiprocessing.Pool进程池及ThreadPool线程池

###使用场景介绍
>众所周知，多进程和多线程大部分情况下都会加快处理效率，缩短处理时间，但是相应的会出现通信问题，数据共享及加锁问题等等，且上手难度不是很容易。

>那么如何很容易的利用多进程和多线程来处理任务呢？答案是python的标准库multiprocessing，可以在单进程下使用多进程和多线程来帮忙处理任务。multiprocessing，名字即是多进程的意思，本篇主要讲一下进程池和线程池的用法。

###多线程示例：从一批url中获取数据，常见于爬虫，接口分批获取等
    import requests
    from multiprocessing import Pool  # 进程池
    from multiprocessing.dummy import Pool as ThreadPool  # 线程池
    
    def get_data_from_url(url):
    ????return requests.get(url).text
    
    url_list = ['url1', 'url2', 'url3', ... ]
    
###传统方式：
    data_list = []
    for url in url_list:
    ????data_list.append(get_data_from_url(url))
    
###多线程方式：
    tpool = ThreadPool(20)  # 创建一个线程池，20个线程数
    data_list = tpool.map(get_data_from_url, url_list)  # 将任务交给线程池，所有url都完成后再继续执行，与python的map方法类似
###或
    for url in url_list:
    ????data_list.append(tpool.apply(get_data_from_url, url) )  # 将任务挨个发给线程池
    
####多进程示例：
    pool = Pool(4)
    data_list = pool.map(get_data_from_url, url_list)  # 与线程池的map方法工作原理一致
####或
    for url in url_list:
    ????data_list.append(tpool.apply(get_data_from_url, url) )  # 与线程池的apply方法工作原理一致
    pool.close()  # close后进程池不能在apply任务
    pool.join()

>pool.join()是用来等待进程池中的worker进程执行完毕，防止主进程在worker进程结束前结束。
但pool.join()必须使用在pool.close()或者pool.terminate()之后。
其中close()跟terminate()的区别在于close()会等待池中的worker进程执行结束再关闭pool,而terminate()则是直接关闭。

>ThreadPool()和Pool()，默认启动的进程/线程数都为CPU数，如果python获取不到CPU数则默认为1

>一般计算(CPU)密集型任务适合多进程，IO密集型任务适合多线程，视具体情况而定，如http请求等等待时间较长的情况就属于IO密集型，让开销更小的线程去等待。
另外千万别忽略了python的GIL全局锁！千万别忽略了python的GIL全局锁！千万别忽略了python的GIL全局锁！。
