一.根据环境部署需部署的角色布局可以有四种：
1.[OSEv3:children]
masters
nodes
etcd #数据库

2.[OSEv3:children]
masters
nodes
glusterfs_registry #持久化存储仓库

3.[OSEv3:children]
masters
nodes
etcd
lb HAProxy负载平衡API主终端

4.[OSEv3:children]
masters
nodes
nfs



全局参数分类：
基于角色第一种情况设置参数：
1.[OSEv3:children]
masters
nodes
etcd #数据库


[OSEv3:var]
配置群集变量
#1身份提供商之一htpasswd
openshift_master_identity_providers=[{'name': 'htpasswd_auth',
'login': 'true', 'challenge': 'true',
'kind': 'HTPasswdPasswordIdentityProvider',
'filename': '/etc/origin/master/htpasswd'}]
#2默认子域以用于公开的 路由
openshift_master_default_subdomain=apps.test.example.com
#3设置安装程序使用的SSH用户
ansible_ssh_user=root
#4If ansible_ssh_user is not root, ansible_become must be set to true
#ansible_become=true
#5配置部署类型
openshift_deployment_type=openshift-enterprise
#6配置群集预安装检查
openshift_disable_check=memory_availability,disk_availability,docker_image_availability,package_availability,docker_storage
#7配置系统容器，----理解：系统容器提供了一种方法来容纳在docker守护进程运行之前需要运行的服务。
注意点：所有系统容器组件都是 OpenShift Container Platform 3.7 中的 技术预览功能。
它们不能用于生产，并且不支持升级到OpenShift Container Platform 3.7。在此阶段，它们只能用于非生产环境中的新集群安装。
举例Docker格式的容器：
OSTree for storage,
runC for the runtime,
systemd for service management, and
skopeo for searching.
OpenShift容器平台仅支持RHEL和RHEL Atomic作为主机操作系统，因此默认使用为RHEL构建的系统容器。
将DOCKER作为系统容器运行注意点：
1.库存变量将 docker被忽略的参数---docker_version与docker_upgrade
2.不得使用以下库存变量----openshift_docker_options
++++++++++++++++++++++++++++++++++++
openshift_docker_use_system_container=True
#8配置数据库容器
openshift_use_etcd_system_container=True
#9您也可以强制docker在系统容器中使用特定的容器注册表和存储库时，拉container-engine图像，而不是从默认值registry.access.redhat.com/openshift3/
openshift_docker_systemcontainer_image_override="<registry>/<user>/<image>:<tag>"

#10配置注册表位置
oreg_url=harborone.ultraapp.com/openshift3/ose-${component}:${version}
#配置注册表存储有四种方式。
1主机内
openshift_hosted_registry_storage_kind=nfs
openshift_hosted_registry_storage_access_modes=['ReadWriteMany']
openshift_hosted_registry_storage_nfs_directory=/exports
openshift_hosted_registry_storage_nfs_options='*(rw,root_squash)'
openshift_hosted_registry_storage_volume_name=registry
openshift_hosted_registry_storage_volume_size=10Gi
2主机外
openshift_hosted_registry_storage_kind=nfs
openshift_hosted_registry_storage_access_modes=['ReadWriteMany']
openshift_hosted_registry_storage_host=nfs.example.com
openshift_hosted_registry_storage_nfs_directory=/exports
openshift_hosted_registry_storage_volume_name=registry
openshift_hosted_registry_storage_volume_size=10Gi
3openshift平台
openshift_hosted_registry_storage_kind=openstack
openshift_hosted_registry_storage_access_modes=['ReadWriteOnce']
openshift_hosted_registry_storage_openstack_filesystem=ext4
openshift_hosted_registry_storage_openstack_volumeID=3a650b4f-c8c5-4e0a-8ca5-eaee11f16c57
openshift_hosted_registry_storage_volume_size=10Gi
4ams s3服务
openshift_hosted_registry_storage_kind=object
openshift_hosted_registry_storage_provider=s3
openshift_hosted_registry_storage_s3_accesskey=access_key_id
openshift_hosted_registry_storage_s3_secretkey=secret_access_key
openshift_hosted_registry_storage_s3_bucket=bucket_name
openshift_hosted_registry_storage_s3_region=bucket_region
openshift_hosted_registry_storage_s3_chunksize=26214400
openshift_hosted_registry_storage_s3_rootdirectory=/registry
openshift_hosted_registry_pullthrough=true
openshift_hosted_registry_acceptschema2=true
openshift_hosted_registry_enforcequota=true
#注意If you are using a different S3 service, such as Minio or ExoScale, also add the region endpoint parameter:
openshift_hosted_registry_storage_s3_regionendpoint=https://myendpoint.example.com/
************************************************************************************************************

