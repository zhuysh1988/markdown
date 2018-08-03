#禁止以IP访问Nginx



###ip.conf

    server {
    listen 80 default_server;
    server_name _;
    return 403;
    }

    server {
    listen 443 default_server;
    server_name _;
          ssl_certificate  ip.crt;           #cacert.pem 文件路径
          ssl_certificate_key ip.key;    #privkey.pem 文件路径
          ssl on;
    return 403;
    }

###https.conf
###### https 配置
    server {
       listen 80;
       server_name  domain.com;
       location / {
            proxy_pass http://127.0.0.1:38080;
            proxy_set_header Host $host;
            proxy_redirect off;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_connect_timeout 60;
            proxy_read_timeout 600;
            proxy_send_timeout 600;
        }
    }
    server {
    listen 443 ;
    server_name domain.com;
    ssl_certificate domain.crt;
    ssl_certificate_key domain.key;
    ssl on;
    ssl_session_timeout 5m;
    ssl_protocols SSLv2 SSLv3 TLSv1;
    ssl_ciphers ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP;
    ssl_prefer_server_ciphers on;


       location / {
            proxy_pass http://127.0.0.1:38080;
            proxy_set_header Host $host;
            proxy_redirect off;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_connect_timeout 60;
            proxy_read_timeout 600;
            proxy_send_timeout 600;
        }

    }


###强制使用HTTPS
    server {
      listen       80;
          server_name  domain.com ;
          rewrite ^ https://$http_host$request_uri? permanent;    #强制将http重定向到https
        }
    server {
    listen 443 ;
    server_name domain.com;
    ssl_certificate domain.crt;
    ssl_certificate_key domain.key;
    ssl on;
    ssl_session_timeout 5m;
    ssl_protocols SSLv2 SSLv3 TLSv1;
    ssl_ciphers ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP;
    ssl_prefer_server_ciphers on;


       location / {
            proxy_pass http://127.0.0.1:38080;
            proxy_set_header Host $host;
            proxy_redirect off;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_connect_timeout 60;
            proxy_read_timeout 600;
            proxy_send_timeout 600;
        }

    }
