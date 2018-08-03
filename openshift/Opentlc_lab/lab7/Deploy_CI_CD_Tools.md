# Deploy Gogs Nexus 


NFS (rw,root_squash)

* Gogs是一个带有Web前端的源代码存储库管理器。 
* Nexus是一个工件存储库，用于存储构建依赖关系（以及其他功能）。


* 1 将所有可能需要的映像（例如PostgreSQL，Gogs和Nexus3）从Isolated1. $ GUID.internal主机导入到在infra节点上运行pod的OpenShift集成docker-registry服务

```bash
oc import-image docker-registry.default.svc:5000/jboss-webserver-3/webserver31-tomcat8-openshift:1.1 --from=registry.example.com:5000/jboss-webserver-3/webserver31-tomcat8-openshift:1.1 --confirm --insecure=true -n openshift



oc import-image docker-registry.default.svc:5000/gogs:latest --from=registry.example.com:5000/wkulhanek/gogs:latest --confirm --insecure=true -n openshift

oc import-image docker-registry.default.svc:5000/sonatype/nexus3:latest --from=registry.example.com:5000/sonatype/nexus3:latest --confirm --insecure=true -n openshift

oc import-image docker-registry.default.svc:5000/rhscl/postgresql:latest --from=registry.example.com:5000/rhscl/postgresql-96-rhel7:latest --confirm --insecure=true -n openshift
oc tag postgresql:latest postgresql:9.6 -n openshift

oc import-image docker-registry.default.svc:5000/openshift/jboss-eap70-openshift:latest --from=registry.example.com:5000/jboss-eap-7/eap70-openshift:latest --confirm --insecure=true -n openshift
oc tag jboss-eap70-openshift:latest jboss-eap70-openshift:1.7 -n openshift
```

## Deploy Nexus3

```bash 
# 新建project cicd
oc new-project cicd

oc adm policy add-scc-to-group anyuid system:serviceaccounts:cicd

# 创建pvc , nexus maven库存储
echo "apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nexus-pvc
  annotations:
    volume.beta.kubernetes.io/storage-class: "example-nfs"
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi" | oc create -f -

# 使用is nexus3 创建 nexus3 app 
oc new-app openshift/nexus3:latest

# 
oc rollout pause dc nexus3
oc patch dc nexus3 --patch='{ "spec": { "strategy": { "type": "Recreate" }}}'
oc set resources dc nexus3 --limits=memory=2Gi --requests=memory=1Gi

oc set volume dc/nexus3 --add --overwrite --name=nexus3-volume-1 --mount-path=/nexus-data/ --type persistentVolumeClaim --claim-name=nexus-pvc
oc set probe dc/nexus3 --liveness --failure-threshold 3 --initial-delay-seconds 60 -- echo ok
oc set probe dc/nexus3 --readiness --failure-threshold 3 --initial-delay-seconds 60 --get-url=http://:8081/repository/maven-public/
oc rollout resume dc nexus3
oc expose svc nexus3
```

* 在Nexus中准备存储库
```
Log in to Nexus from your laptop at http://nexus3-cicd.apps.$GUID.example.opentlc.com with the username admin and password admin123.

In Nexus, create a hosted Maven2 repository called offline:

Click the gear icon and select Repositories → Create Repositories → maven2 (hosted).

Name it offline and click Create Repository

Download the dependencies zip file and extract it to your $HOME/repository directory:

Download the dependencies zip file and extract it to your $HOME/repository directory:

cd $HOME
wget http://admin.na.shared.opentlc.com/openshift-tasks-repository.zip
unzip -o openshift-tasks-repository.zip -d $HOME
This ensures that all of the dependencies are in your Maven repository.

Create the following nexusimport.sh script in $HOME/repository:

cd $HOME/repository
cat << EOF > ./nexusimport.sh
#!/bin/bash

# copy and run this script to the root of the repository directory containing files
# this script attempts to exclude uploading itself explicitly so the script name is important
# Get command line params
while getopts ":r:u:p:" opt; do
  case \$opt in
    r) REPO_URL="\$OPTARG"
    ;;
    u) USERNAME="\$OPTARG"
    ;;
    p) PASSWORD="\$OPTARG"
    ;;
  esac
done

find . -type f \\
 -not -path './mavenimport\.sh*' \\
 -not -path '*/\.*' \\
 -not -path '*/\^archetype\-catalog\.xml*' \\
 -not -path '*/\^maven\-metadata\-local*\.xml' \\
 -not -path '*/\^maven\-metadata\-deployment*\.xml' | \\
 sed "s|^\./||" | \\
 xargs -t -I '{}' curl -s -S -u "\$USERNAME:\$PASSWORD" -X PUT -T {} \${REPO_URL}/{} ;
EOF
This simplifies loading dependencies into Nexus.

Make sure the script is executable:

chmod +x $HOME/repository/nexusimport.sh
Now run the nexusimport.sh script to upload the entire repository into Nexus:

cd $HOME/repository
./nexusimport.sh -u admin -p admin123 -r http://$(oc get route nexus3 --template='{{ .spec.host }}' -n cicd)/repository/offline/

```


