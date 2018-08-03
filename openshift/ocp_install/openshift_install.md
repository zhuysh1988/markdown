# openshift install

## 主机注册
> 每个主机必须使用红帽订阅管理器（RHSM）进行注册，并且附加一个活动的OpenShift Container Platform订阅才能访问所需的软件包

```bash
#On each host, register with RHSM:

subscription-manager register --username=<user_name> --password=<password>
#Pull the latest subscription data from RHSM:

subscription-manager refresh
#List the available subscriptions:

subscription-manager list --available --matches '*OpenShift*'
#In the output for the previous command, find the pool ID for an OpenShift Container Platform subscription and attach it:

subscription-manager attach --pool=<pool_id>
#Disable all yum repositories:

#Disable all the enabled RHSM repositories:

subscription-manager repos --disable="*"
#List the remaining yum repositories and note their names under repo id, if any:

yum repolist
#Use yum-config-manager to disable the remaining yum repositories:

yum-config-manager --disable <repo_id>
#Alternatively, disable all repositories:

 yum-config-manager --disable \*
#Note that this could take a few minutes if you have a large number of available repositories

#Enable only the repositories required by OpenShift Container Platform 3.9:

subscription-manager repos \
    --enable="rhel-7-server-rpms" \
    --enable="rhel-7-server-extras-rpms" \
    --enable="rhel-7-server-ose-3.9-rpms" \
    --enable="rhel-7-fast-datapath-rpms" \
    --enable="rhel-7-server-ansible-2.4-rpms"

```

> 获得工作清单文件后，可以使用/usr/share/ansible/openshift-ansible/playbooks/prerequisites.yml以默认配置安装容器运行时。如果您需要自定义容器运行时，请遵循本主题中的指导。

## 安装基本包
* For RHEL 7 systems:
```bash
#Install the following base packages:

yum install -y wget git net-tools bind-utils yum-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct
#Update the system to the latest packages:

yum update
systemctl reboot

yum install atomic-openshift-utils -y

```
## docker
### 安装docker

* For RHEL 7 systems, install Docker 1.13:
```bash
yum install docker-1.13.1 -y

rpm -V docker-1.13.1
docker version
```
> /etc/sysconfig/docker  --insecure-registry选项指示Docker守护程序信任指定子网上的任何Docker注册表，而不需要证书。

> 注意: 172.30.0.0/16是master-config.yaml文件中servicesSubnet变量的默认值。如果这已更改，则应调整上述步骤中的--insecure-registry值以匹配，因为它指示注册表要使用的子网。请注意，openshift_portal_net变量可以在Ansible清单文件中设置，并在高级安装方法期间用于修改servicesSubnet变量。



### 配置Docker存储

* Option A) Use an additional block device.

* Option B) Use an existing, specified volume group.

* Option C) Use the remaining free space from the volume group where your root file system is located.


> 选项A是最强大的选项，但是它需要在配置Docker存储之前向主机添加其他块设备。
> 选项B和C都需要在配置主机时留出可用空间。
> 已知选项C会导致某些应用程序出现问题，例如红帽移动应用程序平台（RHMAP）

* Option A) Use an additional block device.

* For example:
```bash
cat <<EOF > /etc/sysconfig/docker-storage-setup
DEVS=/dev/sdb
VG=docker-vg
EOF

#Then run docker-storage-setup and review the output to ensure the docker-pool volume was created:

docker-storage-setup                 
```
* Option B) Use an existing, specified volume group.
```bash
cat <<EOF > /etc/sysconfig/docker-storage-setup
VG=docker-vg
EOF

docker-storage-setup 
```
* Option C) Use the remaining free space from the volume group where your root file system is located.
```
docker-storage-setup 
```


> 在使用Docker或OpenShift Container Platform之前，请验证docker-pool逻辑卷是否足够大以满足您的需求。 docker-pool卷应该是可用卷组的60％，并且将通过LVM监视增长以填充卷组。


### 启动docker 设置开机启动
```
systemctl enable docker
systemctl start docker
systemctl is-active docker
```

### 管理容器日志

> 有时，容器的日志文件（运行容器的节点上的/var/lib/docker/containers/<hash>/<hash>-json.log文件）可能会增加到有问题的大小。您可以通过配置Docker的json-file日志记录驱动程序来限制日志文件的大小和数量来管理它。

|Option	|Purpose|
|-|-|
|--log-opt max-size |设置新日志文件的创建大小。|
|--log-opt max-file |设置每个主机要保留的日志文件的最大数量。|

* 例如，要将最大文件大小设置为1MB并始终保留最后三个日志文件，请编辑/ etc / sysconfig / docker文件以配置max-size = 1M和max-file = 3：
```
OPTIONS='--insecure-registry=172.30.0.0/16 --selinux-enabled --log-opt max-size=1M --log-opt max-file=3'
```
* Next, restart the Docker service:
```
systemctl restart docker
```

