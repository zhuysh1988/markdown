[OSEv3:vars]
openshift_disable_check=disk_availability,docker_image_availability,docker_storage,memory_availability,package_availability

###########################################################################
### Ansible Vars
###########################################################################
timeout=60
ansible_ssh_user=root
deployment_type=openshift-enterprise
openshift_release=v3.7
# Enable cockpit
osm_use_cockpit=true
# Set cockpit plugins
osm_cockpit_plugins=['cockpit-kubernetes']


oreg_url=registry.example.com:5000/openshift3/ose-${component}:${version}
openshift_docker_additional_registries=registry.example.com:5000
openshift_docker_insecure_registries=registry.example.com:5000
openshift_examples_modify_imagestreams=true

##HTPasswd
openshift_master_identity_providers=[{'name': 'htpasswd_auth', 'login': 'true', 'challenge':'true', 'kind': 'HTPasswdPasswordIdentityProvider', 'filename': '/etc/origin/master/htpasswd/user'}]
#openshift_master_htpasswd_file=/root/htpasswd.openshift

openshift_node_kubelet_args={'pods-per-core': ['10'], 'max-pods': ['250'], 'image-gc-high-threshold': ['85'], 'image-gc-low-threshold': ['75']}

openshift_master_cluster_method=native
openshift_master_cluster_hostname=master.example.com
openshift_master_cluster_public_hostname=master.example.com


openshift_enable_service_catalog=false

template_service_broker_install=false
##metrics
#openshift_metrics_install_metrics=true
#openshift_hosted_metrics_deploy=true
#openshift_hosted_metrics_public_url=https://hawkular-metrics.apps.example.com/hawkular/metrics
#openshift_metrics_image_prefix=registry.example.com:5000/openshift3/
#openshift_metrics_image_version=v3.6

## Logging
#openshift_hosted_logging_deploy=true
#openshift_logging_image_prefix=registry.example.com:5000/openshift3/
#openshift_logging_image_version=v3.6

##defalut project node selector
#osm_default_node_selector='env=infra'
## Router
openshift_hosted_router_selector="env=infra"
#openshift_hosted_router_replicas=1
## Registry
openshift_hosted_registry_selector="env=infra"

## Subdomain
openshift_hosted_router_force_subdomain='${name}-${namespace}.apps.example.com'
openshift_master_default_subdomain="apps.example.com"

openshift_clock_enabled=true
[OSEv3:children]
masters
etcd
nodes


[masters]
master.example.com 

[etcd]
master.example.com 


[nodes]
## These are the masters
master.example.com  openshift_hostname=master.example.com openshift_node_labels="{'env': 'infra','zone': 'default'}"  openshift_schedulable=true