配置GlusterFS永久存储
#1.添加glusterfs该[OSEv3:children]部分以启用该[glusterfs]组
[OSEv3:children]
masters
nodes
glusterfs
#2在[OSEv3:vars] 要更改的部分中包含以下任何角色变量
[OSEv3:vars]
openshift_storage_glusterfs_namespace=glusterfs
openshift_storage_glusterfs_name=storage
#3[glusterfs]为每个将存放GlusterFS存储的存储节点添加一个条目，glusterfs_ip并glusterfs_devices在表单中包含和 参数
#<hostname_or_ip> glusterfs_ip=<ip_address> glusterfs_devices='[ "</path/to/device1/>", "</path/to/device2>", ... ]'
[glusterfs]
192.168.10.11 glusterfs_ip=192.168.10.11 glusterfs_devices='[ "/dev/xvdc", "/dev/xvdd" ]'
192.168.10.12 glusterfs_ip=192.168.10.12 glusterfs_devices='[ "/dev/xvdc", "/dev/xvdd" ]'
192.168.10.13 glusterfs_ip=192.168.10.13 glusterfs_devices='[ "/dev/xvdc", "/dev/xvdd" ]'
#4列出的主机也添加[glusterfs]到[nodes]组中
[nodes]
192.168.10.11
192.168.10.12
192.168.10.13
#5在每次运行高级安装完成群集安装后 ，从主服务器运行以下命令验证是否成功创建了必要的对象
oc get storageclass
oc get routes
curl http://heketi-glusterfs-default.cloudapps.example.com/hello
****************************************************************************************************************************
未完成分类：
配置OpenShift docker registry
配置全局代理选项
配置防火墙
配置主人的可调度性
配置节点主机标签
配置会话选项
配置自定义证书
配置证书有效性
配置群集度量
配置群集记录
配置服务目录
配置OpenShift Ansible Broker
配置模板服务代理
配置Web控制台自定义


三.master域名定义与数量（一个或多个）
master.example.com
master1.example.com
master2.example.com

四.主数据库etcd：
数量也可以根据需求分布一个或者多个
位置可以一种在master节点，一种单独分出节点
[etcd]
1.etcd1.example.com
2.master.example.com
.........
五.node节点：实际的标签名称和值是任意的，可以根据您的群集要求进行分配。region=infra
master.example.com
node1.example.com openshift_node_labels="{'region': 'primary', 'zone': 'node1','infra':'true'}"
node2.example.com openshift_node_labels="{'region': 'primary', 'zone': 'node2'}"
*********************************************************************************************************************************************
这是我安装测试环境下配置的参数：
第一种：一主多从
# Create an OSEv3 group that contains the masters, nodes, and etcd groups
[OSEv3:children]
masters
nodes
etcd


# Set variables common for all OSEv3 hosts
[OSEv3:vars]
# SSH user, this user should allow ssh based auth without requiring a password
ansible_ssh_user=root


# If ansible_ssh_user is not root, ansible_become must be set to true
#ansible_become=true


openshift_deployment_type=openshift-enterprise


