## locust 高级使用

>学会了Locust工具的基本使用方法后，可以更深入的了解下它所有的类及对应的方法和属性。

### Locust类

>每一个模拟的用户可以看做一个Locust类的实例，Locust类有如下属性：

    task_set = None：指向一个TaskSet类，TaskSet类定义了每个用户的行为。
    min_wait = 1000：用户执行任务之间等待时间的下界，单位：毫秒。如果TaskSet类中有覆盖，以TaskSet中的定义为准。
    max_wait = 1000：用户执行任务之间等待时间的上界，单位：毫秒。如果TaskSet类中有覆盖，以TaskSet中的定义为准。
    host = None：如果是Web服务的测试，host相当于是提供URL前缀的默认值，但是如果在命令行中指定了-H选项，则以命令行中指定的为准。如果不是Web服务测试，使用默认的None就好。
    weight = 10：一个Locust实例被挑选执行的权重，数值越大，执行频率越高。在一个locustfile.py文件中可以同时定义多个Locust子类，然后分配他们的执行权重
#### 例如：
    from locust import Locust, TaskSet, task 
    class UserTask(TaskSet): 
        @task 
        def job(self): 
            pass 
    class UserOne(Locust): 
        weight = 1 
        task_set = UserTask 
    class UserTwo(Locust): 
        weight = 2 
        task_set = UserTask

#### Run 
    locust -f locustfile3.py UserOne UserTwo

> 那么UserTwo的执行频率在统计上会是UserOne的两倍。

### TaskSet类

>正如字面意思，TaskSet类定义了每个用户的任务集合，测试任务开始后，每个Locust用户会从TaskSet中随机挑选（如果定义了任务间的权重关系，那么就是按照权重关系随机挑选）一个任务执行，然后随机等待Locust类中定义的min_wait和max_wait（如果TaskSet类中也定义了min_wait或者max_wait，按照TaskSet中的为准）之间的一段时间，执行下一个任务。
定义TaskSet中的任务有多种方式，比如使用@task修饰符、使用tasks属性。
使用@task修饰符的方法在前一篇文章中有介绍，另外也可以在后面指定一个数值作为权重
#### 例如：
    from locust import Locust, TaskSet, task

    class UserTask(TaskSet):
        @task(1)
        def job1(self):
            print 'This is job 1'

        @task(2)
        def job2(self):
            print 'This is job 2'

    class User(Locust):
        task_set = UserTask

>上面的代码中，job2任务的执行频率统计上来看会是job1的二倍。
使用tasks属性的方法在前一篇文章中也有介绍，需要注意的是TaskSet的定义是可以嵌套的，因为考虑到现实中有很多任务其实也是有嵌套结构的，比如：

    from locust import Locust, TaskSet, task

    class UserTask(TaskSet):
        @task(2)
        class stay(TaskSet):
            @task(3)
            def readBook(self):
                print 'I am reading a book.'

            @task(7)
            def listenMusic(self):
                print 'I am listening to music.'

            @task(1)
            def logOut(self):
                self.interrupt()

        @task(1)
        def leave(self):
            print 'I don not like this page.'

    class User(Locust):
        task_set = UserTask

>上面的例子中，要么用户不喜欢这个网页直接离开，要么喜欢就留下来，留下来的话，可以选择看书、听音乐、或者离开。在stay这个类中，对interrupt()方法的调用是非常重要的，这可以让一个用户跳出stay这个类有机会执行leave这个任务，否则他一旦进入stay任务就会一直在看书或者听音乐而难以自拔。
除了使用@task修饰符完成嵌套，也可以使用tasks属性，效果是一样的：

    from locust import Locust, TaskSet, task

    class stay(TaskSet):
        @task(3)
        def readBook(self):
            print 'I am reading a book.'

        @task(7)
        def listenMusic(self):
            print 'I am listening to music.'

        @task(1)
        def logOut(self):
            self.interrupt()

    class UserTask(TaskSet):
        tasks = {stay:2}

        @task(1)
        def leave(self):
            print 'I don not like this page.'

    class User(Locust):
        task_set = UserTask

