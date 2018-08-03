#nginx 编译安装


###=========================================================================
    useradd www
    passwd www

###=========================================================================
    yum install openssl openssl-devel zlib zlib-devel gd-devel pcre pcre-devel gcc -y

###=========================================================================

    cd /opt
    wget http://geolite.maxmind.com/download/geoip/api/c/GeoIP.tar.gz
    tar xf GeoIP.tar.gz
    cd GeoIP-1.4.8/
    ./configure
    make && make install
    > /etc/ld.so.conf.d/geo.conf
    echo "/opt/GeoIP-1.4.8/libGeoIP/.libs " >/etc/ld.so.conf.d/geo.conf
    ldconfig
###=========================================================================
    wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz
    wget http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz



###=========================================================================

    wget http://nginx.org/download/nginx-1.10.2.tar.gz

    tar xf nginx-1.10.2.tar.gz

    cd nginx-1.10.2

    ./configure \
    --prefix=/home/www/nginx \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/home/www/nginx/nginx.conf \
    --pid-path=/home/www/nginx/logs/nginx.pid \
    --error-log-path=/home/www/nginx/logs/error.log \
    --http-log-path=/home/www/nginx/logs/access.log \
    --user=www \
    --group=www \
    --with-http_ssl_module \
    --with-http_realip_module \
    --with-http_image_filter_module \
    --with-http_geoip_module \
    --with-stream  
    make && make install

###=========================================================================
### Centos 7 systemd 管理文件
    cat <<EOF >/usr/lib/systemd/system/nginx.service
    [Unit]
    Description=The nginx HTTP and reverse proxy server
    After=network.target remote-fs.target nss-lookup.target

    [Service]
    Type=forking
    # PID
    PIDFile=/home/nginx/logs/nginx.pid
    # Command
    ExecStartPre=/usr/sbin/nginx -t
    ExecStart=/usr/sbin/nginx
    ExecReload=/bin/kill -s HUP $MAINPID
    KillSignal=SIGQUIT
    TimeoutStopSec=5
    KillMode=mixed
    PrivateTmp=true

    [Install]
    WantedBy=multi-user.target
    EOF
