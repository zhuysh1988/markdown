# CICD TOOLS INSTALLD

##  架构

dev_user
   |
   |
git(gogs) ---- jenkins 
                   |
                   |
                SonarQube
                   |
                   |
                Maven ---- Nexus 


## 1. Set Up Nexus
```
Sonatype provides a Nexus 3 image labeled sonatype/nexus3:latest in DockerHub.

Use the Recreate deployment strategy rather than Rolling to set up Nexus.

Nexus requires a large amount of memory. It is suggested that you set the memory request to 1Gi and the memory limit to 2Gi.

The Nexus 3 image defines a VOLUME at /nexus-data.
```
### 1.1 Follow these steps to set up Nexus:

>Deploy the Nexus container image and create a route to the Nexus service. Because you are making a few changes to the deployment configuration, you may want to pause the automatic deployment upon configuration changes.
```bash
oc new-app sonatype/nexus3:latest
oc expose svc nexus3
oc rollout pause dc nexus3
```
### 1.2 Change the deployment strategy from Rolling to Recreate and set requests and limits for memory.
```bash
oc patch dc nexus3 --patch='{ "spec": { "strategy": { "type": "Recreate" }}}'
oc set resources dc nexus3 --limits=memory=2Gi --requests=memory=1Gi
```
### 1.3 Create a persistent volume claim (PVC) and mount it at /nexus-data.
```bash
echo "apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nexus-pvc
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 4Gi" | oc create -f -

oc set volume dc/nexus3 --add --overwrite --name=nexus3-volume-1 --mount-path=/nexus-data/ --type persistentVolumeClaim --claim-name=nexus-pvc
```

### 1.4 Set up liveness and readiness probes for Nexus.
```bash
oc set probe dc/nexus3 --liveness --failure-threshold 3 --initial-delay-seconds 60 -- echo ok
oc set probe dc/nexus3 --readiness --failure-threshold 3 --initial-delay-seconds 60 --get-url=http://:8081/repository/maven-public/
```
### 1.5 Finally, resume deployment of the Nexus deployment configuration to roll out all changes at once.
```bash
oc rollout resume dc nexus3
```
### 1.6  Configure Nexus

> Once Nexus is deployed, set up your Nexus repository using the provided script. Use the Nexus 3 default user ID (admin) and password (admin123):
```bash

curl -o setup_nexus3.sh -s https://raw.githubusercontent.com/wkulhanek/ocp_advanced_development_resources/master/nexus/setup_nexus3.sh
chmod +x setup_nexus3.sh
./setup_nexus3.sh admin admin123 http://$(oc get route nexus3 --template='{{ .spec.host }}')

rm setup_nexus3.sh
```
* This script creates:
```
A few Maven proxy repositories to cache Red Hat and JBoss dependencies.

A maven-all-public group repository that contains the proxy repositories for all of the required artifacts.

An NPM proxy repository to cache Node.JS build artifacts.

A private Docker registry.

A releases repository for the WAR files that are produced by your pipeline.

A Docker registry in Nexus listening on port 5000. OpenShift does not know about this additional endpoint, so you need to create an additional route that exposes the Nexus Docker registry for your use.
```
* Create a Service called nexus-registry that exposes port 5000 from the deployment configuration nexus3.

* Create an OpenShift route called nexus-registry that uses edge termination for the TLS encryption and exposes port 5000.
```bash

oc expose dc nexus3 --port=5000 --name=nexus-registry
oc create route edge nexus-registry --service=nexus-registry --port=5000
```
* Confirm your routes:
```bash
oc get routes -n xyz-nexus
```
* Sample Output
```
NAME             HOST/PORT                                               PATH      SERVICES         PORT       TERMINATION   WILDCARD
nexus-registry   nexus-registry-xyz-nexus.apps.na39.openshift.opentlc.com              nexus-registry   5000       edge          None
nexus3           nexus3-xyz-nexus.apps.na39.openshift.opentlc.com                      nexus3           8081-tcp                 None
```


## 2. Set Up SonarQube

### 2.1 Deploy a persistent PostgreSQL database
```bash
oc new-app --template=postgresql-persistent --param POSTGRESQL_USER=sonar --param POSTGRESQL_PASSWORD=sonar --param POSTGRESQL_DATABASE=sonar --param VOLUME_CAPACITY=4Gi --labels=app=sonarqube_db
```
* 确定 sonarqube_db 成功启动

### 2.2 Deploy the SonarQube image (wkulhanek/sonarqube:6.7.4) available in DockerHub
```bash
# The source for the Docker image is located at https://github.com/wkulhanek/docker-openshift-sonarqube.git.
oc new-app --docker-image=wkulhanek/sonarqube:6.7.4 --env=SONARQUBE_JDBC_USERNAME=sonar --env=SONARQUBE_JDBC_PASSWORD=sonar --env=SONARQUBE_JDBC_URL=jdbc:postgresql://postgresql/sonar --labels=app=sonarqube

```
### 2.3 Create a route for SonarQube.
```bash
oc rollout pause dc sonarqube
oc expose service sonarqube
```
### 2.4 Create a PVC and mount it at /opt/sonarqube/data
```bash
echo "apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: sonarqube-pvc
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 4Gi" | oc create -f -
oc set volume dc/sonarqube --add --overwrite --name=sonarqube-volume-1 --mount-path=/opt/sonarqube/data/ --type persistentVolumeClaim --claim-name=sonarqube-pvc
```

