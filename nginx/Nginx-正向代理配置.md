#Nginx 正向代理配置
    server{
        resolver 223.5.5.5 223.6.6.6;
        resolver_timeout 5s;
        listen 8080;
        server_name test.com;
        access_log /home/logs/access.log;
        location /{
            proxy_pass http://$host$request_uri;
        }
    }
