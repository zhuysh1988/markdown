

## 简介
>  在高级安装期间，可以使用openshift_master_named_certificates和openshift_master_overwrite_named_certificates参数配置自定义证书，这些参数可在清单文件中进行配置。有关使用Ansible配置自定义证书的更多详细信息。

```conf
openshift_master_overwrite_named_certificates=true 
openshift_master_named_certificates=[{"certfile": "/path/on/host/to/crt-file", "keyfile": "/path/on/host/to/key-file", "names": ["public-master-host.com"], "cafile": "/path/on/host/to/ca-file"}] 
openshift_hosted_router_certificate={"certfile": "/path/on/host/to/app-crt-file", "keyfile": "/path/on/host/to/app-key-file", "cafile": "/path/on/host/to/app-ca-file"} 
```


## 配置master主机证书
> 为了促进与OpenShift Container Platform的外部用户的可信连接，您可以在Ansible清单文件中配置与openshift_master_cluster_public_hostname参数中提供的域名匹配的命名证书，默认情况下为/ etc / ansible / hosts。

> 您必须将此证书放置在Ansible可访问的目录中，并在Ansible清单文件中添加路径，如下所示：
```
openshift_master_named_certificates=[{"certfile": "/path/to/console.ocp-c1.myorg.com.crt", "keyfile": "/path/to/console.ocp-c1.myorg.com.key", "names": ["console.ocp-c1.myorg.com"]}]

```


```
When securing the registry, add the service hostnames and IP addresses to the server certificate for the registry. The Subject Alternative Names (SAN) must contain the following.

Two service hostnames:

docker-registry.default.svc.cluster.local
docker-registry.default.svc
Service IP address.

For example:

172.30.252.46
Use the following command to get the Docker registry service IP address:

oc get service docker-registry --template='{{.spec.clusterIP}}'
Public hostname.

docker-registry-default.apps.example.com
Use the following command to get the Docker registry public hostname:

oc get route docker-registry --template '{{.spec.host}}'
For example, the server certificate should contain SAN details similar to the following:

X509v3 Subject Alternative Name:
               DNS:docker-registry-public.openshift.com, DNS:docker-registry.default.svc, DNS:docker-registry.default.svc.cluster.local
```


## 为默认路由器配置自定义通配符证书

> 为了配置默认通配符证书，请设置一个对<.app_domain>有效的证书，其中<app_domain>是Ansible清单文件中openshift_master_default_subdomain的值，缺省情况下是/ etc / ansible / hosts。设置后，将证书，密钥和ca证书文件放在Ansible主机上，并将以下行添加到Ansible清单文件中。

```
openshift_hosted_router_certificate={"certfile": "/path/to/apps.c1-ocp.myorg.com.crt", "keyfile": "/path/to/apps.c1-ocp.myorg.com.key", "cafile": "/path/to/apps.c1-ocp.myorg.com.ca.crt"}
For example:

openshift_hosted_router_certificate={"certfile": "/home/cloud-user/star-apps.148.251.233.173.nip.io.cert.pem", "keyfile": "/home/cloud-user/star-apps.148.251.233.173.nip.io.key.pem", "cafile": "/home/cloud-user/ca-chain.cert.pem"}
Where the parameter values are:

certfile is the path to the file that contains the OpenShift Container Platform router certificate.

keyfile is the path to the file that contains the OpenShift Container Platform wildcard key.

cafile is the path to the file that contains the root CA for this key and certificate. If an intermediate CA is in use, the file should contain both the intermediate and root CA.
```
> 如果这些证书文件是OpenShift Container Platform集群的新文件，请运行Ansible deploy_router.yml playbook将这些文件添加到OpenShift Container >Platform配置文件中。该手册将证书文件添加到/ etc / origin / master /目录。


# ansible-playbook [-i /path/to/inventory] \
    /usr/share/ansible/openshift-ansible/playbooks/openshift-hosted/deploy_router.yml

例如，如果证书不是新证书，您要更改现有证书或替换过期证书，请运行以下playbook：

ansible-playbook /usr/share/ansible/openshift-ansible/playbooks/redeploy-certificates.yml