####TaskSet类还有其他的有用方法：

    on_start()函数
    定义每个locust用户开始做的第一件事。
    locust属性
    指向每个TaskSet所属的loucst用户实例。
    parent属性
    指向每个TaskSet所属的父类TaskSet，用在TaskSet有嵌套的情况，如果调用parent的TaskSet是最顶层的，则返回它所属的locust用户实例。
    client属性
    指向TaskSet所属的父HttpLocust类的client属性，self.client与self.locust.client效果是一样的。如果TaskSet所属的父类是个Locust类，则没有这个client属性。
    interrupt(reschedule=True)
    顶层的TaskSet（即被绑定到某个Locust类的task_set的第一层TaskSet）不能调用这个方法。reschedule置为True时，从被嵌套任务出来马上选择新任务执行，如果置为False，从被嵌套任务出来后，随机等待min_wait和max_wait之间的一段时间，再选择新任务执行。

    schedule_task(task_callable, args=None, kwargs=None, first=False)
    将一个可调用的对象task_callable添加进Locust对象（注意是针对某个Locust实例，而不是所有的Locust实例）的任务选择队列，其中args和kwargs是传递给可调用对象的参数，如果first置为True，则将其加到队首。

    HttpLocust类

    Locust原本是为了对Web服务进行性能测试而生，HttpLocust类继承自Locust类，可以方便发送HTTP请求。采用HttpLocust类时会在网页的统计UI上显示实时统计信息，如果是Locust类则不会显示。HttpLocust类比Locust类多了client特性，client特性中包含locust.clients.HttpSession类的实例，支持cookie，能在请求之间保持session。
    HttpSession其实是requests.Session的子类，支持HTTP的各种请求，如get、post、put、delete、head、patch、options，同时发送统计信息给Web界面。
    
### 下面举个get请求的例子：

    from locust import HttpLocust, TaskSet, task

    class UserTask(TaskSet):
        @task
        def job(self):
            response = self.client.get('/')
            print 'Status code: %s' % response.status_code
            print 'Content : %s' % response.content

    class User(HttpLocust):
        task_set = UserTask
        min_wait = 1000
        max_wait = 1000

###  ResponseContextManager类

>其实ResponseContextManger类是Response类的子类，只是多了两个failure()和success()方法，使用方法如下：

    from locust import HttpLocust, TaskSet, task

    class UserTask(TaskSet):
        @task
        def job(self):
            with self.client.get('/', catch_response = True) as response:
                if response.status_code == 200:
                    response.failure('Failed!')
                else:
                    response.success()

    class User(HttpLocust):
        task_set = UserTask
        min_wait = 1000
        max_wait = 1000


>上面的例子比较无聊（只是为了说明使用with语句及catch_response参数可以截获原始响应），把所有status_code是200的响应都当做失败响应。注意，这里success()和failure(str)的调用会体现在结果的统计上，例如：


>另外，failure方法的参数除了可以是字符串以外，还可以是Python的exception类。

>有的时候某个请求的url会接受变化的参数，比如/blog?id=id，其中斜体的id如果有一千个，那么在统计网页上会显示一千行，看这样的统计信息也没有意义（当然，有时候可能是有用的），我们可以在get请求中加个name参数来将这些统计叠加到一起

### 比如：

    from locust import HttpLocust, TaskSet, task

    class UserTask(TaskSet):
        @task
        def job(self):
            self.client.get('/', name = 'Test')
            self.client.get('/s?ie=utf-8&f=8&rsv_bp=0&rsv_idx=1&tn=baidu&wd=a&rsv_pq=ea402fde00059549&rsv_t=e66eMrX2jdLCr1nxf9CP4BE0P7GnDSeU4MqgeDc3Yl5ooSsZ32efVWA1AUY&rsv_enter=1&rsv_sug3=1&rsv_sug1=1&rsv_sug2=0&inputT=285&rsv_sug4=286', name = 'Test')

    class User(HttpLocust):
        task_set = UserTask
        min_wait = 1000
        max_wait = 1000



### HttpSession类

HttpSession类与python的requests.Session类十分相似，不同的地方在于：

        Locust会自动跟踪HTTP请求的状态并统计，如果不想使用默认的安全形式，可以配合with语句及catch_response参数捕捉原始响应。
        可以使用name参数对不同URL的请求进行分类。
        第一个参数不再是完整的URL，比如请求http://www.baidu.com/，只需要提供参数/即可，http://www.baidu.com是通过Locust类的host特性提供的，或者通过locust命令行的-H参数提供。

