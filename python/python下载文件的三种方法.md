#python下载文件的三种方法

Python开发中时长遇到要下载文件的情况，最常用的方法就是通过Http利用urllib或者urllib2模块。

当然你也可以利用ftplib从ftp站点下载文件。此外Python还提供了另外一种方法requests。

下面来看看三种方法是如何来下载zip文件的：

#方法一：

        import urllib 
        import urllib2 
        import requests
        print "downloading with urllib" 
        url = 'http://www.pythontab.com/test/demo.zip'  
        print "downloading with urllib"
        urllib.urlretrieve(url, "demo.zip")
# 方法二：


        import urllib2
        print "downloading with urllib2"
        url = 'http://www.pythontab.com/test/demo.zip' 
        f = urllib2.urlopen(url) 
        data = f.read() 
        with open("demo2.zip", "wb") as code:     
            code.write(data)

#方法三：


        import requests 
        print "downloading with requests"
        url = 'http://www.pythontab.com/test/demo.zip' 
        r = requests.get(url) 
        with open("demo3.zip", "wb") as code:
             code.write(r.content)
+ 看起来使用urllib最为简单，一句语句即可。当然你可以把urllib2缩写成：

        f = urllib2.urlopen(url) 
        with open("demo2.zip", "wb") as code:
           code.write(f.read())
