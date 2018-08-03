Add OpenShift Basic Variables
Open the /root/my_ocp_inventory file in your preferred editor, such as vi or nano:

 ----
 vi /root/my_ocp_inventory
 ----
Add the following segment to the inventory file:

[OSEv3:vars]
###########################################################################
### Ansible Vars
###########################################################################
timeout=60
ansible_become=yes 
ansible_ssh_user=ec2-user 

###########################################################################
### OpenShift Basic Vars
###########################################################################
deployment_type=openshift-enterprise 
containerized=false 
openshift_disable_check="disk_availability,memory_availability" 

# default project node selector
osm_default_node_selector='env=app' 
Note the following points on the annotated variables:

This variable is used to indicate to Ansible that it is allowed to "become root" when running commands.
This variable sets the user—in this case, ec2-user—that is used to connect to hosts by Ansible.
deployment_type=openshift-enterprise indicates that you are deploying the enterprise-ready version of this product.
containerized=false installs the RPM-based version of OpenShift. If true is selected, the containerized installation installs services using container images and runs separate services in individual containers.
The lab environments do not have all of the disk space available to OpenShift that the installation promises. However, because you are not conducting performance testing on these environments, you can overprovision them. Instruct OpenShift Ansible to disable automatic checking of disk_availability by changing the last setting above to have openshift_disable_check="memory_availability,disk_availability".
osm_default_node_selector='env=app' indicates to the OpenShift scheduler that, unless otherwise indicated, pods are scheduled to run on nodes that have the env=app label.
5.2.2. Add OpenShift Optional Variables
Add the following segment to the inventory file:

###########################################################################
### OpenShift Optional Vars
###########################################################################

# Enable cockpit
osm_use_cockpit=true 
osm_cockpit_plugins=['cockpit-kubernetes']

# Configure additional projects
openshift_additional_projects={'my-infra-project-test': {'default_node_selector': 'env=apps'}} 
Note the following points on the annotated variables:

This is set to true to install Cockpit on the masters. This is the default, as is the plug-in indicated on the next line.
Creates an optional list of projects to be created as part of the OpenShift installation. You can specify the node selector for those projects.
5.2.3. Add OpenShift Master Variables
These variables control the configuration of the OpenShift master process.

Note that loadbalancer1.$GUID.internal has a different name for public access: loadbalancer.$GUID.example.opentlc.com.

Add the following segment to the inventory file, making sure to replace $GUID with your unique identifier:

###########################################################################
### OpenShift Master Vars
###########################################################################

openshift_master_api_port=443  
openshift_master_console_port=443

openshift_master_cluster_method=native 
openshift_master_cluster_hostname=loadbalancer1.$GUID.internal 
openshift_master_cluster_public_hostname=loadbalancer.$GUID.example.opentlc.com 
openshift_master_default_subdomain=apps.$GUID.example.opentlc.com 
Note the following points on the annotated variables:

The API and console ports default to 8443. You can save effort later by switching them to port 443—the standard for HTTPS.
The openshift_master_cluster_method defines how OpenShift masters implement HA for their internal functions. Earlier releases used other methods that Red Hat no longer supports.
The OpenShift master servers are served by a load balancer as defined below. The nodes access the OpenShift API through this host name.
In these examples, the load balancer’s public hostname is used for access to the master API from clients both internal and external to the cluster.
5.2.4. Add OpenShift Network Variables
These variables control the IP addressing of the two fundamental OpenShift networks and the SDN plug-ins that manage them. In this example, you select the simplest plug-in: openshift-ovs-subnet. Advanced courses cover other plug-ins, such as openshift-ovs-multitenant, which is commented out below.

Add the following segment to the inventory file:

###########################################################################
### OpenShift Network Vars
###########################################################################

#osm_cluster_network_cidr=10.1.0.0/16 
#openshift_portal_net=172.30.0.0/16 

#os_sdn_network_plugin_name='redhat/openshift-ovs-multitenant'
os_sdn_network_plugin_name='redhat/openshift-ovs-subnet' 
Note the following points on the annotated variables:

