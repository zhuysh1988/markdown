## 1 蓝绿部署

                                user
                                |
                                WEB
                                |
        route bluegreen-jihongrui.apps.na39.openshift.opentlc.com
                |                   |
                svc/bule            svc/green


### 1.1  create app blue 
```bash 
## create new app , set app name is blue , and ENV SELECTOR=cats
oc new-app --name='blue' --labels=name="blue" php~https://github.com/wkulhanek/cotd.git --env=SELECTOR=cats

## create route for svc blue
oc expose svc/blue --name=bluegreen

## show svc 
oc get svc 
NAME      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)             AGE
blue      ClusterIP   172.30.67.255   <none>        8080/TCP,8443/TCP   29m


## show route 
oc get route
NAME        HOST/PORT                                             PATH      SERVICES   PORT       TERMINATION   WILDCARD
bluegreen   bluegreen-jihongrui.apps.na39.openshift.opentlc.com             blue      8080-tcp                 None

## WEB access the route 
使用浏览器打开route 显示的是猫的图片

```


### 1.2 create app green 
```bash
## create new app , set app name is green , and ENV SELECTOR=cities
oc new-app --name='green' --labels=name=green php~https://github.com/wkulhanek/cotd.git --env=SELECTOR=cities

## show svc 
oc get svc 
NAME      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)             AGE
blue      ClusterIP   172.30.67.255   <none>        8080/TCP,8443/TCP   29m
green     ClusterIP   172.30.65.79    <none>        8080/TCP,8443/TCP   8m

## change route for svc green 
oc patch route/bluegreen -p '{"spec":{"to":{"name":"green"}}}'

## show route 
oc get route 
NAME        HOST/PORT                                             PATH      SERVICES   PORT       TERMINATION   WILDCARD
bluegreen   bluegreen-jihongrui.apps.na39.openshift.opentlc.com             green      8080-tcp                 None

## WEB access the route 
使用浏览器打开route 显示的是城市的图片


```

### 1.3 reset ENV SELECTOR=pets to app blue 
```bash
## reset ENV SELECTOR=pets to app blue , 应用会重新部署
oc set env dc/blue SELECTOR=pets

```

### 1.4 配置route backends ,并设置 权重
```bash
## show route 
oc get route 
NAME        HOST/PORT                                             PATH      SERVICES   PORT       TERMINATION   WILDCARD
bluegreen   bluegreen-jihongrui.apps.na39.openshift.opentlc.com             green      8080-tcp                 None

## 将svc/blue 添加至route bluegreen 中, 设置green权重值为100 , blue=0
oc set route-backends bluegreen green=100 blue=0

## 现在访问route ,显示的还是green app 

## 修改权重值 green=0 blue=100
oc set route-backends bluegreen green=0 blue=100

## show route 
oc get route
NAME        HOST/PORT                                             PATH      SERVICES               PORT       TERMINATION   WILDCARD
bluegreen   bluegreen-jihongrui.apps.na39.openshift.opentlc.com             green(0%),blue(100%)   8080-tcp                 None

## 再次访问route , 显示的是app blue 的新图片. 


[root@bastion 0 ~]# oc set route-backends bluegreen green=20 blue=30
route "bluegreen" updated
[root@bastion 0 ~]# oc get route
NAME        HOST/PORT                                             PATH      SERVICES               PORT       TERMINATION   WILDCARD
bluegreen   bluegreen-jihongrui.apps.na39.openshift.opentlc.com             green(40%),blue(60%)   8080-tcp                 None
```

## 2 应用健康检查
### 想想以下内容
* 您如何确定应用程序已准备就绪？ 
* 您如何确定应用程序仍然存在？ 
* 初始超时应该多长时间？需要一个吗？ 
* 应该多久检查一次探头？你需要设置它吗？

### 设置应用的健康检查
```bash
oc set probe dc/green --readiness --get-url=http://:8080/item.php --initial-delay-seconds=2
oc set probe dc/blue --readiness --get-url=http://:8080/item.php --initial-delay-seconds=2

oc set probe dc/green --liveness --get-url=http://:8080/item.php --initial-delay-seconds=2
oc set probe dc/blue --liveness --get-url=http://:8080/item.php --initial-delay-seconds=2
```


## 3 StatefulSet

### 3.1 create internal headless service 

* Set the name of the service to mongodb-internal.

* Set the ClusterIP to none in order to make it headless.

* It must have the annotation service.alpha.kubernetes.io/tolerate-unready-endpoints: "true" for MongoDB to properly come up.

* The port to connect to is 27017, the standard MongoDB port.
```bash
echo 'kind: Service
apiVersion: v1
metadata:
  name: "mongodb-internal"
  labels:
    name: "mongodb"
  annotations:
    service.alpha.kubernetes.io/tolerate-unready-endpoints: "true"
spec:
  clusterIP: None
  ports:
    - name: mongodb
      port: 27017
  selector:
    name: "mongodb"' | oc create -f -

```

### 3.2 创建数据库客户端用于连接数据库的常规服务。
```bash
echo 'kind: Service
apiVersion: v1
metadata:
  name: "mongodb"
  labels:
    name: "mongodb"
spec:
  ports:
    - name: mongodb
      port: 27017
  selector:
    name: "mongodb"' | oc create -f -
```

### 3.3 Create StatefulSet for MongoDB Database

