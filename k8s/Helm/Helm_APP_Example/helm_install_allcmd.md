# install allcmd 

* 要求:
* *  可以连接外网 
* *  ingress 
* *  StorageClass 

## 使用wordpress直接部署

* 执行以下命令
``` bash
helm install --name allcmd --set "persistence.storageClass="example-nfs",mariadb.persistence.storageClass="example-nfs",ingress.enabled=true,ingress.hostname=jihongrui.example.com,wordpressUsername=jihongrui,resources.requests.cpu=1,resources.requests.memory=1Gi" stable/wordpress
```

## 修改wordpress为allcmd,再部署

``` bash
mkdir helm-app
tar xf /root/.helm/cache/archive/wordpress-0.6.13.tgz -C /opt/helm-app
cd /opt/helm-app
mv wordpress allcmd
```
* 修改Chart.yaml 
``` yaml 
maintainers:
- email: containers@bitnami.com
  name: bitnami-bot
name: allcmd  # 这里要和目录名一至
sources:
- https://github.com/bitnami/bitnami-docker-wordpress
version: 0.6.13
```

* 修改values.yaml 
``` yaml
image: bitnami/wordpress:4.8.2-r0
imagePullPolicy: IfNotPresent
wordpressUsername: jihongrui
wordpressEmail: jihongrui@beyondcent.com
wordpressFirstName: Ji
wordpressLastName: Hongrui
wordpressBlogName: Hongrui-Ji
allowEmptyPassword: yes
mariadb:
  mariadbDatabase: bitnami_wordpress
  mariadbUser: bn_wordpress
  persistence:
    enabled: true
    accessMode: ReadWriteOnce
    size: 20Gi
serviceType: LoadBalancer
healthcheckHttps: false
ingress:
    enabled: true
    hostname: allcmd.com
persistence:
  enabled: true
  accessMode: ReadWriteOnce
  size: 20Gi
resources:
  requests:
    memory: 1Gi
    cpu: 1
nodeSelector: {}

```

* 打包目录
``` 
cd /opt/helm-app
helm package allcmd
ls
allcmd-0.6.13.tgz allcmd
``` 

* 索引allcmd
``` bash
mkdir -p /root/allcmd
mv /opt/helm-app/allcmd-0.6.13.tgz /root/allcmd
helm repo index /root/allcmd --url http://192.168.1.113:8879/charts
```

* 查找
```
[root@master2 .helm]# helm search local/allcmd
NAME        	VERSION	DESCRIPTION                                       
local/allcmd	0.6.13 	Web publishing platform for building blogs and ...

```

### 部署
```
helm install --name jihongrui local/allcmd
```

```
[root@master2 .helm]# kubectl get pod,deploy,svc,pvc,ingress -o wide |grep jihongrui
pod/jihongrui-allcmd-6bd8d5bb4b-jd5vh    1/1       Running   0          1h        10.255.255.75    master2.example.com
pod/jihongrui-mariadb-664799494d-rg9xr   1/1       Running   0          1h        10.255.255.8     master1.example.com

deployment.extensions/jihongrui-allcmd    1         1         1            1           1h        jihongrui-allcmd    bitnami/wordpress:4.8.2-r0                                              
  app=jihongrui-allcmddeployment.extensions/jihongrui-mariadb   1         1         1            1           1h        jihongrui-mariadb   bitnami/mariadb:10.1.23-r2                                              
  app=jihongrui-mariadb
service/jihongrui-allcmd    LoadBalancer   172.255.255.106   <pending>     80:30859/TCP,443:32404/TCP           1h        app=jihongrui-allcmd
service/jihongrui-mariadb   ClusterIP      172.255.255.133   <none>        3306/TCP                             1h        app=jihongrui-mariadb

persistentvolumeclaim/jihongrui-allcmd    Bound     pvc-ac0786cd-58ca-11e8-a723-005056a22152   20Gi       RWO            example-nfs    1h
persistentvolumeclaim/jihongrui-mariadb   Bound     pvc-ac05d17e-58ca-11e8-a723-005056a22152   20Gi       RWO            example-nfs    1h

ingress.extensions/jihongrui-allcmd   allcmd.com             80        1h
```
