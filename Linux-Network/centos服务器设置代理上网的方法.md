这里以centos7.0为例，记录代理服务器设置过程：

1.全局的代理设置：
vi /etc/profile

添加下面内容

http_proxy = http://username:password@yourproxy:8080/
ftp_proxy = http://username:password@yourproxy:8080/
export http_proxy
export ftp_proxy

2.yum的代理设置：
vi /etc/yum.conf

添加下面内容

proxy = http://username:password@yourproxy:8080/

或者



proxy=http://yourproxy:808
proxy=ftp://yourproxy:808
proxy_username=username
proxy_password=password

3.Wget的代理设置：
vi /etc/wgetrc

添加下面内容

# Proxy
http_proxy=http://username:password@proxy_ip:port/
ftp_proxy=http://username:password@proxy_ip:port/