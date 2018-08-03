

## Syncing Repositories

```bash
#Before you sync with the required repositories, you may need to import the appropriate GPG key:

rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

#If the key is not imported, the indicated package is deleted after syncing the repository.

#To sync the required repositories:

#Register the server with the Red Hat Customer Portal. You must use the login and password associated with the account that has access to the OpenShift Container Platform subscriptions:

subscription-manager register
#Pull the latest subscription data from RHSM:

subscription-manager refresh
#Attach to a subscription that provides OpenShift Container Platform channels. You can find the list of available subscriptions using:

subscription-manager list --available --matches '*OpenShift*'
#Then, find the pool ID for the subscription that provides OpenShift Container Platform, and attach it:

subscription-manager attach --pool=<pool_id>
subscription-manager repos --disable="*"
subscription-manager repos \
    --enable="rhel-7-server-rpms" \
    --enable="rhel-7-server-extras-rpms" \
    --enable="rhel-7-fast-datapath-rpms" \
    --enable="rhel-7-server-ansible-2.4-rpms" \
    --enable="rhel-7-server-ose-3.9-rpms"
#The yum-utils command provides the reposync utility, which lets you mirror yum repositories, and createrepo can create a usable yum repository from a directory:

sudo yum -y install yum-utils createrepo docker git
#您需要高达110GB的可用空间才能同步软件。根据组织策略的限制程度，您可以将此服务器重新连接到断开连接的局域网，并将其用作存储库服务器。您可以使用USB连接存储并将软件传输到另一台充当存储库服务器的服务器。本主题涵盖了这些选项。

#Make a path to where you want to sync the software (either locally or on your USB or other device):

mkdir -p </path/to/repos>
#Sync the packages and create the repository for each of them. You will need to modify the command for the appropriate path you created above:

for repo in \
rhel-7-server-rpms \
rhel-7-server-extras-rpms \
rhel-7-fast-datapath-rpms \
rhel-7-server-ansible-2.4-rpms \
rhel-7-server-ose-3.9-rpms
do
  reposync --gpgcheck -lm --repoid=${repo} --download_path=/path/to/repos
  createrepo -v </path/to/repos/>${repo} -o </path/to/repos/>${repo}
done

```


