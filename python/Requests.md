+ 一、安装 Requests
    
    通过pip安装

        pip install requests

    或者，下载代码后安装：

        $ git clone git://github.com/kennethreitz/requests.git
        $ cd requests
        $ python setup.py install
    再懒一点，通过IDE安装吧，如pycharm！

+ 二、发送请求与传递参数

    先来一个简单的例子吧！让你了解下其威力：


        import requests
         
        r = requests.get(url='http://www.itwhy.org')    # 最基本的GET请求
        print(r.status_code)    # 获取返回状态
        r = requests.get(url='http://dict.baidu.com/s', params={'wd':'python'})   #带参数的GET请求
        print(r.url)
        print(r.text)   #打印解码后的返回数据

很简单吧！不但GET方法简单，其他方法都是统一的接口样式哦！

    requests.get(‘https://github.com/timeline.json’) #GET请求
    requests.post(“http://httpbin.org/post”) #POST请求
    requests.put(“http://httpbin.org/put”) #PUT请求
    requests.delete(“http://httpbin.org/delete”) #DELETE请求
    requests.head(“http://httpbin.org/get”) #HEAD请求
    requests.options(“http://httpbin.org/get”) #OPTIONS请求

PS：以上的HTTP方法，对于WEB系统一般只支持 GET 和 POST，有一些还支持 HEAD 方法。

#带参数的请求实例：

    import requests
    requests.get('http://www.dict.baidu.com/s', params={'wd': 'python'})    #GET参数实例
    requests.post('http://www.itwhy.org/wp-comments-post.php', data={'comment': '测试POST'})    #POST参数实例
#POST发送JSON数据：

    import requests
    import json
     
    r = requests.post('https://api.github.com/some/endpoint', data=json.dumps({'some': 'data'}))
    print(r.json())
#定制header：


    import requests
    import json
     
    data = {'some': 'data'}
    headers = {'content-type': 'application/json',
               'User-Agent': 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:22.0) Gecko/20100101 Firefox/22.0'}
     
    r = requests.post('https://api.github.com/some/endpoint', data=data, headers=headers)
    print(r.text)

+ 三、Response对象

使用requests方法后，会返回一个response对象，其存储了服务器响应的内容，如上实例中已经提到的 r.text、r.status_code……

获取文本方式的响应体实例：当你访问 r.text 之时，会使用其响应的文本编码进行解码，并且你可以修改其编码让 r.text 使用自定义的编码进行解码。

        r = requests.get('http://www.itwhy.org')
        print(r.text, '\n{}\n'.format('*'*79), r.encoding)
        r.encoding = 'GBK'
        print(r.text, '\n{}\n'.format('*'*79), r.encoding)
其他响应：

    r.status_code #响应状态码
    r.raw #返回原始响应体，也就是 urllib 的 response 对象，使用 r.raw.read() 读取
    r.content #字节方式的响应体，会自动为你解码 gzip 和 deflate 压缩
    r.text #字符串方式的响应体，会自动根据响应头部的字符编码进行解码
    r.headers #以字典对象存储服务器响应头，但是这个字典比较特殊，字典键不区分大小写，若键不存在则返回None
特殊方法
    r.json() #Requests中内置的JSON解码器
    r.raise_for_status() #失败请求(非200响应)抛出异常

#案例之一：


    import requests
     
    URL = 'http://ip.taobao.com/service/getIpInfo.php'  # 淘宝IP地址库API
    try:
        r = requests.get(URL, params={'ip': '8.8.8.8'}, timeout=1)
        r.raise_for_status()    # 如果响应状态码不是 200，就主动抛出异常
    except requests.RequestException as e:
        print(e)
    else:
        result = r.json()
        print(type(result), result, sep='\n')
    
#四、上传文件
使用 Requests 模块，上传文件也是如此简单的，文件的类型会自动进行处理：

    
    import requests
     
    url = 'http://127.0.0.1:5000/upload'
    files = {'file': open('/home/lyb/sjzl.mpg', 'rb')}
    #files = {'file': ('report.jpg', open('/home/lyb/sjzl.mpg', 'rb'))}     #显式的设置文件名
     
    r = requests.post(url, files=files)
    print(r.text)
    
更加方便的是，你可以把字符串当着文件进行上传：

    import requests
     
    url = 'http://127.0.0.1:5000/upload'
    files = {'file': ('test.txt', b'Hello Requests.')}     #必需显式的设置文件名
     
    r = requests.post(url, files=files)
    print(r.text)

#五、身份验证
基本身份认证(HTTP Basic Auth):

    import requests
    from requests.auth import HTTPBasicAuth
     
    r = requests.get('https://httpbin.org/hidden-basic-auth/user/passwd', auth=HTTPBasicAuth('user', 'passwd'))
    # r = requests.get('https://httpbin.org/hidden-basic-auth/user/passwd', auth=('user', 'passwd'))    # 简写
    print(r.json())
另一种非常流行的HTTP身份认证形式是摘要式身份认证，Requests对它的支持也是开箱即可用的:

        requests.get(URL, auth=HTTPDigestAuth('user', 'pass'))
#六、Cookies与会话对象
如果某个响应中包含一些Cookie，你可以快速访问它们：

    import requests
     
    r = requests.get('http://www.google.com.hk/')
    print(r.cookies['NID'])
    print(tuple(r.cookies))
要想发送你的cookies到服务器，可以使用 cookies 参数：

import requests
 
    url = 'http://httpbin.org/cookies'
    cookies = {'testCookies_1': 'Hello_Python3', 'testCookies_2': 'Hello_Requests'}
    # 在Cookie Version 0中规定空格、方括号、圆括号、等于号、逗号、双引号、斜杠、问号、@，冒号，分号等特殊符号都不能作为Cookie的内容。
    r = requests.get(url, cookies=cookies)
    print(r.json())

会话对象让你能够跨请求保持某些参数，最方便的是在同一个Session实例发出的所有请求之间保持cookies，且这些都是自动处理的，甚是方便。

下面就来一个真正的实例，如下是快盘签到脚本：


    import requests
     
    headers = {'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
               'Accept-Encoding': 'gzip, deflate, compress',
               'Accept-Language': 'en-us;q=0.5,en;q=0.3',
               'Cache-Control': 'max-age=0',
               'Connection': 'keep-alive',
               'User-Agent': 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:22.0) Gecko/20100101 Firefox/22.0'}
     
    s = requests.Session()
    s.headers.update(headers)
    # s.auth = ('superuser', '123')
    s.get('https://www.kuaipan.cn/account_login.htm')
     
    _URL = 'http://www.kuaipan.cn/index.php'
    s.post(_URL, params={'ac':'account', 'op':'login'},
           data={'username':'****@foxmail.com', 'userpwd':'********', 'isajax':'yes'})
    r = s.get(_URL, params={'ac':'zone', 'op':'taskdetail'})
    print(r.json())
    s.get(_URL, params={'ac':'common', 'op':'usersign'})

#七、超时与异常
timeout 仅对连接过程有效，与响应体的下载无关。

    >>> requests.get('http://github.com', timeout=0.001)
    Traceback (most recent call last):
      File "<stdin>", line 1, in <module>
    requests.exceptions.Timeout: HTTPConnectionPool(host='github.com', port=80): Request timed out. (timeout=0.001)
    所有Requests显式抛出的异常都继承自 requests.exceptions.RequestException：ConnectionError、HTTPError、Timeout、TooManyRedirects。




    
    
    >>> r = requests.get('http://www.zhidaow.com')
    >>> r.encoding
    'utf-8'
    当你发送请求时，requests会根据HTTP头部来猜测网页编码，当你使用r.text时，requests就会使用这个编码。当然你还可以修改requests的编码形式。
    
    >>> r = requests.get('http://www.zhidaow.com')
    >>> r.encoding
    'utf-8'
    >>>r.encoding = 'ISO-8859-1'
    像上面的例子，对encoding修改后就直接会用修改后的编码去获取网页内容。
    
    3.5 json
    像urllib和urllib2，如果用到json，就要引入新模块，如json和simplejson，但在requests中已经有了内置的函数，r.json()。就拿查询IP的API来说：
    
    >>>r = requests.get('http://ip.taobao.com/service/getIpInfo.php?ip=122.88.60.28')
    >>>r.json()['data']['country']
    '中国'
    3.6 网页状态码
    我们可以用r.status_code来检查网页的状态码。
    
    >>>r = requests.get('http://www.mengtiankong.com')
    >>>r.status_code
    200
    >>>r = requests.get('http://www.mengtiankong.com/123123/')
    >>>r.status_code
    404
    >>>r = requests.get('http://www.baidu.com/link?url=QeTRFOS7TuUQRppa0wlTJJr6FfIYI1DJprJukx4Qy0XnsDO_s9baoO8u1wvjxgqN')
    >>>r.url
    u'http://www.zhidaow.com/
    >>>r.status_code
    200
    前两个例子很正常，能正常打开的返回200，不能正常打开的返回404。但第三个就有点奇怪了，那个是百度搜索结果中的302跳转地址，但状态码显示是200，接下来我用了一招让他原形毕露：
    
    >>>r.history
    (<Response [302]>,)
    这里能看出他是使用了302跳转。也许有人认为这样可以通过判断和正则来获取跳转的状态码了，其实还有个更简单的方法：
    
    >>>r = requests.get('http://www.baidu.com/link?url=QeTRFOS7TuUQRppa0wlTJJr6FfIYI1DJprJukx4Qy0XnsDO_s9baoO8u1wvjxgqN', allow_redirects = False)
    >>>r.status_code
    302
    只要加上一个参数allow_redirects，禁止了跳转，就直接出现跳转的状态码了，好用吧？我也利用这个在最后一掌做了个简单的获取网页状态码的小应用，原理就是这个。
    
    3.7 响应头内容
    可以通过r.headers来获取响应头内容。
    
    >>>r = requests.get('http://www.zhidaow.com')
    >>> r.headers
    {
        'content-encoding': 'gzip',
        'transfer-encoding': 'chunked',
        'content-type': 'text/html; charset=utf-8';
        ...
    }
    可以看到是以字典的形式返回了全部内容，我们也可以访问部分内容。
    
    >>> r.headers['Content-Type']
    'text/html; charset=utf-8'
    
    >>> r.headers.get('content-type')
    'text/html; charset=utf-8'
    3.8 设置超时时间
    我们可以通过timeout属性设置超时时间，一旦超过这个时间还没获得响应内容，就会提示错误。
    
    >>> requests.get('http://github.com', timeout=0.001)
    Traceback (most recent call last):
      File "<stdin>", line 1, in <module>
    requests.exceptions.Timeout: HTTPConnectionPool(host='github.com', port=80): Request timed out. (timeout=0.001)
3.9 代理访问
采集时为避免被封IP，经常会使用代理。requests也有相应的proxies属性。

    import requests
    
    proxies = {
      "http": "http://10.10.1.10:3128",
      "https": "http://10.10.1.10:1080",
    }
    
    requests.get("http://www.zhidaow.com", proxies=proxies)
如果代理需要账户和密码，则需这样：

    proxies = {
        "http": "http://user:pass@10.10.1.10:3128/",
    }
3.10 请求头内容
请求头内容可以用r.request.headers来获取。

    >>> r.request.headers
    {'Accept-Encoding': 'identity, deflate, compress, gzip',
    'Accept': '*/*', 'User-Agent': 'python-requests/1.2.3 CPython/2.7.3 Windows/XP'}
    3.11 自定义请求头部
    伪装请求头部是采集时经常用的，我们可以用这个方法来隐藏：
    
    r = requests.get('http://www.zhidaow.com')
    print r.request.headers['User-Agent']
    #python-requests/1.2.3 CPython/2.7.3 Windows/XP
    
    headers = {'User-Agent': 'alexkh'}
    r = requests.get('http://www.zhidaow.com', headers = headers)
    print r.request.headers['User-Agent']
    #alexkh
3.12 持久连接keep-alive
requests的keep-alive是基于urllib3，同一会话内的持久连接完全是自动的。同一会话内的所有请求都会自动使用恰当的连接。

也就是说，你无需任何设置，requests会自动实现keep-alive。

4. 简单应用
4.1 获取网页返回码


    def get_status(url):
        r = requests.get(url, allow_redirects = False)
        return r.status_code
    
    print get_status('http://www.zhidaow.com') 
    #200
    print get_status('http://www.zhidaow.com/hi404/')
    #404
    print get_status('http://mengtiankong.com')
    #301
    print get_status('http://www.baidu.com/link?url=QeTRFOS7TuUQRppa0wlTJJr6FfIYI1DJprJukx4Qy0XnsDO_s9baoO8u1wvjxgqN')
    #302
    print get_status('http://www.huiya56.com/com8.intre.asp?46981.html')
    #500
