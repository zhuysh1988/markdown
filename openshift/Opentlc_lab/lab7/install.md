



## nfs Config 
/srv/nfs      	<world>(rw,sync,no_wdelay,hide,no_subtree_check,sec=sys,secure,root_squash,no_all_squash)



# Config registry node 

## install docker-distribution 
```bash
yum install -y docker-distribution skopeo jq

# config storage for registry 
#sed -i 's/^.*rootdirectory.*$/        rootdirectory: \/srv\/repohost\/registry/' /etc/docker-distribution/registry/config.yml

# config logs
cat << EOF >> /etc/docker-distribution/registry/config.yml
log:
  accesslog:
    disabled: false
  level: info
  formatter: text
  fields:
    service: registry
    environment: staging
EOF


#mkdir -p /srv/repohost/registry
systemctl enable docker-distribution
systemctl start docker-distribution
systemctl status docker-distribution

```

## download redhat images to local registry 

* vi download_image_for_ocp39.sh

```bash
RHT_TAG=v3.9.14
LOCAL_TAG=v3.9.14

IMAGES_SAME_PATCH="ose-ansible ose-cluster-capacity ose-deployer ose-docker-builder ose-docker-registry ose-egress-http-proxy ose-egress-router ose-haproxy-router ose-pod ose-sti-builder ose container-engine efs-provisioner node openvswitch oauth-proxy logging-auth-proxy logging-curator logging-elasticsearch logging-fluentd logging-kibana metrics-cassandra metrics-hawkular-metrics metrics-heapster oauth-proxy ose ose-service-catalog prometheus-alert-buffer prometheus-alertmanager prometheus registry-console ose-web-console ose-template-service-broker ose-ansible-service-broker logging-deployer metrics-deployer ose-service-catalog mediawiki-apb postgresql-apb mariadb-apb mysql-apb"

time for image in ${IMAGES_SAME_PATCH}
do
  latest_version=`skopeo inspect --tls-verify=false docker://registry.access.redhat.com/openshift3/$image | jq ".RepoTags | map(select(startswith((\"${RHT_TAG}\")))) |.[] "| sort -V | tail -1 | tr -d '"'`
  if [[ "$latest_version" == "" ]]; then latest_version='latest';fi
  echo "Copying image: $image version: $latest_version"
  skopeo copy --dest-tls-verify=false docker://registry.access.redhat.com/openshift3/${image}:${latest_version} docker://localhost:5000/openshift3/${image}:${LOCAL_TAG}
  echo "Copied image: $image version: $latest_version"
done

# 7 minutes
RHT_TAG='latest'
LOCAL_TAG='v3.9.14'
IMAGES_LATEST_TO_PATCH="ose-recycler prometheus-node-exporter"

time for image in ${IMAGES_LATEST_TO_PATCH}
do
  latest_version=`skopeo inspect --tls-verify=false docker://registry.access.redhat.com/openshift3/$image | jq ".RepoTags | map(select(startswith((\"${RHT_TAG}\")))) |.[] "| sort -V | tail -1 | tr -d '"'`
  if [[ "$latest_version" == "" ]]; then latest_version='latest';fi
  echo "Copying image: $image version: $latest_version"
  skopeo copy --dest-tls-verify=false docker://registry.access.redhat.com/openshift3/${image}:${latest_version} docker://localhost:5000/openshift3/${image}:${LOCAL_TAG} &
done


RHT_TAG='v3.9'
LOCAL_TAG='latest'

# Latest tags point to older releases. Need to use version-specific tag::
IMAGES_MAJOR_LATEST="jenkins-2-rhel7 jenkins-slave-base-rhel7 jenkins-slave-maven-rhel7 jenkins-slave-nodejs-rhel7"
time for image in ${IMAGES_MAJOR_LATEST}
do
  latest_version=`skopeo inspect --tls-verify=false docker://registry.access.redhat.com/openshift3/$image | jq ".RepoTags | map(select(startswith((\"${RHT_TAG}\")))) |.[] "| sort -V | tail -1 | tr -d '"'`
  if [[ "$latest_version" == "" ]]; then latest_version='latest';fi
  echo "Copying image: $image version: $latest_version"
  skopeo copy --dest-tls-verify=false docker://registry.access.redhat.com/openshift3/${image}:${latest_version} docker://localhost:5000/openshift3/${image}:${LOCAL_TAG}