### 2.5 Set the resources.
```txt
SonarQube is a heavy application. The following parameters are suggested:

Memory request: 1.5Gi

Memory limit: 3Gi

CPU request: 1 CPU

CPU limit: 2 CPUs

Set the deployment strategy.

Because SonarQube is using Elasticsearch under the covers, it needs a Recreate deployment strategy rather than the default Rolling deployment strategy.

```
```bash
oc set resources dc/sonarqube --limits=memory=3Gi,cpu=2 --requests=memory=2Gi,cpu=1
oc patch dc sonarqube --patch='{ "spec": { "strategy": { "type": "Recreate" }}}'
```

### 2.6 To ensure proper operation of your service, add liveness and readiness probes
```bash
oc set probe dc/sonarqube --liveness --failure-threshold 3 --initial-delay-seconds 40 -- echo ok
oc set probe dc/sonarqube --readiness --failure-threshold 3 --initial-delay-seconds 20 --get-url=http://:9000/about
```

### Finally, resume deployment of the SonarQube deployment configuration to roll out all changes at once.
```bash
oc rollout resume dc sonarqube
```
* Once SonarQube has fully started, log in via the exposed route. The default user ID is admin and password is admin.


## 3. Set Up Gogs


### 3.1 Deploy a PostgreSQL database server with persistent storage.

> There is a postgresql-persistent template available in OpenShift.

> Make sure to add a PostgreSQL user ID, password, and database name when deploying the template.

> Volume claims of up to 4 GB are supported in the environment.
```bash
oc new-app postgresql-persistent --param POSTGRESQL_DATABASE=gogs --param POSTGRESQL_USER=gogs --param POSTGRESQL_PASSWORD=gogs --param VOLUME_CAPACITY=4Gi -lapp=postgresql_gogs
```
### 3.2 Deploy a Gogs server.

> There is a Docker image for Gogs available at wkulhanek/gogs:11.34.
```bash
oc new-app wkulhanek/gogs:11.34 -lapp=gogs

# Add persistent storage for Gogs and attach it to /data.

echo "apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: gogs-data
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 4Gi" | oc create -f -

oc set volume dc/gogs --add --overwrite --name=gogs-volume-1 --mount-path=/data/ --type persistentVolumeClaim --claim-name=gogs-data

# Expose the service as a route and retrieve the generated route.

oc expose svc gogs
oc get route gogs
```
### 3.3 In a web browser, navigate to http://gogsroute where gogsroute is the route you just created.
```
When using the install function of Gogs:

The application URL is http://gogsroute (gogsroute varies based on your environment).

The database host points to the PostgreSQL service on port 5432.

The Run User parameter is set to gogs.

All other database parameters match what you specified when creating the PostgreSQL database.

Set up Gogs with these values:

Database Type: PostgreSQL

Host: postgresql:5432

User: gogs

Password: gogs

Database Name: gogs

Run User: gogs

Application URL: http://gogsroute

Click Install Gogs.
```
### 3.4 Retrieve the configuration file from the Gogs pod and store it in your $HOME directory.

> The location of the configuration file in the container is /opt/gogs/custom/conf/app.ini.
```bash
oc exec $(oc get pod | grep "^gogs" | awk '{print $1}') -- cat /opt/gogs/custom/conf/app.ini >$HOME/app.ini
# Create a ConfigMap using the Gogs configuration file.

oc create configmap gogs --from-file=$HOME/app.ini
# Update the Gogs deployment configuration to mount the ConfigMap as a volume at /opt/gogs/custom/conf.

oc set volume dc/gogs --add --overwrite --name=config-volume -m /opt/gogs/custom/conf/ -t configmap --configmap-name=gogs
```
### 3.5 Wait until the redeployment finishes, then navigate back to the Gogs home page (http://gogsroute).
```
Register a new user—the first registered user becomes the administrator for Gogs.

Log in to Gogs as the user you just registered as.
```
### 3.6 Install openshift-tasks Source Code into Gogs
```
Log in to Gogs and create an organization named CICDLabs.

Under the CICDLabs organization, create a repository called openshift-tasks.

Do not make this a Private repository.

On your client VM, clone the source code from GitHub and push it to Gogs:

Make sure to replace <gogs_user> and <gogs_password> with your credentials.
```
```bash
cd $HOME
git clone https://github.com/wkulhanek/openshift-tasks.git
cd $HOME/openshift-tasks
git remote add gogs http://<gogs_user>:<gogs_password>@$(oc get route gogs -n xyz-gogs --template='{{ .spec.host }}')/CICDLabs/openshift-tasks.git
git push -u gogs master

### 3.7 Set up nexus_settings.xml for local builds, making sure that <url> points to your specific Nexus URL:
```xml
<?xml version="1.0"?>
<settings>
  <mirrors>
    <mirror>
      <id>Nexus</id>
      <name>Nexus Public Mirror</name>
      <url>http://nexus3-xyz-nexus.apps.na39.openshift.opentlc.com/repository/maven-all-public/</url>
      <mirrorOf>*</mirrorOf>
    </mirror>
  </mirrors>
  <servers>
  <server>
    <id>nexus</id>
    <username>admin</username>
    <password>admin123</password>
  </server>
</servers>
</settings>
```

### 3.8 This file is located in the $HOME/openshift-tasks directory.
> Commit and push the updated settings files to Gogs:
```bash
git commit -m "Updated Settings" nexus_settings.xml nexus_openshift_settings.xml
git push gogs master
```