下面举一个使用HttpSession类的例子：

from locust import Locust, TaskSet
from locust.clients import HttpSession

def test(l):
    s = HttpSession('http://www.baidu.com')
    with s.get('/', catch_response = True, name = "mars_test") as r:
        print r.status_code

class UserTask(TaskSet):
    tasks = [test]

class User(Locust):
    task_set = UserTask
    min_wait = 3000
    max_wait = 5000

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
    12
    13
    14
    15

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
    12
    13
    14
    15

运行后的Web界面如下显示：
这里写图片描述

使用HttpSession类能够完成python的requests模块的delete、get、post、put、options、head、patch、request等请求，同时还有向Locust的Web界面发送统计信息及分组统计等特性。

    Response类

Locust内部其实使用了python的requests模块发送HTTP请求，所以HTTP响应类的特性及方法也十分类似，具体也可以参考requests模块。

    InterruptTaskSet类

TaskSet类的interrupt方法就是通过抛出一个InterruptTaskSet实例实现的。

    EventHook类

EventHook类在locust.events模块中，可以用于发生某些事情时的钩子函数，比如：

from locust import Locust, TaskSet, events, task

mars_event = events.EventHook()

def mars_special_event(verb = '', content = ''):
    print 'mars %s %s' % (verb, content)

mars_event += mars_special_event

class UserTask(TaskSet):
    @task(1)
    def job1(self):
        mars_event.fire(verb = 'love', content = 'locust')

    @task(3)
    def job2(self):
        print "In job2 ..."

class User(Locust):
    task_set = UserTask
    min_wait = 3000
    max_wait = 5000

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
    12
    13
    14
    15
    16
    17
    18
    19
    20
    21
    22

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
    12
    13
    14
    15
    16
    17
    18
    19
    20
    21
    22

除了我举得上面这个没有什么意义的例子之外，Locust还提供了如下7种有用的钩子：

    request_success：当请求完全成功时被触发，钩子函数需要定义如下参数：

        request_type：请求的类型
        name：请求的URL或者自定义的统计分组名字(如果请求时提供了name参数的话)
        response_time：请求花费的时间（毫秒为单位）
        response_length：响应长度

    request_failure：当请求失败时触发，钩子函数需要定义如下参数：

        request_type：请求的类型
        name：请求的URL或者自定义的统计分组名字(如果请求时提供了name参数的话)
        response_time：请求花费的时间（毫秒为单位）
        exception：请求失败抛出的异常

    locust_error：在Locust实例执行发生异常时触发，钩子函数需要定义如下参数：

        locust_instance：发生异常的Locust类的实例
        exception：抛出的异常
        tb：来自sys.exc_info()[2]的Traceback对象

    hatch_complete：所有的Locust实例产生完成时触发，钩子函数需要定义如下参数：

        user_count：产生的Locust实例（虚拟用户）的数量。

    quitting：Locust进程退出时被触发，钩子函数不需要提供参数。

现根据目前这5个钩子举一个例子：

from locust import HttpLocust, TaskSet, events, task
import random, traceback

def on_request_success(request_type, name, response_time, response_length):
    print 'Type: %s, Name: %s, Time: %fms, Response Length: %d' % \
            (request_type, name, response_time, response_length)

def on_request_failure(request_type, name, response_time, exception):
    print 'Type: %s, Name: %s, Time: %fms, Reason: %r' % \
            (request_type, name, response_time, exception)

def on_locust_error(locust_instance, exception, tb):
    print "%r, %s, %s" % (locust_instance, exception, "".join(traceback.format_tb(tb)))

def on_hatch_complete(user_count):
    print "Haha, Locust have generate %d users" % user_count

def on_quitting():
    print "Locust is quiting"

events.request_success += on_request_success
events.request_failure += on_request_failure
events.locust_error += on_locust_error
events.hatch_complete += on_hatch_complete
events.quitting += on_quitting


class UserTask(TaskSet):
    @task(5)
    def job1(self):
        with self.client.get('/', catch_response = True) as r:
            if random.choice([0, 1]):
                r.success()
            else:
                r.failure('0')

    @task(1)
    def job2(self):
        raise Exception("Mars Loo's test")

