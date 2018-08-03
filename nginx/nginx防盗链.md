##nginx防盗链的方法



一般，我们做好防盗链之后其他网站盗链的本站图片就会全部失效无法显示，但是您如果通过浏览器直接输入图片地址，仍然会显示图片，仍然可以右键图片另存为下载文件！



依然可以下载？这样就不是彻底的防盗了！那么，nginx应该怎么样彻底地实现真正意义上的防盗链呢？

首先，我们来看下nginx如何设置防盗链



如果您使用的是默认站点，也就是说，您的站点可以直接输入服务器IP访问的，使用root登录，修改 /usr/local/nginx/conf/nginx.conf 这个配置文件。



修改/usr/local/nginx/conf/vhost/你的域名.conf 这个配置文件，找到：



    location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$



    expires      30d;





把这一段删掉，修改成：



    location ~* \.(gif|jpg|png|jpeg)$ {

     expires     30d;

     valid_referers none blocke *.hugao8.com www.hugao8.com m.hugao8.com *.baidu.com *.google.com;

    if ($invalid_referer) {

    rewrite ^/ http://ww4.sinaimg.cn/bmiddle/051bbed1gw1egjc4xl7srj20cm08aaa6.jpg;

    #return 404;

        }

    }



第一行： location ~ .*\.(gif|jpg|jpeg|png|bmp|swf)$



其中“gif|jpg|jpeg|png|bmp|swf”设置防盗链文件类型，自行修改，每个后缀用“|”符号分开！



第三行：valid_referers none blocked *.it300.com it300.com;



就是白名单，允许文件链出的域名白名单，自行修改成您的域名！*.it300.com这个指的是子域名，域名与域名之间使用空格隔开！



第五行：rewrite ^/ http://www.it300.com/static/images/404.jpg;



这个图片是盗链返回的图片，也就是替换盗链网站所有盗链的图片。这个图片要放在没有设置防盗链的网站上，因为防盗链的作用，这个图片如果也放在防盗链网站上就会被当作防盗链显示不出来了，盗链者的网站所盗链图片会显示X符号。



这样设置差不多就可以起到防盗链作用了，上面说了，这样并不是彻底地实现真正意义上的防盗链！



我们来看第三行：valid_referers none blocked *.it300.com it300.com;



valid_referers 里多了“none blocked”



我们把“none blocked”删掉，改成



valid_referers  *.it300.com it300.com;



 



#nginx彻底地实现真正意义上的防盗链完整的代码应该是这样的：

    location ~* \.(gif|jpg|png|jpeg)$ {

    expires     30d;

    valid_referers *.hugao8.com www.hugao8.com m.hugao8.com *.baidu.com *.google.com;

    if ($invalid_referer) {

    rewrite ^/ http://ww4.sinaimg.cn/bmiddle/051bbed1gw1egjc4xl7srj20cm08aaa6.jpg;

    #return 404;

        }

    }



这样您在浏览器直接输入图片地址就不会再显示图片出来了，也不可能会再右键另存什么的。



第五行：rewrite ^/ http://www.it300.com/static/images/404.jpg;



这个是给图片防盗链设置的防盗链返回图片，如果我们是文件需要防盗链下载，把第五行：



rewrite ^/ http://www.it300.com/static/images/404.jpg;



改成一个链接，可以是您主站的链接，比如把第五行改成：



rewrite ^/ http://www.it300.com;



这样，当别人输入文件下载地址，由于防盗链下载的作用就会跳转到您设置的这个链接！



最后，配置文件设置完成别忘记重启nginx生效！







一：一般的防盗链如下：



    location ~* \.(gif|jpg|png|swf|flv)$ {

    valid_referers none blocked www.jzxue.com jzxue.com ;

     if ($invalid_referer) {

    rewrite ^/ http://www.jzxue.com/retrun.html;

    #return 403;

     }

    }



第一行：gif|jpg|png|swf|flv



表示对gif、jpg、png、swf、flv后缀的文件实行防盗链



第二行： 表示对www.ingnix.com这2个来路进行判断



if{}里面内容的意思是，如果来路不是指定来思是，如果来路不是指定来路就跳转到http://www.jzxue.com/retrun.html页面，当然直接返回403也是可以的。



二：针对图片目录防止盗链



    location /images/ {

    alias /data/images/;

    valid_referers none blocked server_names *.xok.la xok.la ;

    if ($invalid_referer) {return 403;}

    }



三：使用第三方模块ngx_http_accesskey_module实现Nginx防盗链





实现方法如下：

    

    1. 下载NginxHttpAccessKeyModule模块文件：http://wiki.nginx.org/File:Nginx-accesskey-2.0.3.tar.gz；

    2. 解压此文件后，找到nginx-accesskey-2.0.3下的config文件。编辑此文件：替换其中的”$HTTP_ACCESSKEY_MODULE”为”ngx_http_accesskey_module”；

    3. 用一下参数重新编译nginx：

    ./configure --add-module=path/to/nginx-accesskey





上面需要加上原有到编译参数，然后执行: make && make install





    4. 修改nginx的conf文件，添加以下几行：

    

    location /download {

    accesskey on;

    accesskey_hashmethod md5;

    accesskey_arg "key";

    accesskey_signature "mypass$remote_addr";

    }

其中：

accesskey为模块开关；

accesskey_hashmethod为加密方式MD5或者SHA-1；

accesskey_arg为url中的关键字参数；

accesskey_signature为加密值，此处为mypass和访问IP构成的字符串。



访问测试脚本download.PHP：



    <?

    $ipkey= md5("mypass".$_SERVER['REMOTE_ADDR']);

    $output_add_key="<a href=http://www.jzxue.com/download/G3200507120520LM.rar?key=".$ipkey.">download_add_key</a><br />";

    $output_org_url="<a href=http://www.jzxue.com/download/G3200507120520LM.rar>download_org_path</a><br />";

    echo $output_add_key;

    echo $output_org_url;

    ?>

访问第一个download_add_key链接可以正常下载，第二个链接download_org_path会返回403 Forbidden错误。
