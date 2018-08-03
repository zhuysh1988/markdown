## Apache httpd反向代理使用详细分析

本文目录：
1 正向代理
2 反向代理
　2.1 简单的反向代理配置
　2.2 负载均衡：后端成员
　2.3 故障转义failover
　2.4 提供负载状态显示页面
　2.5 proxy相关指令
　　2.5.1 ProxyPass指令
　　2.5.2 ProxyPassMatch指令
　　2.5.3 ProxySet指令
　　2.5.4 < Proxy >容器
　　2.5.5 ProxyStatus指令
　　2.5.6 ProxyVia指令
3 健康状况检查模块

代理方式有两种：正向代理和反向代理。

正向代理是为客户端转发请求，各客户端将请求交给正向代理服务器，正向代理服务器再负责转发给服务端，响应时服务端先响应给正向代理服务器，正向代理服务器再转发给对应的客户端。也就是说，正向代理是为局域网内客户端做代理，它扮演的角色类似于NAT。

反向代理是为服务端转发请求，客户端将请求发送至反向代理服务器，反向代理服务器再将请求转发给真正的服务器以处理请求，响应时后端真正的服务器将处理结果发送给反向代理，再由反向代理构建响应并响应给客户端。

 

1 正向代理
httpd通过ProxyRequests指令配置正向代理的功能。例如：

ProxyRequests On
ProxyVia On

<Proxy "*">
  Require host internal.example.com
</Proxy>
其中< Proxy >容器表示的是只有internal.example.com下的主机可以通过该正向代理去访问任意URL的请求内容。ProxyVia指令表示在响应首部中添加一个Via字段。

 

2 反向代理
为了成为一个"基本的"web server，提供静态和动态内容给最终用户，httpd(以及其他大多数web server)可以扮演反向代理服务器的角色，也就是众所周知的"网关"服务器。

在这种场景下，Httpd自身不生成产出数据，而是从后端服务器中获取数据，这些后端服务器器一般不会和外界网络通信。当httpd从客户端接收到请求，请求被代理到后端服务器组中的其中一个服务器上，该后端服务器处理请求，生成内容并返回内容给httpd server，最后由httpd server生成实际的HTTP响应给客户端。

有无数应该使用反向代理的理由，最常见的是安全、高可用、负载均衡、集中授权/认证。反向代理的布置和架构中，后端服务器(真正处理请求的服务器)和外界完全绝缘并由此受到保护，对于外界客户端来说，当他们需要关心服务器对象是谁时，它们得到的结果总是反向代理服务器，而非后端服务器。

一个典型的实现如下：

Apache httpd反向代理使用详细分析

 

2.1 简单的反向代理配置
ProxyPass指令用于映射请求到后端服务器。最简单的代理示例是对所有请求"/"都映射到一个后端服务器上：

ProxyPass "/"  "http://www.example.com/"
ProxyPassMatch "^/((?i).*\.php)$" "fcgi://127.0.0.1:9000/var/www/a.com/$1"
为了地址重定向时也能正确使用反向代理，应该使用ProxyPassReverse指令。

ProxyPass "/"  "http://www.example.com/"
ProxyPassReverse "/"  "http://www.example.com/"
或者只为特定的URI进行代理，例如下面的配置，只有/images开头的路径才会代理转发，其他的所有请求都在本地处理。

ProxyPass "/images"  "http://www.example.com/"
ProxyPassReverse "/images"  "http://www.example.com/"
假如本地服务器地址为http://www1.example.com，当请求http://www1.example.com/images/a.gif时，将代理为http://www.example.com/a.gif。

 

2.2 负载均衡：后端成员
上面的配置中没有添加后端服务器节点，无法享受反向代理的优点。因此，有必要添加后端节点。添加的方法是使用< proxy >容器将后端节点定义成一个负载均衡组，各节点是该组中成员，然后代理目标指向组名即可。

例如：

<Proxy balancer://myset>
    BalancerMember http://www2.example.com:8080
    BalancerMember http://www3.example.com:8080
    ProxySet lbmethod=bytraffic
</Proxy>

ProxyPass "/images/"  "balancer://myset/"
ProxyPassReverse "/images/"  "balancer://myset/"
balancer://myset告诉httpd，它创建了一个负载均衡节点集合，名称为myset，此集合中有两个后端成员。在上面的配置中，任意/images的请求都会代理至2个成员中的一个。ProxySet指令指定myset均衡组使用的均衡算法为bytraffic，即基于I/O流量字节数权重的算法。ProxySet指令设置的是Proxy容器的公共属性。

httpd有3种复杂均衡算法：

byrequests：默认。基于请求数量计算权重。
bytraffic：基于I/O流量大小计算权重。
bybusyness：基于挂起的请求(排队暂未处理)数量计算权重。
对于上面的示例，还可以稍加修改，使其支持更多功能。例如添加权重比例，使得某后端节点被转发到的权重是另一节点的3倍，等待后端节点返回数据的超时时间为1秒。

