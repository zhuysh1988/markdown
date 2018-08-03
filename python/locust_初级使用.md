## one jobs

>安装完Locust工具后，只需要编写一个简单Python文件即可对系统进行负载测试。下面举个例子：

    mkdir /tmp/locust/1
    cd /tmp/locust/1
    vim test1.py
#### add this
    from locust import Locust, TaskSet, task
    class UserBehavior(TaskSet):
        @task
        def job(self):
            pass
    class User(Locust):
        task_set = UserBehavior
        min_wait = 1000
        max_wait = 3000
#### run
    locust -f test1.py

## many jobs
    vim test2.py
#### add this code
    from locust import HttpLocust, TaskSet

    def job1(l):
        ''
        l.client.get('/centos/')

    def job2(l):                  
        ''
        l.client.get('/epel/')

    class UserBehavior(TaskSet):
        ''
        tasks = {job1:1, job2:2}

    class WebsiteUser(HttpLocust):
        ''
        task_set = UserBehavior
        min_wait = 3000
        max_wait = 6000
### run test2.py
    locust -H http://192.168.1.119 -f test3.py


>这一次TaskSet类的定义中不再使用@task修饰符，而是使用tasks属性，{job1:1, job2:2}表示每个用户执行job2的频率是job1的两倍，也可以使用如下语句：

    tasks = [(job1,1), (job2,2)]

    或者不指定每个任务的执行权重（也就是1:1）：

    tasks = [job1, job2]

>job1和job2是一个可调用的对象，有一个Locust类作为参数（本例是HttpLocust）。

>这个例子中还使用了HttpLocust（继承自Locust）用于Web测试，它比Locust类多了client属性，相当于是一个 HttpSession。


## Cluster Mode
>如果要在多台机器之间分布式运行Locust，需要指定一个master机器，然后在master机器上执行如下命令：

    $ locust -f locustfile.py -H http://www.sample.com --master

>将其他机器作为slave，然后在这些slave上运行如下命令：

    $ locust -f locustfile.py -H http://www.sample.com --slave --master-host=<master机器的IP>

>关于locust的更多命令行功能可以使用locust --help命令看一下。
