


# Disable Project Self-Provisioning
### 重点知识: role: self-provisioner #可以创建project  



> 在本练习中，您将删除用户创建自己项目的默认权限，并仅允许生产管理员创建项目。要完成此练习，请执行以下操作：

* 确保用户无法创建项目。 
* 允许ocp-production组中的用户创建自己的项目。 
* 为尝试创建项目的用户配置消息：“Please create project using the portal or contact Karla at karla@example.com”。


## Configure Project Request Message

* 两种办法实现: 1 修改/etc/ansible/hosts文件 , 重新执行部署
### 1 编辑堡垒主机上的/ etc / ansible / hosts并添加项目请求消息。 确保[OSEv3：vars]部分包含以下内容：
```
# Project Configuration
osm_project_request_message='Please create project using the portal http://portal.$GUID.internal/provision or contact Karla at karla@example.com'
```
* 执行ansible-playbook 
```
ansible-playbook -f 20 /usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml
```

### 2 或者，您可以编辑所有主服务器上的/etc/origin/master/master-config.yaml文件，然后重新启动主API服务，这样会更快
```
projectConfig:
  projectRequestMessage: Please create project using the portal http://portal.$GUID.internal/provision
    or contact Karla at karla@example.com
```
* restart api services 
```
ansible masters -m service -a 'name=atomic-openshift-master-api state=restarted enabled=yes'
```


## 删除权限
* 1 Log in as system:admin and set the project to default:
```
oc login -u system:admin
oc project default
```
* 2 Disable self-provisioning for the system:authenticated group by editing the cluster roles.
```
oc adm policy remove-cluster-role-from-group self-provisioner system:authenticated
oc adm policy remove-cluster-role-from-group self-provisioner system:authenticated:oauth
```

* 3 Examine the cluster roles:
```
oc describe clusterrolebinding.rbac -n default
```
* 4 In the lengthy output, look for this section:

* Sample Output
```
[...]

Name:         self-provisioner
Labels:       <none>
Annotations:  <none>
Role:
  Kind:  ClusterRole
  Name:  self-provisioner
Subjects:
  Kind            Name              Namespace
  ----            ----              ---------
  ServiceAccount  management-admin  management-infra

[...]
```
* 5 Log in as an authenticated user—not as system:admin:
```
oc login -u payment1 -p r3dh4t1!
```
* 6 Verify that the updated project request message appears when trying to create a project:
```
oc new-project thiswillnotwork
```
* Sample Output
```
Error from server (Forbidden): Please create project using the portal http://portal.$GUID.internal/provision or contact Karla at karla@example.com
```

## 允许生产管理员创建项目
> 在本节中，您将配置先前创建的平台管理员组，以便其成员可以为每个人创建项目

* 1 Log in as system:admin and select the default project:
```
oc login -u system:admin
oc project default
```
* 2 Use oc adm policy again, but this time add the cluster role of self-provisioner to the ocp-production group.
```
oc adm policy add-cluster-role-to-group self-provisioner ocp-production
```
* 3 Log in as one of the prod1 or prod2 production administrators:
```
oc login -u prod1 -p r3dh4t1!
```
* 4 Create a new project and verify that it works:
```
oc new-project thiswillwork
```
* Sample Output
```
Now using project "thiswillwork" on server "https://loadbalancer1.c3fc.internal:443".

You can add applications to this project with the 'new-app' command. For example, try:

    oc new-app centos/ruby-22-centos7~https://github.com/openshift/ruby-ex.git

to build a new example application in Ruby.
```