<Proxy balancer://myset>
    BalancerMember http://www2.example.com:8080
    BalancerMember http://www3.example.com:8080 loadfactor=3 timeout=1
    ProxySet lbmethod=byrequests
</Proxy>

ProxyPass "/images"  "balancer://myset/"
ProxyPassReverse "/images"  "balancer://myset/"
 

2.3 故障转移
还可以再次调整实现故障转移，例如当所有负载节点都失败时，指定一个备份节点(standby node)。参考如下配置：

<Proxy balancer://myset>
    BalancerMember http://www2.example.com:8080
    BalancerMember http://www3.example.com:8080 loadfactor=3 timeout=1
    BalancerMember http://hstandby.example.com:8080 status=+H
    BalancerMember http://bkup1.example.com:8080 lbset=1
    BalancerMember http://bkup2.example.com:8080 lbset=1
    ProxySet lbmethod=byrequests
</Proxy>

ProxyPass "/images/"  "balancer://myset/"
ProxyPassReverse "/images/"  "balancer://myset/"
其中成员1、2、4、5是负载节点，成员3是备份节点。当所有负载节点都不健康时，将转发请求给备份节点，并由备份节点处理请求，httpd设置备份节点的方式很简单，只需将状态设置为"H"，表示hot-standby。还需注意的是负载节点4、5，它们额外的参数为lbset=1，不写时默认为0，这是负载均衡时的优先级设置，负载均衡时总是先转发给低数值的节点，也就是说或数值越小，优先级越高。所以上面的配置中，当节点1、2正常工作时，只在它们之间进行负载，此时节点4、5处于闲置状态。只有当节点1、2都失败时，才会在节点4、5之间进行负载。

 

2.4 提供负载状态显示页面
<Location "/bm">
    SetHandler balancer-manager
    Require host localhost
    Require ip 192.168.100
</Location>
然后在浏览器中输入http://server/bm即可，返回结果如图。



 

2.5 proxy相关指令
 

2.5.1 ProxyPass指令
该指令将远程服务器映射到本地主机上，但本地主机不是真实的服务器，而是远程主机的一个镜像。这个镜像通常称为反向代理服务器或网关。该指令不能用于< Directory >、< Files >容器中，且使用该指令时通常会关闭正向代理，即ProxyRequests=off。

语法：

ProxyPass [path] !|url [key=value [key=value ...]]
path参数为本地主机的URL路径，url参数为远程服务器的url一部分，不能包含查询参数。如果第一个参数path尾随了斜线，则url部分也必须尾随斜线，反之亦然。如果该指令封装在< Location >容器中，则第��个参数path可以省略，因为Location中已经指定了URL路径。如果第二个参数为"!"，则表示此path不使用反向代理功能。

例如：

<Location "/mirror/foo/">
    ProxyPass "http://backend.example.com/foo/"
</Location>
当访问http://server/mirror/foo/bar时，将转发到http://backend.example.com主机上，并请求该主机的/foo/bar文件。下面的配置指令与此等价。

ProxyPass "/mirror/foo/" "http://backend.example.com/foo/"
如果想让某个子目录不进行反向代理，而是在本地处理。可以设置第二个参数为"!"。例如，下面的配置中，/mirror/foo会被代理，但/mirror/foo/i则不会被代理。

ProxyPass "/mirror/foo/i" "!"
ProxyPass "/mirror/foo" "http://backend.example.com"
再需要说明的是连接池，httpd会为后端节点创建连接池，httpd会连接连接池中的各个节点。后端节点属性相同的共享一个连接池。后端节点的属性由key=value参数指定。以下是常见的一些属性设置，完整的属性见官方手册。

keepalive=Off|On：默认为Off。设置httpd和后端节点之间是否开启长连接，注意，这和web服务的长连接不一样，此处设置的是反向代理服务器和后端节点两者连接，当httpd将请求转发给连接池中的一个节点，并等待返回数据，当数据返回完成后，连接立即关闭，如果开启了长连接，连接暂时不关闭，只有等待均衡算法下次轮到该节点时才会再使用该连接。通常只有在httpd和后端节点间使用了防火墙时才设置为On。
lbset=N：默认为0。设置后端节点的优先级。数值N越低的，优先级越高。httpd总是会先尝试优先级高的，只有优先级高的节点不可用时，才一会尝试优先级低的。
ping=N：默认为0。设置健康状况检查时间间隔。该ping只能检查是否能ping同对方，也就是检测是否能与对方通信。更多的健康状况检查应该使用mod_proxy_hcheck模块。
retry=N：默认为60秒。当检测到后端某节点错误状态(error status)时，将在每N秒后才转发一次请求给该节点。设置为0表示正常转发请求，不用任何等待时间。该属性通常设置用来维护服务器下线然后再上线的情况。
status=VALUE：将节点手动置为何种状态。包括以下几种状态，各状态可使用"+"(默认)来赋予属性，使用"-"来取消属性。例如"+H","S-E"。

