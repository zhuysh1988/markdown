

# SSH lb.example.com

## Open 80 Port 
```bash
# // not firewalld
iptables -A OS_FIREWALL_ALLOW -p tcp -m tcp --dport 80 -j ACCEPT
service iptables save

# // firewalld
firewall-cmd --permanent --add-service=http
firewall-cmd --reload
```




## Config HAproxy

### Example 
```bash


# 注意, 主机名要能解析成IP才可以. 


MASTER1=`host master1.example.com | cut -f4 -d" "`
MASTER2=`host master2.example.com | cut -f4 -d" "`
MASTER3=`host master3.example.com | cut -f4 -d" "`
INFRANODE1=`host infranode1.example.com | cut -f4 -d" "`
INFRANODE2=`host infranode2.example.com | cut -f4 -d" "`


cat <<EOF > /etc/haproxy/haproxy.cfg

# Global settings
#---------------------------------------------------------------------
global
    maxconn     20000
    log         /dev/log local0 info
    chroot      /var/lib/haproxy
    pidfile     /var/run/haproxy.pid
    user        haproxy
    group       haproxy
    daemon

    # turn on stats unix socket
    stats socket /var/lib/haproxy/stats

#---------------------------------------------------------------------
# common defaults that all the 'listen' and 'backend' sections will
# use if not designated in their block
#---------------------------------------------------------------------
defaults
    mode                    http
    log                     global
    option                  httplog
    option                  dontlognull
#    option http-server-close
    option forwardfor       except 127.0.0.0/8
    option                  redispatch
    retries                 3
    timeout http-request    10s
    timeout queue           1m
    timeout connect         10s
    timeout client          300s
    timeout server          300s
    timeout http-keep-alive 10s
    timeout check           10s
    maxconn                 20000

listen stats :9000
    mode http
    stats enable
    stats uri /

frontend  atomic-openshift-all-the-things-http
    bind  *:80
    mode tcp
    option tcplog
    default_backend atomic-openshift-apps-http

frontend  atomic-openshift-all-the-things-https
    bind  *:443
    mode tcp
    option tcplog
    tcp-request inspect-delay 5s
    tcp-request content accept if { req_ssl_hello_type 1 }

    acl host_masters   req_ssl_sni -i ocp39.example.com lb.example.com 
    use_backend atomic-openshift-api if host_masters
    default_backend atomic-openshift-apps-https

frontend  atomic-openshift-all-the-things-http
    bind  *:80
    mode tcp
    option tcplog
    default_backend atomic-openshift-apps-http

backend atomic-openshift-api
    balance source
    mode tcp
    server      master0 $MASTER1:443 check
    server      master1 $MASTER2:443 check
    server      master2 $MASTER3:443 check

backend atomic-openshift-apps-https
    balance source
    mode tcp
    server      infranode1 $INFRANODE1:443 check
    server      infranode2 $INFRANODE2:443 check

backend atomic-openshift-apps-http
    balance source
    mode tcp
    server      infranode1 $INFRANODE1:80 check
    server      infranode2 $INFRANODE2:80 check
EOF
```



* cat /etc/haproxy/haproxy.cfg 
```
# Global settings
#---------------------------------------------------------------------
global
    maxconn     20000
    log         /dev/log local0 info
    chroot      /var/lib/haproxy
    pidfile     /var/run/haproxy.pid
    user        haproxy
    group       haproxy
    daemon

    # turn on stats unix socket
    stats socket /var/lib/haproxy/stats

#---------------------------------------------------------------------
# common defaults that all the 'listen' and 'backend' sections will
# use if not designated in their block
#---------------------------------------------------------------------
defaults
    mode                    http
    log                     global
    option                  httplog
    option                  dontlognull
#    option http-server-close
    option forwardfor       except 127.0.0.0/8
    option                  redispatch
    retries                 3
    timeout http-request    10s
    timeout queue           1m
    timeout connect         10s
    timeout client          300s
    timeout server          300s
    timeout http-keep-alive 10s
    timeout check           10s
    maxconn                 20000

listen stats :9000
    mode http
    stats enable
    stats uri /

frontend  atomic-openshift-all-the-things-http
    bind  *:80
    mode tcp
    option tcplog
    default_backend atomic-openshift-apps-http

frontend  atomic-openshift-all-the-things-https
    bind  *:443
    mode tcp
    option tcplog
    tcp-request inspect-delay 5s
    tcp-request content accept if { req_ssl_hello_type 1 }


    # 配置ACL  host_masters  , 所有通过ocp39.example.com lb.example.com 域名的连接,都转发到 atomic-openshift-api
    acl host_masters   req_ssl_sni -i ocp39.example.com lb.example.com
    use_backend atomic-openshift-api if host_masters


    # 不匹配 ACL的连接, 转发至 atomic-openshift-apps-https  , 也就是infarnode
    default_backend atomic-openshift-apps-https

frontend  atomic-openshift-all-the-things-http
    bind  *:80
    mode tcp
    option tcplog
    default_backend atomic-openshift-apps-http

backend atomic-openshift-api
    balance source
    mode tcp
    server      master0 192.168.2.180:443 check
    server      master1 192.168.2.48:443 check
    server      master2 192.168.2.99:443 check

backend atomic-openshift-apps-https
    balance source
    mode tcp
    # This Server is route deploy server IP 
    server      infranode1 192.168.2.136:443 check
    server      infranode2 192.168.2.130:443 check

backend atomic-openshift-apps-http
    balance source
    mode tcp
    # This Server is route deploy server IP 
    server      infranode1 192.168.2.136:80 check
    server      infranode2 192.168.2.130:80 check
```


## Restart  HAproxy
```bash
systemctl restart haproxy ; systemctl status haproxy
ss -lntp
```