## Syncing Images
* To sync the container images:
```bash
#Start the Docker daemon:

systemctl start docker
#Pull all of the required OpenShift Container Platform containerized components. Replace $tag with v3.9.31 for the latest version.
tag='v3.9'
docker pull registry.access.redhat.com/openshift3/ose-recycler:$tag
docker pull registry.access.redhat.com/openshift3/ose-ansible:$tag
docker pull registry.access.redhat.com/openshift3/ose-cluster-capacity:$tag
docker pull registry.access.redhat.com/openshift3/ose-deployer:$tag
docker pull registry.access.redhat.com/openshift3/ose-docker-builder:$tag
docker pull registry.access.redhat.com/openshift3/ose-docker-registry:$tag
docker pull registry.access.redhat.com/openshift3/ose-egress-http-proxy:$tag
docker pull registry.access.redhat.com/openshift3/ose-egress-router:$tag
docker pull registry.access.redhat.com/openshift3/ose-f5-router:$tag
docker pull registry.access.redhat.com/openshift3/ose-haproxy-router:$tag
docker pull registry.access.redhat.com/openshift3/ose-keepalived-ipfailover:$tag
docker pull registry.access.redhat.com/openshift3/ose-pod:$tag
docker pull registry.access.redhat.com/openshift3/ose-sti-builder:$tag
docker pull registry.access.redhat.com/openshift3/ose-template-service-broker:$tag
docker pull registry.access.redhat.com/openshift3/ose-web-console:$tag
docker pull registry.access.redhat.com/openshift3/ose:$tag
docker pull registry.access.redhat.com/openshift3/container-engine:$tag
docker pull registry.access.redhat.com/openshift3/node:$tag
docker pull registry.access.redhat.com/openshift3/openvswitch:$tag
docker pull registry.access.redhat.com/rhel7/etcd

#If you are using NFS, you need the ose-recycler image. Otherwise, the volumes will not recycle, potentially causing errors.

#Pull all of the required OpenShift Container Platform containerized components for the additional centralized log aggregation and metrics aggregation components. Replace $tag with v3.9.31 for the latest version.

docker pull registry.access.redhat.com/openshift3/logging-auth-proxy:$tag
docker pull registry.access.redhat.com/openshift3/logging-curator:$tag
docker pull registry.access.redhat.com/openshift3/logging-elasticsearch:$tag
docker pull registry.access.redhat.com/openshift3/logging-fluentd:$tag
docker pull registry.access.redhat.com/openshift3/logging-kibana:$tag
docker pull registry.access.redhat.com/openshift3/oauth-proxy:$tag
docker pull registry.access.redhat.com/openshift3/metrics-cassandra:$tag
docker pull registry.access.redhat.com/openshift3/metrics-hawkular-metrics:$tag
docker pull registry.access.redhat.com/openshift3/metrics-hawkular-openshift-agent:$tag
docker pull registry.access.redhat.com/openshift3/metrics-heapster:$tag
docker pull registry.access.redhat.com/openshift3/prometheus:$tag
docker pull registry.access.redhat.com/openshift3/prometheus-alert-buffer:$tag
docker pull registry.access.redhat.com/openshift3/prometheus-alertmanager:$tag
docker pull registry.access.redhat.com/openshift3/prometheus-node-exporter:$tag
docker pull registry.access.redhat.com/cloudforms46/cfme-openshift-postgresql:$tag
docker pull registry.access.redhat.com/cloudforms46/cfme-openshift-memcached:$tag
docker pull registry.access.redhat.com/cloudforms46/cfme-openshift-app-ui:$tag
docker pull registry.access.redhat.com/cloudforms46/cfme-openshift-app:$tag
docker pull registry.access.redhat.com/cloudforms46/cfme-openshift-embedded-ansible:$tag
docker pull registry.access.redhat.com/cloudforms46/cfme-openshift-httpd:$tag
docker pull registry.access.redhat.com/cloudforms46/cfme-httpd-configmap-generator:$tag
docker pull registry.access.redhat.com/rhgs3/rhgs-server-rhel7:$tag
docker pull registry.access.redhat.com/rhgs3/rhgs-volmanager-rhel7:$tag
docker pull registry.access.redhat.com/rhgs3/rhgs-gluster-block-prov-rhel7:$tag
docker pull registry.access.redhat.com/rhgs3/rhgs-s3-server-rhel7:$tag

#Prometheus on OpenShift Container Platform is a Technology Preview feature only. Technology Preview features are not supported with Red Hat production service level agreements (SLAs), might not be functionally complete, and Red Hat does not recommend to use them for production. These features provide early access to upcoming product features, enabling customers to test functionality and provide feedback during the development process.

#For more information on Red Hat Technology Preview features support scope, see https://access.redhat.com/support/offerings/techpreview/.

#For the service catalog, OpenShift Ansible broker, and template service broker features (as described in Advanced Installation), pull the following images. Replace $tag with v3.9.31 for the latest version.

docker pull registry.access.redhat.com/openshift3/ose-service-catalog:$tag
docker pull registry.access.redhat.com/openshift3/ose-ansible-service-broker:$tag
docker pull registry.access.redhat.com/openshift3/mediawiki-apb:$tag
docker pull registry.access.redhat.com/openshift3/postgresql-apb:$tag

```
> Pull the Red Hat-certified Source-to-Image (S2I) builder images that you intend to use in your OpenShift environment. 

* You can pull the following images:
```
jboss-eap70-openshift

jboss-amq-62

jboss-datagrid65-openshift

jboss-decisionserver62-openshift

jboss-eap64-openshift

jboss-eap70-openshift

jboss-webserver30-tomcat7-openshift

jboss-webserver30-tomcat8-openshift

jenkins-1-rhel7

jenkins-2-rhel7

jenkins-slave-base-rhel7

jenkins-slave-maven-rhel7

jenkins-slave-nodejs-rhel7

mongodb

mysql

nodejs

perl

php

postgresql

python

redhat-sso70-openshift

ruby

```
> Make sure to indicate the correct tag specifying the desired version number. For example, to pull both the previous and latest version of the Tomcat image:
```
docker pull \
registry.access.redhat.com/jboss-webserver-3/webserver30-tomcat7-openshift:latest
docker pull \
registry.access.redhat.com/jboss-webserver-3/webserver30-tomcat7-openshift:1.1
```
> If you are using a stand-alone registry or plan to enable the registry console with the integrated registry, you must pull the registry-console image.

> Replace <tag> with v3.9.31 for the latest version.
```
docker pull registry.access.redhat.com/openshift3/registry-console:<tag>
```