D: 该节点被禁用，不再接受任何请求。
S: 该节点处于管理维护的目的被停止。
I: 将该节点设置为无视错误(ignore-errors)模式，此模式下httpd将认为该节点可用，总会转发请求给该节点。
H: 该节点处于hot-standby模式，该节点只有在其他所有后端节点都失效时才启用。因此，该节点为备份节点。
E: 将该节点设置为错误状态(error-state)。
N: 将该节点设置为drain模式，该模式只接受已预定粘滞会话的请求sticky session，其他所有请求都会被忽略。
timeout=ProxyTimeout：设置httpd等待后端节点返回数据的超时时间。

如果使用了"balancer://"，例如前面的balancer://myset，将创建一个虚拟的连接池。虚拟连接池中的各节点可共享部分属性，也可以为每个节点设置上面所说的属性。共享属性使用ProxySet指令设置，常见的包括下面几种：

lbmethod=METHOD：设置负载均衡算法。有三种：byrequests(默认)按照请求数量计算均衡节点；bytraffic按照io流量计算均衡节点；bybusyness按照繁忙程度计算计算均衡节点。
nofailover=On|Off：默认为off。session不可用时是否转移到其他具有相同session的节点上。如果后端节点不支持session复制，应将此项设置为on。
stickysession：设置session粘滞的名称，如JSESSIONID、PHPSESSIONID。
例如：

<Proxy balancer://myset>
    BalancerMember http://www2.example.com:8080
    BalancerMember http://www3.example.com:8080 loadfactor=3 timeout=1
    BalancerMember http://hstandby.example.com:8080 status=+H
    BalancerMember http://bkup1.example.com:8080 lbset=1
    BalancerMember http://bkup2.example.com:8080 lbset=1
    ProxySet lbmethod=byrequests
</Proxy>

ProxyRequests off
ProxyPass "/images/"  "balancer://myset/"
ProxyPassReverse "/images/"  "balancer://myset/"
 

2.5.2 ProxyPassMatch指令
正则匹配模式的ProxyPass。例如：

ProxyPassMatch "^/(.*\.gif)$" "http://backend.example.com/$1"
ProxyPassMatch "^/((?i).*\.php)$" "fcgi://127.0.0.1:9000/var/www/a.com/$1"
唯一需要注意的是，在正则匹配之前，远程url参数必须是能够解析的URL地址。例如下面两条指令，第一条指令将失败，因为在正则解析前，url参数无法解析为正确的URL地址，这是一个bug，可以通过修改正则表达式的分组部分将"/"分离出去，正如下面的第二个指令。

ProxyPassMatch "^(/.*\.gif)$" "http://backend.example.com:8000$1"
ProxyPassMatch "^/(.*\.gif)$" "http://backend.example.com:8000/$1"
 

2.5.3 ProxySet指令
设置Proxy后端节点的属性。通常用来设置共享属性，但也可以设置某一个节点的属性。

例如：

<Proxy "balancer://hotcluster">
    BalancerMember "http://www2.example.com:8080" loadfactor=1
    BalancerMember "http://www3.example.com:8080" loadfactor=2
    ProxySet lbmethod=bytraffic
</Proxy>
<Proxy "http://backend">
    ProxySet keepalive=On
</Proxy>
ProxySet "balancer://foo" lbmethod=bytraffic timeout=15
 

2.5.4 < Proxy >容器
< Proxy >容器用于封装一组proxy相关指令，这些指令主要用于设置访问权限、负载均衡成员组以及它们的属性。

例如，下面的设置了只有yournetwork.example.com下的主机才能通过该(正向或反向代理)服务器访问任意请求的内容(使用了*进行通配)。

<Proxy "*">
  Require host yournetwork.example.com
</Proxy>
<Proxy "balancer://hotcluster">
    BalancerMember "http://www2.example.com:8080" loadfactor=1
    BalancerMember "http://www3.example.com:8080" loadfactor=2
    ProxySet lbmethod=bytraffic
</Proxy>
 

2.5.5 ProxyStatus指令
ProxyStatus {on|off|full}决定是否开启server-status中关于proxy的状态信息，默认为off，full是on的同义词。

例如：

ProxyStatus on
<Location "/server-status">
        SetHandler server-status
        Require all granted