class User(HttpLocust):
    task_set = UserTask
    min_wait = 3000
    max_wait = 5000
    host = 'http://www.baidu.com'

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
    12
    13
    14
    15
    16
    17
    18
    19
    20
    21
    22
    23
    24
    25
    26
    27
    28
    29
    30
    31
    32
    33
    34
    35
    36
    37
    38
    39
    40
    41
    42
    43
    44
    45

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
    12
    13
    14
    15
    16
    17
    18
    19
    20
    21
    22
    23
    24
    25
    26
    27
    28
    29
    30
    31
    32
    33
    34
    35
    36
    37
    38
    39
    40
    41
    42
    43
    44
    45

其他两种钩子涉及到分布式使用Locust，请参考下一篇博客。



当一台机器已经达到Locust工具能够模拟的用户数量上限时，我们不得不在另外几台机器上部署Locust，然后拷贝一份一模一样的脚本，进行分布式Locust的使用。一般在使用的时候，有一台机器作为主机（master），其余机器作为备机（slave）。我在工作中一般将virtualenv和locustfile.py放在Git上，每次测试前以master机器的代码为基准，先push到远端，再在其他所有slave机器上pull一遍保证一致性。下面分别介绍。
在主机A（IP地址为192.168.1.2）上运行命令：

mars@mars-Ideapad-V460:~/test$ locust --master
[2015-09-14 22:14:48,792] mars-Ideapad-V460/INFO/locust.main: Starting web monitor at *:8089
[2015-09-14 22:14:48,867] mars-Ideapad-V460/INFO/locust.main: Starting Locust 0.7.3

    1
    2
    3

    1
    2
    3

上面的命令会在主机上开启Locust的侦听服务，主机不会模拟任何Locust用户，也不会做任何测试活动，这些都是备机干的事，主机只负责侦听备机发来的统计数据和生成WEB的观察界面。也可以指定master机器监听的端口（如果指定的端口是n，则会同时监听端口n+1，--master-bind-port的默认值是5557）：

mars@mars-Ideapad-V460:~/test$ locust --master --master-bind-port=4445
[2015-09-14 22:19:00,972] mars-Ideapad-V460/INFO/locust.main: Starting web monitor at *:8089
[2015-09-14 22:19:00,974] mars-Ideapad-V460/INFO/locust.main: Starting Locust 0.7.3

    1
    2
    3

    1
    2
    3

也可以通过--master-bind-host指定Locust主机服务绑定到哪个网卡，如果主机有多个网络，可以做如下指定(--master-bind-host的默认值是*)：

mars@mars-Ideapad-V460:~/test$ locust --master --master-bind-host=192.168.1.2
[2015-09-14 22:22:31,331] mars-Ideapad-V460/INFO/locust.main: Starting web monitor at *:8089
[2015-09-14 22:22:31,335] mars-Ideapad-V460/INFO/locust.main: Starting Locust 0.7.3

    1
    2
    3

    1
    2
    3

在备机B上运行如下命令：

mars@mars-Ideapad-V460:~/test$ locust --slave --master-host=192.168.1.2
[2015-09-14 22:24:12,980] mars-Ideapad-V460/INFO/locust.main: Starting Locust 0.7.3

    1
    2

    1
    2

此时在主机上会看到如下信息：

    [2015-09-14 22:24:12,981] mars-Ideapad-V460/INFO/locust.runners: Client ‘mars-Ideapad-V460_e3ee672bdd31a05544223eb1cc66edb2’ reported as ready. Currently 1 clients ready to swarm.

--master-host的默认值是127.0.0.1，如果主机A使用的不是默认监听端口，也可以使用如下命令指定目的主机端口（如果指定的端口是n，则会同时监听端口n+1,--master-port的默认值是5557）：

mars@mars-Ideapad-V460:~/test$ locust --slave --master-host=192.168.1.2 --master-port=4445
[2015-09-14 22:28:17,837] mars-Ideapad-V460/INFO/locust.main: Starting Locust 0.7.3

    1
    2

    1
    2

Locust其实也可以在一个机器的多个进程中运行，一个进程作为主进程，其余进程作为备进程，比如在终端运行如下命令：

mars@mars-Ideapad-V460:~/test$ locust --master
[2015-09-14 22:41:53,213] mars-Ideapad-V460/INFO/locust.main: Starting web monitor at *:8089
[2015-09-14 22:41:53,214] mars-Ideapad-V460/INFO/locust.main: Starting Locust 0.7.3

    1
    2
    3

    1
    2
    3

