安装Shadowsocks客户端
安装epel源、安装pip包管理
sudo yum -y install epel-release
sudo yum -y install python-pip
安装Shadowsocks客户端
sudo pip install shadowsocks
配置Shadowsocks连接
新建配置文件、默认不存在
sudo mkdir /etc/shadowsocks
sudo vi /etc/shadowsocks/shadowsocks.json
添加配置信息：前提是需要有ss服务器的地址、端口等信息
{
    "server":"x.x.x.x",  # Shadowsocks服务器地址
    "server_port":1035,  # Shadowsocks服务器端口
    "local_address": "127.0.0.1", # 本地IP
    "local_port":1080,  # 本地端口
    "password":"password", # Shadowsocks连接密码
    "timeout":300,  # 等待超时时间
    "method":"aes-256-cfb",  # 加密方式
    "fast_open": false,  # true或false。开启fast_open以降低延迟，但要求Linux内核在3.7+
    "workers": 1  #工作线程数 
}
配置自启动
新建启动脚本文件/etc/systemd/system/shadowsocks.service，内容如下：

[Unit]
Description=Shadowsocks
[Service]
TimeoutStartSec=0
ExecStart=/usr/bin/sslocal -c /etc/shadowsocks/shadowsocks.json
[Install]
WantedBy=multi-user.target
启动Shadowsocks服务
systemctl enable shadowsocks.service
systemctl start shadowsocks.service
systemctl status shadowsocks.service
验证Shadowsocks客户端服务是否正常运行
curl --socks5 127.0.0.1:1080 http://httpbin.org/ip
Shadowsock客户端服务已正常运行，则结果如下：
{
  "origin": "x.x.x.x"       #你的Shadowsock服务器IP
}
安装配置privoxy
安装privoxy
yum install privoxy -y
systemctl enable privoxy
systemctl start privoxy
systemctl status privoxy
配置privoxy
修改配置文件/etc/privoxy/config

listen-address 127.0.0.1:8118 # 8118 是默认端口，不用改
forward-socks5t / 127.0.0.1:1080 . #转发到本地端口，注意最后有个点
设置http、https代理
# vi /etc/profile 在最后添加如下信息
PROXY_HOST=127.0.0.1
export all_proxy=http://$PROXY_HOST:8118
export ftp_proxy=http://$PROXY_HOST:8118
export http_proxy=http://$PROXY_HOST:8118
export https_proxy=http://$PROXY_HOST:8118
export no_proxy=localhost,172.16.0.0/16,192.168.0.0/16.,127.0.0.1,10.10.0.0/16

# 重载环境变量
source /etc/profile
测试代理
[root@aniu-k8s ~]# curl -I www.google.com 
HTTP/1.1 200 OK
Date: Fri, 26 Jan 2018 05:32:37 GMT
Expires: -1
Cache-Control: private, max-age=0
Content-Type: text/html; charset=ISO-8859-1
P3P: CP="This is not a P3P policy! See g.co/p3phelp for more info."
Server: gws
X-XSS-Protection: 1; mode=block
X-Frame-Options: SAMEORIGIN
Set-Cookie: 1P_JAR=2018-01-26-05; expires=Sun, 25-Feb-2018 05:32:37 GMT; path=/; domain=.google.com
Set-Cookie: NID=122=PIiGck3gwvrrJSaiwkSKJ5UrfO4WtAO80T4yipOx4R4O0zcgOEdvsKRePWN1DFM66g8PPF4aouhY4JIs7tENdRm7H9hkq5xm4y1yNJ-sZzwVJCLY_OK37sfI5LnSBtb7; expires=Sat, 28-Jul-2018 05:32:37 GMT; path=/; domain=.google.com; HttpOnly
Transfer-Encoding: chunked
Accept-Ranges: none
Vary: Accept-Encoding
Proxy-Connection: keep-alive
取消使用代理
while read var; do unset $var; done < <(env | grep -i proxy | awk -F= '{print $1}')