</Location>
以下是关于proxy相关的状态示例：

     ----------------------------------------------------------------------

                 Proxy LoadBalancer Status for balancer://myset

   SSes Timeout Method     
   -    0       byrequests 

   Sch  Host           Stat         Route Redir F Set Acc Wr Rd 
   http 192.168.100.14 Init Ok                  1 0   0   0  0  
   http 192.168.100.15 Init Ok                  3 0   0   0  0  
   http 192.168.100.54 Init Stby Ok             1 0   0   0  0  
   http 192.168.100.16 Init Ok                  1 1   0   0  0  
   http 192.168.100.21 Init Ok                  3 1   0   0  0  

     ----------------------------------------------------------------------

   SSes    Sticky session name         
   Timeout Balancer Timeout            
   Sch     Connection scheme           
   Host    Backend Hostname            
   Stat    Worker status               
   Route   Session Route               
   Redir   Session Route Redirection   
   F       Load Balancer Factor        
   Acc     Number of uses              
   Wr      Number of bytes transferred 
   Rd      Number of bytes read
 

2.5.6 ProxyVia指令
是否在响应首部中添加"Via:"字段。可以设置为On/Off等。例如如设置为On时：

[root@xuexi ~]# curl -I http://192.168.100.17/index.html
HTTP/1.1 200 OK
Date: Sun, 01 Oct 2017 18:10:17 GMT
Server: Apache/2.4.27 (Unix)
Last-Modified: Sun, 01 Oct 2017 14:10:48 GMT
ETag: "29-55a7cd31f2329"
Accept-Ranges: bytes
Content-Length: 41
Content-Type: text/html; charset=UTF-8
Via: 1.1 customer.sharktech.net
 

2.6 ProxyPass指令的排序和共享问题
ProxyPass指令有个需要注意的问题，在匹配生效时，最先被匹配到的指令立即生效，后面的都将失效。但如果ProxyPass指令放在< Location >容器中时，由于容器中只能放置一个ProxyPass指令(因为path参数一样)，此时匹配越精确的越优先。

例如下面的指令，如果将两个ProxyPass指令位置调换，则/mirror/foo/i也仍会被代理。

ProxyPass "/mirror/foo/i" "!"
ProxyPass "/mirror/foo" "http://backend.example.com"
可以将它们分别定义到< Location >容器中，这样就无需考虑位置顺序，而是考虑匹配的精确程度，因为Location容器自身有加载顺序优先级。例如，下面的配置是可行的。

<Location "/mirror/foo/">
    ProxyPass "http://backend.example.com/"
</Location>
<Location "/mirror/foo/i">
    ProxyPass "!"
</Location>
还需考虑一个共享的问题。下面两个指令中的url参数各有长短，且第一个url是第二个url的子串。这时第二个ProxyPass的属性部分总是会使用第一个指令的属性。因此/examples/bar的请求被转发到backend.example.com/examples/bar时，它的属性timeout=60而非10。这样的属性共享可以减少创建连接池，相对来说更有效一些。

ProxyPass "/apps" "http://backend.example.com/" timeout=60
ProxyPass "/examples" "http://backend.example.com/examples" timeout=10
 

3 健康状况检查模块
ProxyPass指令自带了ping属性，可用于简单判断后端节点是否健康，只���Ping能通信就认为是健康的。但显然，对于Http服务来说，健康的指标并不能简单地通过它来判断。例如，检测某个页面是否正常、是否允许某方法等。因此，httpd提供了一个专门的健康状况检查模块mod_proxy_hcheck用于个性化订制检查指标。

检查指标也即检查方法有以下几种，由hcmethod指定：

TCP：检查是否能与后端节点建立TCP套接字，这就是问对方"你还活着吗"。
OPTIONS：发送一个HTTP OPTIONS请求给后端节点。
HEAD：发送一个HTTP HEAD请求给后端节点。
GET：发送一个HTTP GET请求给后端节点。
该健康状况检查模块认为，只要HTTP方法的检查指标返回2xx或3xx状态码都认为是健康的。

指定了检查方法后，还需订制检查的细节，例如检查的时间间隔。包括以下几项：

hcinterval：默认为30秒。发送检查的时间间隔，单位为秒。
hcuri：健康检查时，追加在URL后的URI。通常用于GET检查方法。
hcpasses：默认为1。表示只有检查了N次后都是通过的，才认为该节点是健康的可再次启用。
hcfails：默认为1。表示只有检查了N次后都是失败的，才认为该节点已经不健康，于是禁止使用该节点。
例如，以下是几个健康检查的配置示例：

<Proxy balancer://foo>
  BalancerMember http://www.example.com/  hcmethod=GET hcuri=/status.php
  BalancerMember http://www1.example.com/ hcmethod=TCP hcinterval=5 hcpasses=2 hcfails=3
  BalancerMember http://www2.example.com/
</Proxy>

ProxyPass "/" "balancer://foo"
ProxyPassReverse "/" "balancer://foo"