# uncomment the following to enable htpasswd authentication; defaults to DenyAllPasswordIdentityProvider
openshift_master_identity_providers=[{'name': 'htpasswd_auth', 'login': 'true', 'challenge': 'true', 'kind': 'HTPasswdPasswordIdentityProvider', 'filename': '/etc/origin/master/htpasswd'}]#外部认证方式选择htpassd


openshift_disable_check=memory_availability,disk_availability,docker_image_availability,package_availability,docker_storage




openshift_docker_options="--selinux-enabled --insecure-registry 172.30.0.0/16 --log-driver json-file --log-opt max-size=10M --log-opt max-file=3 --insecure-registry harborone.ultraapp.com --add-registry harborone.ultraapp.com" #这是本人公司仓库，请根据个人情况填写修改


openshift_master_default_subdomain=apps.develop.com


openshift_hosted_router_selector='infra=true'
openshift_hosted_registry_selector='infra=true'


openshift_release=3.7.9


oreg_url=harborone.ultraapp.com/openshift3/ose-${component}:${version}
# host group for masters
[masters]
master.develop.com


# host group for etcd
[etcd]
master.develop.com


# host group for nodes, includes region info
[nodes]
master.develop.com
node1.develop.com openshift_node_labels="{'region': 'primary', 'zone': 'node1','infra':'true'}"
node2.develop.com openshift_node_labels="{'region': 'primary', 'zone': 'node2'}"
***************************************************************************************************************
第二种：多主多从
[OSEv3:children]
masters
nodes
etcd
lb #多master节点需要前面有负载均衡


# Set variables common for all OSEv3 hosts
[OSEv3:vars]
# SSH user, this user should allow ssh based auth without requiring a password
ansible_ssh_user=root


# If ansible_ssh_user is not root, ansible_become must be set to true
#ansible_become=true


deployment_type=openshift-enterprise


# uncomment the following to enable htpasswd authentication; defaults to DenyAllPasswordIdentityProvider
openshift_master_identity_providers=[{'name': 'htpasswd_auth', 'login': 'true', 'challenge': 'true', 'kind': 'HTPasswdPasswordIdentityProvider', 'filename': '/etc/origin/master/htpasswd'}]#外部认证方式选择htpassd


openshift_disable_check=memory_availability,disk_availability,docker_image_availability,package_availability,docker_storage


openshift_master_cluster_method=native #多master需要配置
openshift_master_cluster_hostname=master.develop.com
openshift_master_cluster_public_hostname=master.develop.com


openshift_docker_options="--selinux-enabled --insecure-registry 172.30.0.0/16 --log-driver json-file --log-opt max-size=10M --log-opt max-file=3 --insecure-registry harborone.ultraapp.com --add-registry harborone.ultraapp.com"
openshift_hosted_metrics_public_url=https://hawkular-metrics.apps.develop.com/hawkular/metrics
openshift_master_default_subdomain=apps.develop.com


openshift_hosted_router_selector='infra=true'


openshift_hosted_registry_selector='infra=true'


openshift_hosted_logging_deploy=true #部署日志
openshift_logging_image_prefix=harborone.ultraapp.com/openshift3/
openshift_logging_image_version=v3.7
openshift_logging_public_master_url=harborone.ultraapp.com


openshift_metrics_install_metrics=true #部署监控
openshift_hosted_metrics_deploy=true
openshift_metrics_image_prefix=harborone.ultraapp.com/openshift3/
openshift_metrics_image_version=v3.7


# host group for masters
[masters]
master1.develop.com
master2.develop.com
master3.develop.com


[lb]
node3.develop.com


[etcd]
master1.develop.com
master2.develop.com
master3.develop.com


# host group for nodes, includes region info
[nodes]
master1.develop.com
master2.develop.com
master3.develop.com
node1.develop.com openshift_node_labels="{'region': 'primary', 'zone': 'node1', 'infra': 'true'}"
node2.develop.com openshift_node_labels="{'region': 'primary', 'zone': 'node2'}"
node3.develop.com openshift_node_labels="{'region': 'primary', 'zone': 'node3'}"