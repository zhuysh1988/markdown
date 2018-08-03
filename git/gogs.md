




docker run --name=gogs -p 40022:22 -p 40080:3000 -d -v /var/lib/registry/gogs:/data --restart=always gogs/gogs:latest


docker run --name=gogs -p 40022:22 -p 40080:3000 -d -v /data/gogs:/data --restart=always registry.example.com:5000/gogs/gogs:latest