# How Config And Install Public Services In OCP3.9 

## nexus3 
* a maven repo and proxy app
```bash
# create imagestorm
oc create is nexus3 
# import image to imagestorm nexus3 
oc import-image nexus3:latest --from=registry.example.com:5000/nexus3:latest --insecure=true
# 
oc new-app nexus3
oc expose svc nexus3
oc rollout pause dc nexus3
oc patch dc nexus3 --patch='{ "spec": { "strategy": { "type": "Recreate" }}}'
oc set resources dc nexus3 --limits=memory=2Gi --requests=memory=1Gi

echo "apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nexus-pvc
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 20Gi" | oc create -f -
oc set volume dc/nexus3 --add --overwrite --name=nexus3-volume-1 --mount-path=/nexus-data/ --type persistentVolumeClaim --claim-name=nexus-pvc
oc set probe dc/nexus3 --liveness --failure-threshold 3 --initial-delay-seconds 60 -- echo ok
oc set probe dc/nexus3 --readiness --failure-threshold 3 --initial-delay-seconds 60 --get-url=http://:8081/repository/maven-public/
oc rollout resume dc nexus3
```




oc -n openshift create is sonarqube
oc -n openshift import-image sonarqube:6.7.4 --from=registry.example.com:5000/wkulhanek/sonarqube:6.7.4  --insecure=true
oc new-app sonarqube:6.7.4 --env=SONARQUBE_JDBC_USERNAME=sonar --env=SONARQUBE_JDBC_PASSWORD=sonar --env=SONARQUBE_JDBC_URL=jdbc:postgresql://sonar-db/sonar --labels=app=sonarqube



oc create is gogs
oc import-image gogs:11.34 --from=registry.example.com:5000/wkulhanek/gogs:11.34 --insecure=true


oc new-app postgresql-persistent --param DATABASE_SERVICE_NAME=gogs-db --param POSTGRESQL_DATABASE=gogs --param POSTGRESQL_USER=gogs --param POSTGRESQL_PASSWORD=gogs --param VOLUME_CAPACITY=4Gi -lapp=postgresql_gogs

oc new-app gogs:11.34 -lapp=gogs

echo "apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: gogs-data
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi" | oc create -f -

oc set volume dc/gogs --add --overwrite --name=gogs-volume-1 --mount-path=/data/ --type persistentVolumeClaim --claim-name=gogs-data
oc expose svc gogs

oc exec $(oc get pod | grep "^gogs" | awk '{print $1}') -- cat /opt/gogs/custom/conf/app.ini >$HOME/app.ini


oc create configmap gogs --from-file=$HOME/app.ini


oc set volume dc/gogs --add --overwrite --name=config-volume -m /opt/gogs/custom/conf/ -t configmap --configmap-name=gogs



oc get route gogs  --template='{{ .spec.host }}'