### 查看可用的容器日志

> docker log https://docs.docker.com/config/containers/logging/configure/#supported-logging-drivers

* 容器日志存储在运行容器的节点上的/ var / lib / docker / containers / <hash> /目录中。例如：
```
# ls -lh /var/lib/docker/containers/f088349cceac173305d3e2c2e4790051799efe363842fdab5732f51f5b001fd8/
total 2.6M
-rw-r--r--. 1 root root 5.6K Nov 24 00:12 config.json
-rw-r--r--. 1 root root 649K Nov 24 00:15 f088349cceac173305d3e2c2e4790051799efe363842fdab5732f51f5b001fd8-json.log
-rw-r--r--. 1 root root 977K Nov 24 00:15 f088349cceac173305d3e2c2e4790051799efe363842fdab5732f51f5b001fd8-json.log.1
-rw-r--r--. 1 root root 977K Nov 24 00:15 f088349cceac173305d3e2c2e4790051799efe363842fdab5732f51f5b001fd8-json.log.2
-rw-r--r--. 1 root root 1.3K Nov 24 00:12 hostconfig.json
drwx------. 2 root root    6 Nov 24 00:12 secrets
```

### 阻止本地卷的使用
> 当使用Dockerfile中的VOLUME指令或使用docker run -v <volumename>命令设置卷时，将使用主机的存储空间。使用此存储可能会导致意外的空间不足问题，并可能导致主机无法使用。 

> 在OpenShift容器平台中，试图运行自己映像的用户有可能会填充节点主机上的整个存储空间。解决此问题的一个方法是阻止用户使用卷运行映像。这样，用户有权访问的唯一存储空间就会受到限制，群集管理员可以分配存储配额。 

>使用docker-novolume-plugin可以通过禁止启动具有已定义本地卷的容器来解决此问题。

* 特别是，插件块docker运行命令包含：
```
--volumes-from选项 
已定义VOLUME的image 
对使用docker volume命令供应的现有卷的引用

```
> 该插件不会阻止对绑定挂载的引用

```bash
#Install the docker-novolume-plugin package:

yum install docker-novolume-plugin
#Enable and start the docker-novolume-plugin service:

systemctl enable docker-novolume-plugin
systemctl start docker-novolume-plugin
#Edit the /etc/sysconfig/docker file and append the following to the OPTIONS list:

--authorization-plugin=docker-novolume-plugin

#Restart the docker service:

systemctl restart docker
#After you enable this plug-in, containers with local volumes defined fail to start and show the following error message:

runContainer: API error (500): authorization denied by plugin
docker-novolume-plugin: volumes are not allowed
```

## 配置主机ssh访问
```
#For example, you can generate an SSH key on the host where you will invoke the installation process:

ssh-keygen
#Do not use a password.

#An easy way to distribute your SSH keys is by using a bash loop:

for host in master.example.com \
    node1.example.com \
    node2.example.com; \
    do ssh-copy-id -i ~/.ssh/id_rsa.pub $host; \
    done
#Modify the host names in the above command according to your configuration.
```
* ansible hosts

* ansible_ssh_user

>This variable sets the SSH user for the installer to use and defaults to root. This user should allow SSH-based authentication without requiring a password. If using SSH key-based authentication, then the key should be managed by an SSH agent.

* ansible_become

> If ansible_ssh_user is not root, this variable must be set to true and the user must be configured for passwordless sudo.


## Config /etc/ansible/hosts

* config ansible hosts
```conf
[OSEv3:vars]
openshift_disable_check=disk_availability,docker_image_availability,docker_storage,memory_availability,package_availability

###########################################################################
### Ansible Vars
###########################################################################
timeout=60
ansible_ssh_user=root
deployment_type=openshift-enterprise
openshift_release=v3.9
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
openshift_master_cluster_hostname=master39.example.com
openshift_master_cluster_public_hostname=master39.example.com


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
master39.example.com 

[etcd]
master39.example.com 


[nodes]
## These are the masters
master39.example.com  openshift_hostname=master39.example.com openshift_node_labels="{'env': 'infra','zone': 'default'}"  openshift_schedulable=true

```

## config ntp
* NTP Config
* vim /etc/chrony.conf
```conf
server 10.15.15.10 iburst
driftfile /var/lib/chrony/drift
makestep 1.0 3
rtcsync
logdir /var/log/chrony
```

## config Master DNS 
* install dnsmasq
```bash
yum install dnsmasq -y
```
* config dnsmasq
```conf
cat > /etc/dnsmasq.d/openshift-cluster.conf <<EOF
local=/example.com/
address=/.apps.example.com/10.15.15.39
EOF

```


## run ansible-playbook

echo -e "nameserver 10.15.15.2"  > /etc/origin/node/resolv.conf

```bash
ansible-playbook  /usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml

```