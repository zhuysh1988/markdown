# 变更ocp 网络为多租户模式

## Change Ansible Hosts

* add this For /etc/ansible/hosts
```
os_sdn_network_plugin_name='redhat/openshift-ovs-multitenant'
```
## 执行生效,两种方案 
* 1 本方法速度快
```
# reconfigure all the config files
ansible masters -m shell -a "sed -i -e 's/openshift-ovs-subnet/openshift-ovs-multitenant/g' /etc/origin/master/master-config.yaml"
ansible nodes -m shell -a "sed -i -e 's/openshift-ovs-subnet/openshift-ovs-multitenant/g' /etc/origin/node/node-config.yaml"

# Stop all the services
ansible masters -m shell -a'systemctl stop atomic-openshift-master-api'
ansible masters -m shell -a'systemctl stop atomic-openshift-master-controllers'
ansible nodes -m shell -a'systemctl stop atomic-openshift-node'

# restart openvswitch
ansible nodes -m shell -a'systemctl restart openvswitch'

# start all the services
ansible masters -m shell -a'systemctl start atomic-openshift-master-api'
ansible masters -m shell -a'systemctl start atomic-openshift-master-controllers'
ansible nodes -m shell -a'systemctl start atomic-openshift-node'
```
* 2 本方法要30多分钟
```
ansible-playbook -f 20 /usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml
```


# Testing 
## Create Project And Deploy App To Then
```
oc new-project pizzaparty-dev
oc new-project fancypants-dev

oc new-app openshift/hello-openshift:v1.1.1.1 -n pizzaparty-dev
oc new-app openshift/hello-openshift:v1.1.1.1 -n fancypants-dev

oc run shelly -n pizzaparty-dev --image=openshift3/ose-deployer --command=true -- bash -c 'while true; do sleep 1; done'
oc run shelly -n fancypants-dev --image=openshift3/ose-deployer --command=true -- bash -c 'while true; do sleep 1; done'

```
## Show Pod 
```bash
oc get pod --all-namespaces | grep hello-openshift
oc get pod --all-namespaces | grep shelly

```

## 由于您启用了多租户，因此每个项目都放置在自己的Open vSwitch（OVS）虚拟网络上
```bash
oc get netnamespaces

# NETID 每个project NETID不相同
```

* 测试隔离
```bash
# get POD IP 
oc get pod --all-namespaces -o wide |egrep 'fancypants-dev|pizzaparty-dev'

# use 
oc rsh -n fancypants-dev $(oc get pod -n fancypants-dev | grep shelly | awk '{print $1}')
#sh-4.2$ curl 10.128.2.11:8080
#Hello OpenShift!
#sh-4.2$ curl 10.129.2.13:8080

# 不同project 下的应用 , 网络不通

```

## 设置网络 
* oc adm pod-network命令提供了一种连接项目的方法，将它们放在同一个Open vSwitch虚拟网络上。

```
oc adm pod-network join-projects --to=fancypants-dev pizzaparty-dev

oc get netnamespaces | grep dev
# NETID 已相同
# fancypants-dev                      9457450    []
# pizzaparty-dev                      9457450    []

```
* 再测试
```
[root@bastion ~]# oc rsh -n fancypants-dev $(oc get pod -n fancypants-dev | grep shelly | awk '{print $1}')
sh-4.2$ curl 10.129.2.13:8080
Hello OpenShift!
已通过
```