LOCAL_TAG=v3.9.14
LOCAL_TAG=v3.9.14

IMAGES_SAME_PATCH="ose-ansible ose-cluster-capacity ose-deployer ose-docker-builder ose-docker-registry ose-egress-http-proxy ose-egress-router ose-haproxy-router ose-pod ose-sti-builder ose container-engine efs-provisioner node openvswitch oauth-proxy logging-auth-proxy logging-curator logging-elasticsearch logging-fluentd logging-kibana metrics-cassandra metrics-hawkular-metrics metrics-heapster oauth-proxy ose ose-service-catalog prometheus-alert-buffer prometheus-alertmanager prometheus registry-console ose-web-console ose-template-service-broker ose-ansible-service-broker logging-deployer metrics-deployer ose-service-catalog mediawiki-apb postgresql-apb mariadb-apb mysql-apb"

time for image in ${IMAGES_SAME_PATCH}
do
#  latest_version=`skopeo inspect --tls-verify=false docker://registry.example.com:5000/openshift3/$image | jq ".RepoTags | map(select(startswith((\"${LOCAL_TAG}\")))) |.[] "| sort -V | tail -1 | tr -d '"'`
  if [[ "$LOCAL_TAG" == "" ]]; then latest_version='latest';fi
  echo "Copying image: $image version: $LOCAL_TAG"
  skopeo copy --src-tls-verify=false --dest-tls-verify=false docker://registry.example.com:5000/openshift3/${image}:${LOCAL_TAG} docker://localhost:5000/openshift3/${image}:${LOCAL_TAG}
  echo "Copied image: $image version: $LOCAL_TAG"
done

# 7 minutes
LOCAL_TAG='latest'
LOCAL_TAG='v3.9.14'
IMAGES_LATEST_TO_PATCH="ose-recycler prometheus-node-exporter"

time for image in ${IMAGES_LATEST_TO_PATCH}
do
#  latest_version=`skopeo inspect --tls-verify=false docker://registry.example.com:5000/openshift3/$image | jq ".RepoTags | map(select(startswith((\"${LOCAL_TAG}\")))) |.[] "| sort -V | tail -1 | tr -d '"'`
  if [[ "$LOCAL_TAG" == "" ]]; then latest_version='latest';fi
  echo "Copying image: $image version: $LOCAL_TAG"
  skopeo copy --src-tls-verify=false --src-tls-verify=false --dest-tls-verify=false docker://registry.example.com:5000/openshift3/${image}:${LOCAL_TAG} docker://localhost:5000/openshift3/${image}:${LOCAL_TAG} &
done


LOCAL_TAG='v3.9'
LOCAL_TAG='latest'

# Latest tags point to older releases. Need to use version-specific tag::
IMAGES_MAJOR_LATEST="jenkins-2-rhel7 jenkins-slave-base-rhel7 jenkins-slave-maven-rhel7 jenkins-slave-nodejs-rhel7"
time for image in ${IMAGES_MAJOR_LATEST}
do
#  latest_version=`skopeo inspect --tls-verify=false docker://registry.example.com:5000/openshift3/$image | jq ".RepoTags | map(select(startswith((\"${LOCAL_TAG}\")))) |.[] "| sort -V | tail -1 | tr -d '"'`
  if [[ "$LOCAL_TAG" == "" ]]; then latest_version='latest';fi
  echo "Copying image: $image version: $LOCAL_TAG"
  skopeo copy --src-tls-verify=false --dest-tls-verify=false docker://registry.example.com:5000/openshift3/${image}:${LOCAL_TAG} docker://localhost:5000/openshift3/${image}:${LOCAL_TAG}
done


# Nexus and Gogs (latest) from docker.io
for image in sonatype/nexus3 wkulhanek/gogs
do
  skopeo copy --src-tls-verify=false --dest-tls-verify=false docker://docker.io/${image}:latest docker://localhost:5000/${image}:latest
done

# from registry.example.com:5000
for image in rhel7/etcd rhscl/postgresql-96-rhel7 jboss-eap-7/eap70-openshift
do
  skopeo copy --src-tls-verify=false --dest-tls-verify=false docker://registry.example.com:5000/$image:latest docker://localhost:5000/${image}:latest
done