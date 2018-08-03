


## git gogs
```bash
docker run  -d \
--name=gogs \
-p 40022:22 \
-p 40080:3000 \
-v /data/gogs:/data \
--restart=always \
registry.example.com:5000/gogs:latest
```


## registry-ui 
```bash
docker run -d \
-p 40081:8080 \
--restart=always \
--name registry-ui \
-e REGISTRY_URL=http://192.168.4.169:5000/v2 \
-e REGISTRY_NAME=registry.example.com:5000 \
-e REGISTRY_READONLY=false \
registry.example.com:5000/docker-registry-web 
```

## mysql v5.6
```bash
docker run -d \
--network host \
--restart=always \
-v /data/mysql:/var/lib/mysql \
-e MYSQL_ROOT_PASSWORD=onceas \
--name cmp-mysql registry.example.com:5000/jihongrui/mysql:v5.6
```