## Preparing Images for Export
> Container images can be exported from a system by first saving them to a tarball and then transporting them:
```bash
#Make and change into a repository home directory:

mkdir </path/to/repos/images>
cd </path/to/repos/images>
#Export the OpenShift Container Platform containerized components:

docker save -o ose3-images.tar \
    registry.access.redhat.com/openshift3/ose-ansible \
    registry.access.redhat.com/openshift3/ose-ansible-service-broker \
    registry.access.redhat.com/openshift3/ose-cluster-capacity \
    registry.access.redhat.com/openshift3/ose-deployer \
    registry.access.redhat.com/openshift3/ose-docker-builder \
    registry.access.redhat.com/openshift3/ose-docker-registry \
    registry.access.redhat.com/openshift3/ose-egress-http-proxy \
    registry.access.redhat.com/openshift3/ose-egress-router \
    registry.access.redhat.com/openshift3/ose-f5-router \
    registry.access.redhat.com/openshift3/ose-haproxy-router \
    registry.access.redhat.com/openshift3/ose-keepalived-ipfailover \
    registry.access.redhat.com/openshift3/ose-pod \
    registry.access.redhat.com/openshift3/ose-sti-builder \
    registry.access.redhat.com/openshift3/ose-template-service-broker \
    registry.access.redhat.com/openshift3/ose-web-console \
    registry.access.redhat.com/openshift3/ose \
    registry.access.redhat.com/openshift3/container-engine \
    registry.access.redhat.com/openshift3/node \
    registry.access.redhat.com/openshift3/openvswitch \
    registry.access.redhat.com/openshift3/prometheus \
    registry.access.redhat.com/openshift3/prometheus-alert-buffer \
    registry.access.redhat.com/openshift3/prometheus-alertmanager \
    registry.access.redhat.com/openshift3/prometheus-node-exporter \
    registry.access.redhat.com/cloudforms46/cfme-openshift-postgresql \
    registry.access.redhat.com/cloudforms46/cfme-openshift-memcached \
    registry.access.redhat.com/cloudforms46/cfme-openshift-app-ui \
    registry.access.redhat.com/cloudforms46/cfme-openshift-app \
    registry.access.redhat.com/cloudforms46/cfme-openshift-embedded-ansible \
    registry.access.redhat.com/cloudforms46/cfme-openshift-httpd \
    registry.access.redhat.com/cloudforms46/cfme-httpd-configmap-generator \
    registry.access.redhat.com/rhgs3/rhgs-server-rhel7 \
    registry.access.redhat.com/rhgs3/rhgs-volmanager-rhel7 \
    registry.access.redhat.com/rhgs3/rhgs-gluster-block-prov-rhel7 \
    registry.access.redhat.com/rhgs3/rhgs-s3-server-rhel7
#If you synchronized the metrics and log aggregation images, export:

docker save -o ose3-logging-metrics-images.tar \
    registry.access.redhat.com/openshift3/logging-auth-proxy \
    registry.access.redhat.com/openshift3/logging-curator \
    registry.access.redhat.com/openshift3/logging-elasticsearch \
    registry.access.redhat.com/openshift3/logging-fluentd \
    registry.access.redhat.com/openshift3/logging-kibana \
    registry.access.redhat.com/openshift3/metrics-cassandra \
    registry.access.redhat.com/openshift3/metrics-hawkular-metrics \
    registry.access.redhat.com/openshift3/metrics-hawkular-openshift-agent \
    registry.access.redhat.com/openshift3/metrics-heapster
#Export the S2I builder images that you synced in the previous section. For example, if you synced only the Jenkins and Tomcat images:

docker save -o ose3-builder-images.tar \
    registry.access.redhat.com/jboss-webserver-3/webserver30-tomcat7-openshift:latest \
    registry.access.redhat.com/jboss-webserver-3/webserver30-tomcat7-openshift:1.1 \
    registry.access.redhat.com/openshift3/jenkins-1-rhel7 \
    registry.access.redhat.com/openshift3/jenkins-2-rhel7 \
    registry.access.redhat.com/openshift3/jenkins-slave-base-rhel7 \
    registry.access.redhat.com/openshift3/jenkins-slave-maven-rhel7 \
    registry.access.redhat.com/openshift3/jenkins-slave-nodejs-rhel7
```


[rhel-7-server-rpms]
name=rhel-7-server-rpms
baseurl=http://yum.example.com/repos/rhel-7-server-rpms
enabled=1
gpgcheck=0
[rhel-7-server-extras-rpms]
name=rhel-7-server-extras-rpms
baseurl=http://yum.example.com/repos/rhel-7-server-extras-rpms
enabled=1
gpgcheck=0
[rhel-7-fast-datapath-rpms]
name=rhel-7-fast-datapath-rpms
baseurl=http://yum.example.com/repos/rhel-7-fast-datapath-rpms
enabled=1
gpgcheck=0
[rhel-7-server-ansible-2.4-rpms]
name=rhel-7-server-ansible-2.4-rpms
baseurl=http://yum.example.com/repos/rhel-7-server-ansible-2.4-rpms
enabled=1
gpgcheck=0
[rhel-7-server-ose-3.9-rpms]
name=rhel-7-server-ose-3.9-rpms
baseurl=http://yum.example.com/repos/rhel-7-server-ose-3.9-rpms
enabled=1
gpgcheck=0


192.168.4.130	haproxy.example.com
192.168.4.131	master01.example.com
192.168.4.132	master02.example.com
192.168.4.133	master03.example.com
192.168.4.134	node01.example.com
192.168.4.135	node02.example.com
192.168.4.136	registry.example.com