然后重新打开一个终端窗口，运行：

mars@mars-Ideapad-V460:~/test$ locust --slave
[2015-09-14 22:42:01,902] mars-Ideapad-V460/INFO/locust.main: Starting Locust 0.7.3

    1
    2

    1
    2

如果要终止分布式Locust的运行，直接在master机器上Ctrl + C关闭即可，slave机器会接收到停止信号自动停止运行。

在前一篇博客中提到Locust的两个钩子，分别和master接受数据及slave发送数据有关：

    report_to_master：slave向master发送数据时触发，钩子函数定义需要提供如下参数：

    client_id：slave的client id
    data：slave向master发送的数据，是一个dict类型的参数。注意stats、errors是Locust使用的key，自定义时不要使用这两个key。


    slave_report：master接收到slave发送来的数据时触发，钩子函数定义需要提供如下参数：

    client_id：slave的client id
    data：slave向master发送的数据，是一个dict类型的参数。
    下面举一个使用这两个钩子函数的例子：

from locust import HttpLocust, TaskSet, events, task

def on_report_to_master(client_id, data):
    data['mars'] = 'loo'
    print "Slave: Client %s, data " % client_id, data

def on_slave_report(client_id, data):
    print "Master Recive: Client %s, data " % client_id, data

events.report_to_master += on_report_to_master
events.slave_report += on_slave_report

class UserTask(TaskSet):
    @task(1)
    def job(self):
        pass

class User(HttpLocust):
    task_set = UserTask
    min_wait = 3000
    max_wait = 5000
    host = 'http://www.baidu.com'

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
    12
    13
    14
    15
    16
    17
    18
    19
    20
    21
    22

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
    12
    13
    14
    15
    16
    17
    18
    19
    20
    21
    22

运行之后，master机器的输出如下：

(env) Mars:tmp Mars$ locust --master
[2016-06-25 18:27:37,736] localhost/INFO/locust.main: Starting web monitor at *:8089
[2016-06-25 18:27:37,737] localhost/INFO/locust.main: Starting Locust 0.7.5
[2016-06-25 18:27:37,881] localhost/INFO/locust.runners: Client 'localhost_3320bbf029a4740346dbf04271927bb1' reported as ready. Currently 1 clients ready to swarm.
[2016-06-25 18:27:37,881] localhost/INFO/stdout: Master Recive: Client localhost_3320bbf029a4740346dbf04271927bb1, data
[2016-06-25 18:27:37,881] localhost/INFO/stdout: 
[2016-06-25 18:27:37,881] localhost/INFO/stdout: {'errors': {}, 'stats': [], 'user_count': 0, 'mars': 'loo'}

    1
    2
    3
    4
    5
    6
    7

    1
    2
    3
    4
    5
    6
    7

slave机器的输出如下：

(env) Mars:tmp Mars$ locust --slave
[2016-06-25 18:27:34,092] localhost/INFO/locust.main: Starting Locust 0.7.5
[2016-06-25 18:27:34,092] localhost/INFO/stdout: Slave: Client localhost_3320bbf029a4740346dbf04271927bb1, data
[2016-06-25 18:27:34,092] localhost/INFO/stdout: 
[2016-06-25 18:27:34,092] localhost/INFO/stdout: {'errors': {}, 'stats': [], 'mars': 'loo'}

    1
    2
    3
    4
    5

    1
    2
    3
    4
    5

最后，Locust工具支持MIT License，基于FLask框架开发，如果想在它的基础上对功能进行修改可以先学习下它的源码再进行修改。

比如如果想要增加新的Web界面，可以参考如下代码：

from locust import web, Locust, TaskSet, task

@web.app.route("/mars")
def my_added_page():
        return "Another page"

class UserTask(TaskSet):
    @task
    def job(self):
        pass

class User(Locust):
    task_set = UserTask
    min_wait = 1000
    max_wait = 2000

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
    12
    13
    14
    15

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10
    11
    12
    13
    14
    15

打开浏览器访问可以看到如下页面：

这里写图片描述

    如果觉得我的文章对您有帮助，欢迎关注我(CSDN:Mars Loo的博客)或者为这篇文章点赞，谢谢！
