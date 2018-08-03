如何让nginx显示文件夹目录
#1. 如何让nginx显示文件夹目录

vi /etc/nginx/conf.d/default.conf

添加如下内容：

    location / {
            root /data/www/file                    # //指定实际目录绝对路径；
            autoindex on;                          #  //开启目录浏览功能；
            autoindex_exact_size off;            #//关闭详细文件大小统计，让文件大小显示MB，GB单位，默认为b；
            autoindex_localtime on;              #//开启以服务器本地时区显示文件修改日期！
    }


html文件的抬头写的是Index of /dns/log/

还有一个问题是这里开启的是全局的目录浏览功能，那么如何实现具体目录浏览功能呢？

#2. 只打开网站部分目录浏览功能

只打开http://www.******.com/soft 目录浏览

vi  /usr/local/nginx/conf/nginx.conf   #编辑配置文件，在server {下面添加以下内容：

    location   /soft {

    autoindex on;

    autoindex_exact_size off;

    autoindex_localtime on;
                                 }
