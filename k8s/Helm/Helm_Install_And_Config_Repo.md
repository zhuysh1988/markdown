# Helm Install 

## 1 准备:

* 一个K8S 集群

## 2 在K8S_Master节点下载/安装Helm 

### 可以连接外网
* tiller 
``` 
使用 :
registry.cn-hangzhou.aliyuncs.com/origin/tiller:v2.7.2
```
* 进入 https://github.com/kubernetes/helm/releases 下载helm command version
``` bash
wget https://github.com/kubernetes/helm/archive/v2.7.2.tar.gz 
```
* 解压文件
``` bash
tar -zxvf helm-v2.0.0-linux-amd64.tgz
```
* 移动helm文件至/usr/bin/
``` bash
mv linux-amd64/helm /usr/bin/
```


### 不能连接外网
* 所有k8s节点  Load tiller镜像
``` bash
docker load -i tiller-2.7.2.tar
tar xf helm-v2.7.2-linux-amd64.tar.gz 
mv linux-amd64/helm /usr/bin/
```

### 查看Helm版本
``` bash
helm version
Client: &version.Version{SemVer:"v2.7.2", GitCommit:"8478fb4fc723885b155c924d1c8c410b7a9444e6", GitTreeState:"clean"}
Server: &version.Version{SemVer:"v2.7.2", GitCommit:"8478fb4fc723885b155c924d1c8c410b7a9444e6", GitTreeState:"clean"}
```


## 3 配置Helm在K8S集群中的权限

### tiller 运行在k8s集群内网络:
``` bash 
# create sa
kubectl create serviceaccount --namespace kube-system tiller
# 
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
# run k8s network
helm init \
--service-account tiller \
--tiller-image gcr.io/kubernetes-helm/tiller:v2.7.2 \
--stable-repo-url https://aliacs-app-catalog.oss-cn-hangzhou.aliyuncs.com/charts/ \
--upgrade

# patch 
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
```
### tiller 运行在外部网络:

```bash
# create sa
kubectl create serviceaccount --namespace kube-system tiller
# 
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
# lable node : master2.example.com 
kubectl lable node master2.example.com app=tiller
kubectl lable node master2.example.com helm=rocks
# run net=host in master2.example.com , stable repo use aliyun 
helm init \
--service-account tiller \
--tiller-image gcr.io/kubernetes-helm/tiller:v2.7.2 \
--node-selectors "app=tiller,helm=rocks" \
--upgrade
--net-host \
--stable-repo-url https://aliacs-app-catalog.oss-cn-hangzhou.aliyuncs.com/charts/ \
# patch deploy
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
```
* 检查
``` bash
[root@master2 helm]# ss -luntp |grep 4413
tcp    LISTEN     0      128      :::44134                :::*                   users:(("tiller",pid=63270,fd=3))
tcp    LISTEN     0      128      :::44135                :::*                   users:(("tiller",pid=63270,fd=5))
``` 

### 没有网络的环境,运行

``` bash
# create sa
kubectl create serviceaccount --namespace kube-system tiller
# 
kubectl create clusterrolebinding tiller-cluster-rule --clusterrole=cluster-admin --serviceaccount=kube-system:tiller

helm init --service-account tiller --tiller-image gcr.io/kubernetes-helm/tiller:v2.7.2 --skip-refresh

# patch deploy
kubectl patch deploy --namespace kube-system tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
```

## 4 配置Repo 

* 检查现有repo
* * 如果是无外网环境, 只能添加local repo 
``` bash
helm repo list 
NAME     	URL                                                                      
stable   	https://aliacs-app-catalog.oss-cn-hangzhou.aliyuncs.com/charts/  
```

* 添加 阿里repo 
``` bash
helm repo add incubator https://aliacs-app-catalog.oss-cn-hangzhou.aliyuncs.com/charts-incubator/
helm repo add stable https://aliacs-app-catalog.oss-cn-hangzhou.aliyuncs.com/charts/
```


###  添加 local repo 
* 启用 local repo 
``` bash
nohup helm serve --address "0.0.0.0:8879" --repo-path "/root/.helm/repository/local" & 
```
* 添加 local repo 
``` bash
helm repo add local http://IP:8879/charts/
```

## 5 部署 WordPress
> 下面我们将利用 Helm，来部署一个 WordPress 博客网站。

* 输入如下命令。
``` bash
helm install --name wordpress-test --set "persistence.enabled=false,mariadb.persistence.enabled=false" stable/wordpress
```
helm install --name=ceph incubator/ceph --namespace=ceph -f ~/ceph-overrides.yaml

--set "manifests.deployment_rgw=false,manifests.deployment_mds=false,manifests.secret_keystone_rgw=false,manifests.service_rgw=false" 

> 注意：目前阿里云 Kubernetes 服务中还没有开启块存储的 PersistentVolume 支持，所以在示例中禁止了数据持久化。
> 查看svc nodePort 端口, 访问http://ip:port/admin 

* 得到如下的结果。
```
NAME:   wordpress-test
LAST DEPLOYED: Mon Nov  20 19:01:55 2017
NAMESPACE: default
STATUS: DEPLOYED
...

# 利用如下命令查看 WordPress 的 release 和 service。

helm list
kubectl get svc

#利用如下命令查看 WordPress 相关的 Pod，并等待其状态变为 Running。

kubectl get pod
#利用如下命令获得 WordPress 的访问地址。

echo http://$(kubectl get svc wordpress-test-wordpress -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
#通过上面的 URL，可以在浏览器上看到熟悉的 WordPress 站点。

#也可以根据 Charts 的说明，利用如下命令获得 WordPress 站点的管理员用户和密码。

echo Username: user
echo Password: $(kubectl get secret --namespace default wordpress-test-wordpress -o jsonpath="{.data.wordpress-password}" | base64 --decode)

#如需彻底删除 WordPress 应用，可输入如下命令。

helm delete --purge wordpress-test
```