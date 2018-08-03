#nginx.conf

    user www www;

    

    worker_processes auto;

    

    pid        /home/logs/nginx.pid;



    error_log  syslog:server=192.168.80.80:20514,tag=nignx,severity=info info;



    worker_rlimit_nofile 65535;

    

    events

    {

      worker_connections 40960;

    }



    

    http

    {

        #Geo_IP

        geoip_country /nginx_static/nginx/geo/GeoIP.dat;

        geoip_city /nginx_static/nginx/geo/GeoLiteCity.dat; 

        

        

        include       mime.types;

        default_type  application/octet-stream;



    

    log_format json  '"host":"$server_addr",'

                     '"clientip":"$remote_addr",'

                     '"size":$body_bytes_sent,'

                     '"responsetime":$request_time,'

                     '"upstreamtime":"$upstream_response_time",'

                     '"upstreamhost":"$upstream_addr",'

                     '"http_host":"$host",'

                     '"url":"$uri",'

                     '"xff":"$http_x_forwarded_for",'

                     '"referer":"$http_referer",'

                     '"agent":"$http_user_agent",'

                     '"status":"$status"';

    access_log syslog:server=192.168.80.80:20514,tag=nginx,severity=info json;

    

    

    

    

    

    

      server_names_hash_bucket_size 128;

      client_header_buffer_size 32k;

      client_body_buffer_size 128k;

      large_client_header_buffers 4 32k;

      client_max_body_size 200m;

    

    #  client_header_timeout 3m;

    #  client_body_timeout   3m;

    #  send_timeout          3m;

    

      sendfile on;

      tcp_nopush     on;

      tcp_nodelay      on;

    

      keepalive_timeout 65;

    

    #  proxy_redirect          off;

    #  proxy_connect_timeout   90; 

    #  proxy_send_timeout      90; 

    #  proxy_read_timeout      90; 

    #  proxy_buffer_size       4k; 

    #  proxy_buffers           4 32k; 

    #  proxy_busy_buffers_size 64k; 

    #  proxy_temp_file_write_size 64k;

    #

      gzip on;

      gzip_min_length  1k;

      gzip_buffers     4 16k;

      gzip_http_version 1.1;

      gzip_comp_level 2;

      gzip_types       text/plain application/x-javascript text/css application/xml sitemap.xml text/xml image/jpeg image/gif image/png;

      #gzip_vary on;

    

      server_tokens off;

      charset utf-8;

    

     include  /nginx_static/nginx/conf.d/*.conf;

    }
