## Locust安装

>Locust是一款类似于Jmeter开源负载测试工具，所不同的是它是用python实现，并支持python脚本。 locust提供web ui界面，能够方便用户实时监控脚本运行状态。
- #### install python-pip
- - #### 可以连接外网的情况
        yum install python-pip gcc python-devel -y
        pip install -U pyzmq
        pip install -U locustio
- - #### 使用下载好的文件安装
        tree /tmp/locust
        locust/
        ├── click-6.6.tar.gz
        ├── Flask-0.11.1-py2.py3-none-any.whl
        ├── gevent-1.1.1.tar.gz
        ├── greenlet-0.4.10.zip
        ├── itsdangerous-0.24.tar.gz
        ├── Jinja2-2.8-py2.py3-none-any.whl
        ├── locustio-0.7.5.tar.gz
        ├── MarkupSafe-0.23.tar.gz
        ├── msgpack-python-0.4.8.tar.gz
        ├── requests-2.11.0-py2.py3-none-any.whl
        └── Werkzeug-0.11.10-py2.py3-none-any.whl
        # Install_command
        pip install --no-index --find-links=file:///tmp/locust locustio
- - #### 提供一个pip安装模块时，下载所有的包至一个目录
        pip install --download /tmp locustio


## reset open file
    ulimit -a | grep open
    open files                      (-n) 1024
    ulimit -n 102400
## python_scripts locaust_test.py

    from locust import HttpLocust, TaskSet, task

    testhost='http://192.168.1.119'
    # 修改为你的url
    url='/index.html'

    class WebsiteTasks(TaskSet):
    #    def on_start(self):
    #        self.client.post("/login", {
    #            "username": "test_user",
    #            "password": ""
    #        })

        @task(10)
        def index(self):
            self.client.get(url)


    class WebsiteUser(HttpLocust):
        task_set = WebsiteTasks
        min_wait = 1000
        max_wait = 1000
        host = testhost

## run
    locust -f locaust_test.py
    # 使用浏览器打开 http://localhost:8089 