```
Make sure to use apiVersion: apps/v1 for OpenShift 3.9.

Make sure your spec.selector.matchLabels matches your spec.template.metadata.labels field.

Make sure your spec.serviceName matches the name of your headless service.

You need three replicas (pods).

The pods need the label name=mongodb for your services to find them.

You can use the MongoDB container image from Red Hat Software Collections: registry.access.redhat.com/rhscl/mongodb-34-rhel7:latest.

This container image can be run both standalone (the default) and as a MongoDB replica set.

To run this container with replication enabled, add a startup argument: run-mongod-replication.

This container listens on port 27017.

It needs a volume mount defined for the /var/lib/mongodb/data path.

The image expects configuration as environment variables—you can either specify the variables directly (easier) or add all required values into a secret and reference the appropriate fields in the secret. Feel free to use values other than the suggested ones—just make sure to use the same values when connecting to the database.

MONGODB_DATABASE = mongodb

MONGODB_USER = mongodb_user

MONGODB_PASSWORD = mongodb_password

MONGODB_ADMIN_PASSWORD = mongodb_admin_password

MONGODB_REPLICA_NAME = rs0 (Do not change this.)

MONGODB_KEYFILE_VALUE = 12345678901234567890 (Randomly generated from a secret would be better.)

MONGODB_SERVICE_NAME = mongodb-internal (Your headless service name.)

The container needs a readiness probe to tell OpenShift when it is successfully started and it is safe to start the next pod.

The startup script writes a /tmp/initialized file when the database is running.

You can use the stat /tmp/initialized command for the probe.

The pods need a volumeClaimTemplate to define the PVCs to attach to the individual pods.

Remember that in a StatefulSet the same PVC gets attached to the same pod every single time—therefore all PVCs need to be identical and created via a volume claim template.

The name of the volumeClaimTemplate needs to match the name of the volumeMount of your pod definition.

Set accessModes to ReadWriteOnce because each PVC can be attached to exactly one pod—otherwise database corruption occurs.
```

```bash
echo 'kind: StatefulSet
apiVersion: apps/v1
metadata:
  name: "mongodb"
spec:
  serviceName: "mongodb-internal"
  replicas: 3
  selector:
    matchLabels:
      name: mongodb
  template:
    metadata:
      labels:
        name: "mongodb"
    spec:
      containers:
        - name: mongo-container
          image: "registry.access.redhat.com/rhscl/mongodb-34-rhel7:latest"
          ports:
            - containerPort: 27017
          args:
            - "run-mongod-replication"
          volumeMounts:
            - name: mongo-data
              mountPath: "/var/lib/mongodb/data"
          env:
            - name: MONGODB_DATABASE
              value: "mongodb"
            - name: MONGODB_USER
              value: "mongodb_user"
            - name: MONGODB_PASSWORD
              value: "mongodb_password"
            - name: MONGODB_ADMIN_PASSWORD
              value: "mongodb_admin_password"
            - name: MONGODB_REPLICA_NAME
              value: "rs0"
            - name: MONGODB_KEYFILE_VALUE
              value: "12345678901234567890"
            - name: MONGODB_SERVICE_NAME
              value: "mongodb-internal"
          readinessProbe:
            exec:
              command:
                - stat
                - /tmp/initialized
  volumeClaimTemplates:
    - metadata:
        name: mongo-data
        labels:
          name: "mongodb"
      spec:
        accessModes: [ ReadWriteOnce ]
        resources:
          requests:
            storage: "4Gi"' | oc create -f -
```

```
[root@bastion 0 ~]# oc get pvc
NAME                   STATUS    VOLUME    CAPACITY   ACCESS MODES   STORAGECLASS   AGE
mongo-data-mongodb-0   Bound     vol449    10Gi       RWO                           26m
mongo-data-mongodb-1   Bound     vol401    10Gi       RWO                           26m
mongo-data-mongodb-2   Bound     vol282    10Gi       RWO                           26m
[root@bastion 0 ~]# oc scale statefulset mongodb --replicas=5
statefulset "mongodb" scaled
[root@bastion 0 ~]# oc get pod
NAME             READY     STATUS    RESTARTS   AGE
mongodb-0        1/1       Running   0          30m
mongodb-1        1/1       Running   0          29m
mongodb-2        1/1       Running   0          29m
mongodb-3        0/1       Running   0          8s
shelly-1-z9wp8   1/1       Running   0          18m
[root@bastion 0 ~]# oc get pvc
NAME                   STATUS    VOLUME    CAPACITY   ACCESS MODES   STORAGECLASS   AGE
mongo-data-mongodb-0   Bound     vol449    10Gi       RWO                           30m
mongo-data-mongodb-1   Bound     vol401    10Gi       RWO                           30m
mongo-data-mongodb-2   Bound     vol282    10Gi       RWO                           29m
mongo-data-mongodb-3   Bound     vol341    10Gi       RWO                           18s
mongo-data-mongodb-4   Bound     vol450    10Gi       RWO                           3s
```


### Deploy Rocket.Chat as MongoDB Client
```
oc new-app docker.io/rocketchat/rocket.chat:0.63.3 -e MONGO_URL="mongodb://mongodb_user:mongodb_password@mongodb:27017/mongodb?replicaSet=rs0"

oc expose svc/rocketchat
```