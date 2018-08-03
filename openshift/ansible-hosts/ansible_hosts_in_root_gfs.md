[OSEv3:vars]

###########################################################################
### Ansible Vars
###########################################################################
timeout=60
#ansible_become=yes
ansible_ssh_user=root

openshift_enable_unsupported_configurations=true

openshift_storage_glusterfs_is_native=false
openshift_storage_glusterfs_registry_block_deploy=true
openshift_storage_glusterfs_registry_block_storageclass=true
openshift_storage_glusterfs_registry_block_storageclass_default=true
openshift_storage_glusterfs_registry_heketi_is_native=true
openshift_storage_glusterfs_registry_heketi_executor=ssh
openshift_storage_glusterfs_registry_heketi_ssh_port=22
openshift_storage_glusterfs_registry_heketi_ssh_user=root
openshift_storage_glusterfs_registry_heketi_ssh_sudo=false
openshift_storage_glusterfs_registry_heketi_ssh_keyfile="/root/.ssh/id_rsa"

#openshift_storage_glusterfs_is_native=false
#openshift_storage_glusterfs_block_deploy=false
#openshift_storage_glusterfs_storageclass=true
#openshift_storage_glusterfs_heketi_is_native=true
#openshift_storage_glusterfs_heketi_executor=ssh
#openshift_storage_glusterfs_heketi_ssh_port=22
#openshift_storage_glusterfs_heketi_ssh_user=root
#openshift_storage_glusterfs_heketi_ssh_sudo=false
#openshift_storage_glusterfs_heketi_ssh_keyfile="/root/.ssh/id_rsa"


###########################################################################
### OpenShift Basic Vars
###########################################################################
deployment_type=openshift-enterprise
containerized=false
openshift_disable_check="disk_availability,memory_availability,docker_image_availability"

# default project node selector
osm_default_node_selector='env=app'
openshift_hosted_infra_selector="env=infra"

# Configure node kubelet arguments. pods-per-core is valid in OpenShift Origin 1.3 or OpenShift Container Platform 3.3 and later.
openshift_node_kubelet_args={'pods-per-core': ['10'], 'max-pods': ['250'], 'image-gc-high-threshold': ['85'], 'image-gc-low-threshold': ['75']}

# Configure logrotate scripts
# See: https://github.com/nickhammond/ansible-logrotate
logrotate_scripts=[{"name": "syslog", "path": "/var/log/cron\n/var/log/maillog\n/var/log/messages\n/var/log/secure\n/var/log/spooler\n", "options": ["daily", "rotate 7","size 500M", "compress", "sharedscripts", "missingok"], "scripts": {"postrotate": "/bin/kill -HUP `cat /var/run/syslogd.pid 2> /dev/null` 2> /dev/null || true"}}]

###########################################################################
### OpenShift Optional Vars
###########################################################################

# Enable cockpit
osm_use_cockpit=true
osm_cockpit_plugins=['cockpit-kubernetes']

###########################################################################
### OpenShift Master Vars
###########################################################################

openshift_master_api_port=443
openshift_master_console_port=443

openshift_master_cluster_method=native
openshift_master_cluster_hostname=lb.example.com
openshift_master_cluster_public_hostname=ocp39.example.com
openshift_master_default_subdomain=apps.example.com
#openshift_master_ca_certificate={'certfile': '/root/intermediate_ca.crt', 'keyfile': '/root/intermediate_ca.key'}
openshift_master_overwrite_named_certificates=True

###########################################################################
### OpenShift Network Vars
###########################################################################

osm_cluster_network_cidr=10.254.0.0/16
openshift_portal_net=10.253.0.0/16

#os_sdn_network_plugin_name='redhat/openshift-ovs-multitenant'
#os_sdn_network_plugin_name='redhat/openshift-ovs-subnet'
os_sdn_network_plugin_name='redhat/openshift-ovs-networkpolicy'

##########################################################################
### Disconnected Install Vars
### Requires a docker registry at registry.example.com:5000
###########################################################################
# sets the debug level for all OpenShift components.  Default is 2
#debug_level=8

# used for container-based install, not RPM
system_images_registry=registry.example.com:5000

# https://bugzilla.redhat.com/show_bug.cgi?id=1461465  target release 3.9
#the enterprise registry will not be added to the docker registries.
#also enables insecure registries, somehow.
openshift_docker_ent_reg=''

# https://bugzilla.redhat.com/show_bug.cgi?id=1516534 target release 3.10
#oreg_url=registry.example.com:5000/openshift3/ose-${component}:${version}
oreg_url=registry.example.com:5000/openshift3/ose-${component}:v3.9