# Deploy Gogs

* Create a PostgreSQL database for Gogs:
```bash 


oc project cicd
oc new-app postgresql-persistent --param POSTGRESQL_DATABASE=gogs --param POSTGRESQL_USER=gogs --param POSTGRESQL_PASSWORD=gogs --param VOLUME_CAPACITY=4Gi -lapp=postgresql_gogs
```

* Make sure to wait until postgresql-persistent is running, then create a Gogs template file called $HOME/gogs.yaml with the following content:


```bash
echo 'kind: Template
apiVersion: v1
metadata:
  annotations:
    description: The Gogs git server. Requires a PostgreSQL database.
    tags: instant-app,gogs,datastore
    iconClass: icon-github
  name: gogs
objects:
- kind: Service
  apiVersion: v1
  metadata:
    annotations:
      description: The Gogs servers http port
    labels:
      app: ${APPLICATION_NAME}
    name: ${APPLICATION_NAME}
  spec:
    ports:
    - name: 3000-tcp
      port: 3000
      protocol: TCP
      targetPort: 3000
    selector:
      app: ${APPLICATION_NAME}
      deploymentconfig: ${APPLICATION_NAME}
    sessionAffinity: None
    type: ClusterIP
- kind: Route
  apiVersion: v1
  id: ${APPLICATION_NAME}-http
  metadata:
    annotations:
      description: Route for applications http service.
    labels:
      app: ${APPLICATION_NAME}
    name: ${APPLICATION_NAME}
  spec:
    host: ${GOGS_ROUTE}
    to:
      name: ${APPLICATION_NAME}
- kind: DeploymentConfig
  apiVersion: v1
  metadata:
    labels:
      app: ${APPLICATION_NAME}
    name: ${APPLICATION_NAME}
  spec:
    replicas: 1
    selector:
      app: ${APPLICATION_NAME}
      deploymentconfig: ${APPLICATION_NAME}
    strategy:
      rollingParams:
        intervalSeconds: 1
        maxSurge: 25%
        maxUnavailable: 25%
        timeoutSeconds: 600
        updatePeriodSeconds: 1
      type: Rolling
    template:
      metadata:
        labels:
          app: ${APPLICATION_NAME}
          deploymentconfig: ${APPLICATION_NAME}
      spec:
        containers:
        - image: \"\"
          imagePullPolicy: Always
          name: ${APPLICATION_NAME}
          ports:
          - containerPort: 3000
            protocol: TCP
          resources: {}
          terminationMessagePath: /dev/termination-log
          volumeMounts:
          - name: gogs-data
            mountPath: /data
          - name: gogs-config
            mountPath: /opt/gogs/custom/conf
          readinessProbe:
              httpGet:
                path: /
                port: 3000
                scheme: HTTP
              initialDelaySeconds: 3
              timeoutSeconds: 1
              periodSeconds: 20
              successThreshold: 1
              failureThreshold: 3
          livenessProbe:
              httpGet:
                path: /
                port: 3000
                scheme: HTTP
              initialDelaySeconds: 3
              timeoutSeconds: 1
              periodSeconds: 10
              successThreshold: 1
              failureThreshold: 3
        dnsPolicy: ClusterFirst
        restartPolicy: Always
        terminationGracePeriodSeconds: 30
        volumes:
        - name: gogs-data
          persistentVolumeClaim:
            claimName: gogs-data
        - name: gogs-config
          configMap:
            name: gogs-config
            items:
              - key: app.ini
                path: app.ini
    test: false
    triggers:
    - type: ConfigChange
    - imageChangeParams:
        automatic: true
        containerNames:
        - ${APPLICATION_NAME}
        from:
          kind: ImageStreamTag
          name: ${GOGS_IMAGE}
          namespace: openshift
      type: ImageChange
- kind: PersistentVolumeClaim
  apiVersion: v1
  metadata:
    name: gogs-data
    annotations:
      volume.beta.kubernetes.io/storage-class: "example-nfs"
  spec:
    accessModes:
      - ReadWriteOnce
    resources:
      requests:
        storage: ${GOGS_VOLUME_CAPACITY}
- kind: ConfigMap
  apiVersion: v1
  metadata:
    name: gogs-config
  data:
    app.ini: |
      APP_NAME = Gogs
      RUN_MODE = prod
      RUN_USER = gogs

      [database]
      DB_TYPE  = postgres
      HOST     = postgresql:5432
      NAME     = ${DATABASE_NAME}
      USER     = ${DATABASE_USER}
      PASSWD   = ${DATABASE_PASSWORD}
      SSL_MODE = disable

      [repository]
      ROOT = /data/repositories

      [server]
      ROOT_URL=http://${GOGS_ROUTE}

      [security]
      INSTALL_LOCK = true

      [mailer]
      ENABLED = false

      [service]
      ENABLE_CAPTCHA = false
      REGISTER_EMAIL_CONFIRM = false
      ENABLE_NOTIFY_MAIL     = false
      DISABLE_REGISTRATION   = false
      REQUIRE_SIGNIN_VIEW    = false

      [picture]
      DISABLE_GRAVATAR        = false
      ENABLE_FEDERATED_AVATAR = true

      [webhook]
      SKIP_TLS_VERIFY = true
parameters:
- name: APPLICATION_NAME
  description: The name for the application.
  required: true
  value: gogs
- name: GOGS_ROUTE
  description: The route for the Gogs Application
  required: true
- name: GOGS_VOLUME_CAPACITY
  description: Volume space available for data, e.g. 512Mi, 2Gi
  required: true
  value: 4Gi
- name: DATABASE_USER
  displayName: Database Username
  required: true
  value: gogs
- name: DATABASE_PASSWORD
  displayName: Database Password
  required: true
  value: gogs
- name: DATABASE_NAME
  displayName: Database Name
  required: true
  value: gogs
- name: GOGS_IMAGE
  displayName: Gogs Image and tag
  required: true
  value: gogs:latest' > $HOME/gogs.yaml

  oc process -f $HOME/gogs.yaml --param GOGS_ROUTE=gogs-cicd.apps.example.com|oc create -f -
```