This variable overrides the SDN cluster network CIDR block. This is the network from which pod IPs are assigned.
This variable configures the subnet in which services are created within the OCP SDN. This network block must be private and must not conflict with any existing network blocks in your infrastructure to which pods, nodes, or the master may require access, or the installation fails.
This variable configures the OpenShift SDN plug-in to use for the pod network, which defaults to redhat/openshift-ovs-subnet for the standard SDN plug-in. Set the variable to redhat/openshift-ovs-multitenant to use the multitenant plug-in.
5.2.5. Add OpenShift Authentication Variables
These variables control the identity providers that are installed and enabled in the OpenShift master to provide authentication services.

In this section, you set up a simple htpasswd identity provider and create a sample httpasswd file with usernames and encrypted passwords.

Add the following segment to the inventory file:

###########################################################################
### OpenShift Authentication Vars
###########################################################################

# htpasswd auth
openshift_master_identity_providers=[{'name': 'htpasswd_auth', 'login': 'true', 'challenge': 'true', 'kind': 'HTPasswdPasswordIdentityProvider', 'filename': '/etc/origin/master/htpasswd'}] 
# Defining htpasswd users
#openshift_master_htpasswd_users={'user1': '<pre-hashed password>', 'user2': '<pre-hashed password>'}
# or
openshift_master_htpasswd_file=/root/htpasswd.openshift 
Note the following points on the annotated variables:

Tells Ansible to set up the OpenShift master to use htpasswd_auth and where to find the credentials file on the master’s local file system.
Tells Ansible to find the source of that file in the bastion’s file system for transfer to each of the three master hosts. (This file is already created for you in this lab.)
5.2.6. Add OpenShift Metrics and Logging Variables
In the following extensive section of variables, metrics and logging components are set up in your cluster. Note the pattern that is expressed in each of the stanzas of variables.

Add the following segment to the inventory file, replacing $GUID with your unique identifier:

###########################################################################
### OpenShift Metrics and Logging Vars
###########################################################################

# Enable cluster metrics

openshift_metrics_install_metrics=True 

openshift_metrics_storage_kind=nfs 
openshift_metrics_storage_access_modes=['ReadWriteOnce'] 
openshift_metrics_storage_nfs_directory=/srv/nfs  
openshift_metrics_storage_nfs_options='*(rw,root_squash)' 
openshift_metrics_storage_volume_name=metrics 
openshift_metrics_storage_volume_size=10Gi 
openshift_metrics_storage_labels={'storage': 'metrics'} 

openshift_metrics_cassandra_nodeselector={"env":"infra"} 
openshift_metrics_hawkular_nodeselector={"env":"infra"} 
openshift_metrics_heapster_nodeselector={"env":"infra"} 

# Enable cluster logging

openshift_logging_install_logging=True 

openshift_logging_storage_kind=nfs  
openshift_logging_storage_access_modes=['ReadWriteOnce']  
openshift_logging_storage_nfs_directory=/srv/nfs 
openshift_logging_storage_nfs_options='*(rw,root_squash)' 
openshift_logging_storage_volume_name=logging 
openshift_logging_storage_volume_size=10Gi 
openshift_logging_storage_labels={'storage': 'logging'} 

# openshift_logging_kibana_hostname=kibana.apps.$GUID.example.opentlc.com
openshift_logging_es_cluster_size=1

openshift_logging_es_nodeselector={"env":"infra"} 
openshift_logging_kibana_nodeselector={"env":"infra"} 
openshift_logging_curator_nodeselector={"env":"infra"} 
Note the following points that describe select variables:

Controls whether the component is installed/deployed at all.
Sets up several aspects of storage for the component.
Specifies a nodeselector, which directs scheduling of the components' pods to the desired node with a label matching the nodeselector value.
Some components also offer variables indicating specific features, such as cluster size (number of pods deployed for component) and the URL where the service can be accessed, if not directly through the OpenShift API.

5.2.7. Add OpenShift Router and Registry Variables
An OpenShift router is created during installation if there are nodes present with labels matching the region=infra, as specified in the openshift_hosted_router_selector variable. Later in this lab, you add openshift_node_labels variables per node as needed to label nodes.