done


# Nexus and Gogs (latest) from docker.io
for image in sonatype/nexus3 wkulhanek/gogs
do
  skopeo copy --dest-tls-verify=false docker://docker.io/${image}:latest docker://localhost:5000/${image}:latest
done

# from registry.access.redhat.com
for image in rhel7/etcd rhscl/postgresql-96-rhel7 jboss-eap-7/eap70-openshift
do
  skopeo copy --dest-tls-verify=false docker://registry.access.redhat.com/$image:latest docker://localhost:5000/${image}:latest
done
```

* run shell scripts 
```
nohup /bin/bash -x download_image_for_ocp39.sh & 
```

# Check all cluster


```bash
## check nodes docker is runing
ansible nodes -mshell -a'systemctl status docker| grep Active'

## check all nodes yum repo is ok 
ansible all -mshell -a'yum repolist -v| grep baseurl'

```

# Config NFS Server

```

mkdir -p /srv/nfs/storage
echo /srv/nfs/storage *(rw,root_squash) >> /etc/exports.d/openshift-storage.exports
chown -R nfsnobody.nfsnobody  /srv/nfs
chmod -R 777 /srv/nfs


mkdir -p /data/nfs/pv{1..5}

for pvnum in {1..5};do
echo "/data/nfs/pv${pvnum} *(rw,root_squash) " >> /etc/exports.d/openshift-uservols.exports
chown -R nfsnobody.nfsnobody  /data/nfs
chmod -R 777 /data/nfs
done

systemctl restart nfs-server
```


# deploy cluster 
## deploy check cluster
```bash
ansible-playbook -f 20 /usr/share/ansible/openshift-ansible/playbooks/prerequisites.yml
```

## deploy cluster 
```bash
ansible-playbook -f 20 /usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml

```




## deploy CI/CD 

```bash
oc import-image docker-registry.default.svc:5000/gogs:latest --from=isolated1.$GUID.internal:5000/wkulhanek/gogs:latest --confirm --insecure=true -n openshift

oc import-image docker-registry.default.svc:5000/sonatype/nexus3:latest --from=isolated1.$GUID.internal:5000/sonatype/nexus3:latest --confirm --insecure=true -n openshift

oc import-image docker-registry.default.svc:5000/rhscl/postgresql:latest --from=isolated1.$GUID.internal:5000/rhscl/postgresql-96-rhel7:latest --confirm --insecure=true -n openshift
oc tag postgresql:latest postgresql:9.6 -n openshift

oc import-image docker-registry.default.svc:5000/openshift/jboss-eap70-openshift:latest --from=isolated1.$GUID.internal:5000/jboss-eap-7/eap70-openshift:latest --confirm --insecure=true -n openshift
oc tag jboss-eap70-openshift:latest jboss-eap70-openshift:1.7 -n openshift
```


## Deploy Nexus3

```
oc new-project cicd
echo "apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nexus-pvc
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi" | oc create -f -
oc new-app openshift/nexus3:latest
oc rollout pause dc nexus3
oc patch dc nexus3 --patch='{ "spec": { "strategy": { "type": "Recreate" }}}'
oc set resources dc nexus3 --limits=memory=2Gi --requests=memory=1Gi

oc set volume dc/nexus3 --add --overwrite --name=nexus3-volume-1 --mount-path=/nexus-data/ --type persistentVolumeClaim --claim-name=nexus-pvc
oc set probe dc/nexus3 --liveness --failure-threshold 3 --initial-delay-seconds 60 -- echo ok
oc set probe dc/nexus3 --readiness --failure-threshold 3 --initial-delay-seconds 60 --get-url=http://:8081/repository/maven-public/
oc rollout resume dc nexus3
oc expose svc nexus3

```