openshift_examples_modify_imagestreams=true
openshift_docker_additional_registries=registry.example.com:5000
openshift_docker_insecure_registries=registry.example.com:5000
openshift_docker_blocked_registries=registry.access.redhat.com,docker.io



openshift_metrics_image_prefix=registry.example.com:5000/openshift3/
openshift_metrics_image_version=v3.9
openshift_logging_image_prefix=registry.example.com:5000/openshift3/
openshift_logging_image_version=v3.9
ansible_service_broker_image_prefix=registry.example.com:5000/openshift3/ose-
ansible_service_broker_image_tag=v3.9
ansible_service_broker_etcd_image_prefix=registry.example.com:5000/rhel7/
ansible_service_broker_etcd_image_tag=latest
openshift_service_catalog_image_prefix=registry.example.com:5000/openshift3/ose-
openshift_service_catalog_image_version=v3.9
openshift_cockpit_deployer_prefix=registry.example.com:5000/openshift3/
openshift_cockpit_deployer_version=v3.9
template_service_broker_prefix=registry.example.com:5000/openshift3/ose-
template_service_broker_version=v3.9
openshift_web_console_prefix=registry.example.com:5000/openshift3/ose-
openshift_web_console_version=v3.9
# PROMETHEUS SETTINGS
openshift_prometheus_image_prefix=registry.example.com:5000/openshift3/
openshift_prometheus_image_version=v3.9
openshift_prometheus_alertmanager_image_prefix=registry.example.com:5000/openshift3/
openshift_prometheus_alertmanager_image_version=v3.9
openshift_prometheus_alertbuffer_image_prefix=registry.example.com:5000/openshift3/
openshift_prometheus_alertbuffer_image_version=v3.9
openshift_prometheus_oauth_proxy_image_prefix=registry.example.com:5000/openshift3/
openshift_prometheus_oauth_proxy_image_version=v3.9
openshift_prometheus_node_exporter_image_prefix=registry.example.com:5000/openshift3/
openshift_prometheus_node_exporter_image_version=v3.9


##########################################################################
## OpenShift Authentication Vars
###########################################################################



# htpasswd auth
openshift_master_identity_providers=[{'name': 'htpasswd_auth', 'login': 'true', 'challenge': 'true', 'kind': 'HTPasswdPasswordIdentityProvider', 'filename': '/etc/origin/master/htpasswd'}]
# Defining htpasswd users
#openshift_master_htpasswd_users={'user1': '<pre-hashed password>', 'user2': '<pre-hashed password>'}
# or
openshift_master_htpasswd_file=/root/htpasswd


###########################################################################
### OpenShift Metrics and Logging Vars
###########################################################################

# Enable cluster metrics
openshift_metrics_install_metrics=True

openshift_metrics_storage_kind=dynamic
openshift_metrics_cassanda_pvc_storage_class_name="glusterfs-registry-block"


openshift_metrics_cassandra_nodeselector={"env":"infra"}
openshift_metrics_hawkular_nodeselector={"env":"infra"}
openshift_metrics_heapster_nodeselector={"env":"infra"}

## Add Prometheus Metrics:
openshift_hosted_prometheus_deploy=true
openshift_prometheus_node_selector={"env":"infra"}
openshift_prometheus_namespace=openshift-metrics

# Prometheus
openshift_prometheus_storage_kind=nfs
openshift_prometheus_storage_access_modes=['ReadWriteOnce']
openshift_prometheus_storage_nfs_directory=/srv/nfs/storage
openshift_prometheus_storage_nfs_options='*(rw,root_squash)'
openshift_prometheus_storage_volume_name=prometheus
openshift_prometheus_storage_volume_size=10Gi
openshift_prometheus_storage_labels={'storage': 'prometheus'}
openshift_prometheus_storage_type='pvc'
# For prometheus-alertmanager
openshift_prometheus_alertmanager_storage_kind=nfs
openshift_prometheus_alertmanager_storage_access_modes=['ReadWriteOnce']
openshift_prometheus_alertmanager_storage_nfs_directory=/srv/nfs/storage
openshift_prometheus_alertmanager_storage_nfs_options='*(rw,root_squash)'
openshift_prometheus_alertmanager_storage_volume_name=prometheus-alertmanager
openshift_prometheus_alertmanager_storage_volume_size=10Gi
openshift_prometheus_alertmanager_storage_labels={'storage': 'prometheus-alertmanager'}
openshift_prometheus_alertmanager_storage_type='pvc'
# For prometheus-alertbuffer
openshift_prometheus_alertbuffer_storage_kind=nfs
openshift_prometheus_alertbuffer_storage_access_modes=['ReadWriteOnce']
openshift_prometheus_alertbuffer_storage_nfs_directory=/srv/nfs/storage
openshift_prometheus_alertbuffer_storage_nfs_options='*(rw,root_squash)'
openshift_prometheus_alertbuffer_storage_volume_name=prometheus-alertbuffer
openshift_prometheus_alertbuffer_storage_volume_size=10Gi
openshift_prometheus_alertbuffer_storage_labels={'storage': 'prometheus-alertbuffer'}
openshift_prometheus_alertbuffer_storage_type='pvc'