Add the following segment to the inventory file:

###########################################################################
### OpenShift Router and Registry Vars
###########################################################################

openshift_hosted_router_selector='env=infra' 
openshift_hosted_router_replicas=2 

openshift_hosted_registry_selector='env=infra' 
openshift_hosted_registry_replicas=1 

openshift_hosted_registry_storage_kind=nfs 
openshift_hosted_registry_storage_access_modes=['ReadWriteMany']
openshift_hosted_registry_storage_nfs_directory=/srv/nfs
openshift_hosted_registry_storage_nfs_options='*(rw,root_squash)'
openshift_hosted_registry_storage_volume_name=registry
openshift_hosted_registry_storage_volume_size=20Gi
Note the following points on the annotated variables:

The router selector is optional, and specifies that the router is only created if nodes matching this label are present.
Unless specified, OpenShift Ansible calculates the replica count based on the number of nodes matching the OpenShift router selector.
The registry is only created if nodes matching this label are present.
Registry replicas are optional. Unless specified, OpenShift Ansible calculates the replica count based on the number of nodes matching the OpenShift registry selector.
An NFS volume is created with a path using the <nfs_directory>/<volume_name> pattern on the host within the [nfs] host group. For example, the volume path using these options is /exports/registry. The remaining options are covered in advanced courses.
5.2.8. Add OpenShift Service Catalog Variables
Add the following segment to the inventory file:

###########################################################################
### OpenShift Service Catalog Vars
###########################################################################

openshift_enable_service_catalog=true 
ansible_service_broker_install=false 
template_service_broker_install=true 
template_service_broker_selector={"env":"infra"} 
openshift_additional_projects={'openshift-template-service-broker': {'default_node_selector': ''}} 
openshift_template_service_broker_namespaces=['openshift'] 
Note the following points on the annotated variables:

Enables the service catalog.
Required because the Ansible service broker does not currently deploy without errors.
Enables template service broker (requires the service catalog to be enabled, above).
Deploy template service broker only to "infra" nodes
bug workaround: Reset the template service broker’s default node selector to ''
Configures one or more namespaces whose templates are served by the template service broker.
5.2.9. Add OpenShift Prometheus Metrics Variables (Optional)
Add the following segment to the inventory file:

## Add Prometheus Metrics:
openshift_hosted_prometheus_deploy=true 
openshift_prometheus_node_selector={"env":"infra"}
openshift_prometheus_namespace=openshift-metrics 

# Prometheus

openshift_prometheus_storage_kind=nfs
openshift_prometheus_storage_access_modes=['ReadWriteOnce']
openshift_prometheus_storage_nfs_directory=/srv/nfs
openshift_prometheus_storage_nfs_options='*(rw,root_squash)'
openshift_prometheus_storage_volume_name=prometheus
openshift_prometheus_storage_volume_size=10Gi
openshift_prometheus_storage_labels={'storage': 'prometheus'}
openshift_prometheus_storage_type='pvc'
# For prometheus-alertmanager
openshift_prometheus_alertmanager_storage_kind=nfs
openshift_prometheus_alertmanager_storage_access_modes=['ReadWriteOnce']
openshift_prometheus_alertmanager_storage_nfs_directory=/srv/nfs
openshift_prometheus_alertmanager_storage_nfs_options='*(rw,root_squash)'
openshift_prometheus_alertmanager_storage_volume_name=prometheus-alertmanager
openshift_prometheus_alertmanager_storage_volume_size=10Gi
openshift_prometheus_alertmanager_storage_labels={'storage': 'prometheus-alertmanager'}
openshift_prometheus_alertmanager_storage_type='pvc'
# For prometheus-alertbuffer
openshift_prometheus_alertbuffer_storage_kind=nfs
openshift_prometheus_alertbuffer_storage_access_modes=['ReadWriteOnce']
openshift_prometheus_alertbuffer_storage_nfs_directory=/srv/nfs
openshift_prometheus_alertbuffer_storage_nfs_options='*(rw,root_squash)'
openshift_prometheus_alertbuffer_storage_volume_name=prometheus-alertbuffer
openshift_prometheus_alertbuffer_storage_volume_size=10Gi
openshift_prometheus_alertbuffer_storage_labels={'storage': 'prometheus-alertbuffer'}
openshift_prometheus_alertbuffer_storage_type='pvc'
5.2.10. Add Hosts and Labels to Ansible Hosts File
Add the following segment to the inventory file, replacing $GUID with your unique identifier:

###########################################################################
### OpenShift Hosts
###########################################################################
[OSEv3:children]
lb
masters
etcd
nodes
nfs

[lb]
loadbalancer1.$GUID.internal

[masters]
master3.$GUID.internal
master2.$GUID.internal
master1.$GUID.internal

[etcd]
master3.$GUID.internal
master2.$GUID.internal
master1.$GUID.internal


[nodes]
## These are the masters
master3.$GUID.internal openshift_hostname=master3.$GUID.internal openshift_node_labels="{'logging':'true','openshift_schedulable':'False','cluster': '$GUID'}"
master2.$GUID.internal openshift_hostname=master2.$GUID.internal openshift_node_labels="{'logging':'true','openshift_schedulable':'False','cluster': '$GUID'}"
master1.$GUID.internal openshift_hostname=master1.$GUID.internal openshift_node_labels="{'logging':'true','openshift_schedulable':'False','cluster': '$GUID'}"

## These are infranodes
infranode1.$GUID.internal openshift_hostname=infranode1.$GUID.internal  openshift_node_labels="{'logging':'true','cluster': '$GUID', 'env':'infra'}"
infranode2.$GUID.internal openshift_hostname=infranode2.$GUID.internal  openshift_node_labels="{'logging':'true','cluster': '$GUID', 'env':'infra'}"

## These are regular nodes
node3.$GUID.internal openshift_hostname=node3.$GUID.internal  openshift_node_labels="{'logging':'true','cluster': '$GUID', 'env':'app'}"
node1.$GUID.internal openshift_hostname=node1.$GUID.internal  openshift_node_labels="{'logging':'true','cluster': '$GUID', 'env':'app'}"
node2.$GUID.internal openshift_hostname=node2.$GUID.internal  openshift_node_labels="{'logging':'true','cluster': '$GUID', 'env':'app'}"


[nfs]
support1.$GUID.internal openshift_hostname=support1.$GUID.internal
You can use the pre-populated inventory file for this lab found at /var/preserve/hosts.
5.2.11. Save Ansible Inventory File
Save all of your changes and exit your editor.

Make sure that all of the instances of $GUID in the inventory file are changed to your unique identifier:

sed -i "s/\$GUID/${GUID}/g" /root/my_ocp_inventory
5.3. Run OpenShift Installer
Run ansible-playbook to start the installation process:

Remember to use tmux or another terminal multiplexer. If your Internet connection breaks while the playbook is running, the multiplexer ensures that the session continues and the playbook keeps running to completion. If you are detached, you can ssh back into the bastion and type tmux attach to return to your session.

ansible-playbook -f 20 -i /root/my_ocp_inventory /usr/share/ansible/openshift-ansible/playbooks/byo/config.yml
The installation takes at least 20 minutes.

Examine the PLAY RECAP of the installer:

Sample Output
PLAY RECAP *************************************************************************************************************
infranode1.$GUID.internal   : ok=194  changed=61   unreachable=0    failed=0
infranode2.$GUID.internal   : ok=194  changed=61   unreachable=0    failed=0
loadbalancer1.$GUID.internal : ok=74   changed=15   unreachable=0    failed=0
localhost                  : ok=14   changed=0    unreachable=0    failed=0
master1.$GUID.internal      : ok=424  changed=153  unreachable=0    failed=0
master2.$GUID.internal      : ok=424  changed=153  unreachable=0    failed=0
master3.$GUID.internal      : ok=1035 changed=412  unreachable=0    failed=0
node1.$GUID.internal        : ok=194  changed=61   unreachable=0    failed=0
node2.$GUID.internal        : ok=194  changed=61   unreachable=0    failed=0
node3.$GUID.internal        : ok=194  changed=61   unreachable=0    failed=0
support1.$GUID.internal     : ok=72   changed=13   unreachable=0    failed=0