* 操作说明 
```txt
Watch oc get pods within the cicd project until the deployment finishes.
使用oc get pods 观察, 确定postgreSQL 和 gogs都已 runing 

When Gogs is running, navigate to the Gogs home page in your browser.
使用浏览器 打开gogs的route地址   oc get route -n cicd 

If you are not sure of the URL, you can determine the route using oc get route -n cicd.
Register yourself as a new user.
注册用户
Log in to Gogs as the user you just registered as.
创建组织 CICDLabs
Once logged in, create an organization named CICDLabs.
在 CICDLabs 下创建 仓库 openshift-tasks
Under the CICDLabs organization, create a repository called openshift-tasks.
不要设置为私有仓库.
Do not change the visibility setting. This repository must be Public.
You have now created an empty source code repository in Gogs that OpenShift has access to. Next, you push code into this repository and build from that code and the dependencies that are in Nexus.
```

``` bash
# Push openshift-tasks Source Code into Gogs
# Clone the openshift-tasks repository from GitHub and push it into the Gogs repository:

cd $HOME
git clone https://github.com/wkulhanek/openshift-tasks.git
cd $HOME/openshift-tasks
# Set up the remote Git repository location in your local Git repository, and push it to Gogs by executing the following:

# git prompts you for your Gogs username and password when you execute the push command—make sure to use the username and  password that you registered in Gogs.

git remote add gogs http://gogs-cicd.apps.example.com/jihongrui/openshift-tasks.git
git push -u gogs master
```

# Run Build from Bastion

* start Building 

```bash
oc new-project tasks
oc new-app eap70-basic-s2i \
--param MAVEN_MIRROR_URL=http://nexus3.cicd.svc.cluster.local:8081/repository/offline \
--param SOURCE_REPOSITORY_URL=http://gogs.cicd.svc.cluster.local:3000/CICDLabs/openshift-tasks \
--param SOURCE_REPOSITORY_REF=master \
--param CONTEXT_DIR= --param APPLICATION_NAME=tasks
```

* oc logs -f tasks-1-build



oc run shelly  --image=registry.example.com:5000/busybox:latest --command=true -- sh -c 'while true; do sleep 1; done'

oc run shelly --image=registry.example.com:5000/openshift3/ose-deployer:v3.9 --command=true -- bash -c 'while true; do sleep 1; done'



http://gogs-cicd.apps.example.com/jihongrui/openshift-tasks.git

http://nexus3-cicd.apps.example.com/repository/offline/