# Already set in the disconnected section
# openshift_prometheus_node_exporter_image_version=v3.9

# Enable cluster logging
openshift_logging_install_logging=True


# openshift_logging_kibana_hostname=kibana.apps.example.com
openshift_logging_es_cluster_size=1

openshift_logging_es_nodeselector={"env":"infra"}
openshift_logging_kibana_nodeselector={"env":"infra"}
openshift_logging_curator_nodeselector={"env":"infra"}

openshift_logging_storage_kind=dynamic
openshift_logging_es_pvc_size=20Gi
openshift_logging_es_pvc_storage_class_name="glusterfs-registry-block"




###########################################################################
### OpenShift Project Management Vars
###########################################################################

# Configure additional projects
openshift_additional_projects={'openshift-template-service-broker': {'default_node_selector': ''}}


###########################################################################
### OpenShift Router and Registry Vars
###########################################################################

openshift_hosted_router_replicas=2
openshift_hosted_router_selector="route=enable"
#openshift_hosted_router_certificate={"certfile": "/path/to/router.crt", "keyfile": "/path/to/router.key", "cafile": "/path/to/router-ca.crt"}

openshift_hosted_registry_replicas=1
openshift_hosted_registry_selector="registry=enable"

openshift_hosted_registry_storage_kind=glusterfs

openshift_hosted_registry_pullthrough=true
openshift_hosted_registry_acceptschema2=true
openshift_hosted_registry_enforcequota=true


###########################################################################
### OpenShift Service Catalog Vars
###########################################################################

openshift_enable_service_catalog=true

template_service_broker_install=true
openshift_template_service_broker_namespaces=['openshift']

ansible_service_broker_install=true
ansible_service_broker_local_registry_whitelist=['.*-apb$']

openshift_hosted_etcd_storage_kind=nfs
openshift_hosted_etcd_storage_nfs_options="*(rw,root_squash,sync,no_wdelay)"
openshift_hosted_etcd_storage_nfs_directory=/srv/nfs/storage
openshift_hosted_etcd_storage_labels={'storage': 'etcd-asb'}
openshift_hosted_etcd_storage_volume_name=etcd-asb
openshift_hosted_etcd_storage_access_modes=['ReadWriteOnce']
openshift_hosted_etcd_storage_volume_size=10G

###########################################################################
### OpenShift Hosts
###########################################################################
[OSEv3:children]
lb
masters
etcd
nodes
nfs
glusterfs_registry

[glusterfs_registry]
master1.example.com glusterfs_ip=192.168.4.161 glusterfs_devices='[ "/dev/sdc" ]'
master2.example.com glusterfs_ip=192.168.4.162 glusterfs_devices='[ "/dev/sdc" ]'
master3.example.com glusterfs_ip=192.168.4.163 glusterfs_devices='[ "/dev/sdc" ]'




[lb]
lb.example.com 

[masters]
master3.example.com 
master2.example.com 
master1.example.com 

[etcd]
master3.example.com 
master2.example.com 
master1.example.com 


[nodes]
## These are the masters
master3.example.com openshift_hostname=master3.example.com openshift_node_labels="{'logging':'true', 'env':'infra'}" openshift_schedulable=true
master2.example.com openshift_hostname=master2.example.com openshift_node_labels="{'logging':'true', 'env':'infra'}" openshift_schedulable=true
master1.example.com openshift_hostname=master1.example.com openshift_node_labels="{'logging':'true', 'env':'infra'}"

## These are infranodes
infranode1.example.com openshift_hostname=infranode1.example.com  openshift_node_labels="{'logging':'true', 'env':'infra', 'registry':'enable','route':'enable'}"
infranode2.example.com openshift_hostname=infranode2.example.com  openshift_node_labels="{'logging':'true', 'env':'infra', 'route':'enable'}"

## These are regular nodes
node1.example.com openshift_hostname=node1.example.com  openshift_node_labels="{'logging':'true', 'env':'app'}"
node2.example.com openshift_hostname=node2.example.com  openshift_node_labels="{'logging':'true', 'env':'app'}"


[nfs]
lb.example.com  openshift_hostname=lb.example.com 