INSTALLER STATUS *******************************************************************************************************
Initialization             : Complete
Health Check               : Complete
etcd Install               : Complete
NFS Install                : Complete
Load balancer Install      : Complete
Master Install             : Complete
Master Additional Install  : Complete
Node Install               : Complete
Hosted Install             : Complete
Metrics Install            : Complete
Logging Install            : Complete
Prometheus Install         : Complete
Service Catalog Install    : Complete
If the playbook does not complete with PLAY RECAP for each host showing failed=0, uninstall and reinstall with a known good Ansible inventory.

Uninstall the OpenShift cluster:

ansible-playbook -f 20 -i /root/my_ocp_inventory /usr/share/ansible/openshift-ansible/playbooks/byo/openshift-management/uninstall.yml
Install again with the known good Ansible inventory file:

ansible-playbook -f 20 -i /var/preserve/hosts /usr/share/ansible/openshift-ansible/playbooks/byo/config.yml
As before, this process takes about 20 minutes. Expect the installation to complete without error. If it fails, contact support at rhpds-admins@redhat.com.



Configure OpenShift Cluster
In this section, you create persistent volumes for users to consume, and you verify LDAP authentication.

You create 25 PVs with these parameters:

Size: 5 GB

PV access: ReadWriteOnce

ReclaimPolicy: Recycle

You create 25 PVs with these parameters:

Size: 10 GB

PV access: ReadWriteMany

ReclaimPolicy: Retain

Create directories on the support1.$GUID.internal NFS host to be used as PVs in the OpenShift cluster:

ssh support1.$GUID.internal
sudo bash
mkdir -p /srv/nfs/user-vols/pv{1..200}

for pvnum in {1..50} ; do
echo /srv/nfs/user-vols/pv${pvnum} *(rw,root_squash) >> /etc/exports.d/openshift-uservols.exports
chown -R nfsnobody.nfsnobody  /srv/nfs
chmod -R 777 /srv/nfs
done

systemctl restart nfs-server
Create 25 definition files for pv1 to pv25 with a size of 5 GB:

ssh master1.$GUID.internal
sudo bash
export GUID=`hostname|awk -F. '{print $2}'`
echo $GUID

export volsize="5Gi"
mkdir /root/pvs
for volume in pv{1..25} ; do
cat << EOF > /root/pvs/${volume}
{
  "apiVersion": "v1",
  "kind": "PersistentVolume",
  "metadata": {
    "name": "${volume}"
  },
  "spec": {
    "capacity": {
        "storage": "${volsize}"
    },
    "accessModes": [ "ReadWriteOnce" ],
    "nfs": {
        "path": "/srv/nfs/user-vols/${volume}",
        "server": "support1.$GUID.internal"
    },
    "persistentVolumeReclaimPolicy": "Recycle"
  }
}
EOF
echo "Created def file for ${volume}";
done;
Create 25 definition files for pv26 to pv50 with a size of 10 GB:

export volsize="10Gi"
for volume in pv{26..50} ; do
cat << EOF > /root/pvs/${volume}
{
  "apiVersion": "v1",
  "kind": "PersistentVolume",
  "metadata": {
    "name": "${volume}"
  },
  "spec": {
    "capacity": {
        "storage": "${volsize}"
    },
    "accessModes": [ "ReadWriteMany" ],
    "nfs": {
        "path": "/srv/nfs/user-vols/${volume}",
        "server": "support1.$GUID.internal"
    },
    "persistentVolumeReclaimPolicy": "Retain"
  }
}
EOF
echo "Created def file for ${volume}";
done;
Use oc create to create all of the PVs that you defined:

cat /root/pvs/* | oc create -f -




Perform Ansible Health Checks
The Ansible inventory file that you created in this lab is required for running the Ansible health checks.

From the bastion host, execute the following as root:

ansible-playbook -i /root/my_ocp_inventory \
    /usr/share/ansible/openshift-ansible/playbooks/byo/openshift-checks/health.yml