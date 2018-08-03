## nginx 配置文件
# Deny_IP.conf
    server {
    listen 80 default_server;
    server_name _;
    return 444;
    }
    
    server {
    listen 443 default_server;
    server_name _;
    ssl_certificate domain.crt;
    ssl_certificate_key domain.key;
    ssl on;
    return 444;
    }
# STATIC.conf
    server {
        listen       80;
        server_name  static.txkm.com;
    
        location ~* .*\.(gif|jpg|jpeg|png|bmp|swf|js|css|html)?$
         {
        index index.html;
        root /webcode/static;
        autoindex   off;
        expires 1d;
        }
        location / {
            proxy_pass http://127.0.0.1:8080;
            proxy_set_header Host $host;
            proxy_redirect off;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_connect_timeout 60;
            proxy_read_timeout 600;
            proxy_send_timeout 600;
            }
    }
