###Nginx 限制spider速度
    #全局配置
    limit_req_zone $anti_spider zone=anti_spider:10m rate=15r/m;
    #某个server中
     limit_req zone=anti_spider burst=30 nodelay;
     if ($http_user_agent ~* "xxspider|xxbot") {
     set $anti_spider $http_user_agent;
    }
###超过设置的限定频率，就会给spider一个503。
###上述配置详细解释请自行google下，具体的spider/bot名称请自定义。
#附：nginx中禁止屏蔽网络爬虫
    server {
            listen       80;
            server_name  www.xxx.com;

            #charset koi8-r;

            #access_log  logs/host.access.log  main;

            #location / {
            #    root   html;
            #    index  index.html index.htm;
            #}
        if ($http_user_agent ~* "qihoobot|Baiduspider|Googlebot|Googlebot-Mobile|Googlebot-Image|Mediapartners-Google|Adsbot-Google|Feedfetcher-Google|Yahoo! Slurp|Yahoo! Slurp China|YoudaoBot|Sosospider|Sogou spider|Sogou web spider|MSNBot|ia_archiver|Tomato Bot") {
                    return 403;
            }

        location ~ ^/(.*)$ {
                    proxy_pass http://localhost:8080;
            proxy_redirect          off;
            proxy_set_header        Host $host;
            proxy_set_header        X-Real-IP $remote_addr;
            proxy_set_header       X-Forwarded-For   $proxy_add_x_forwarded_for;
            client_max_body_size    10m;
            client_body_buffer_size 128k;
            proxy_connect_timeout   90;
            proxy_send_timeout      90;
            proxy_read_timeout      90;
            proxy_buffer_size       4k;
            proxy_buffers           4 32k;
            proxy_busy_buffers_size 64k;
            proxy_temp_file_write_size 64k;
        }
    }
