https://github.com/kubernetes/ingress-nginx  

aliyun image address: 
registry.cn-hangzhou.aliyuncs.com/google_containers/defaultbackend:1.4
registry.cn-hangzhou.aliyuncs.com/google_containers/nginx-ingress-controller:0.14.0

registry.cn-hangzhou.aliyuncs.com/jhr-k8s/nginx-ingress-controller:0.14.0
registry.cn-hangzhou.aliyuncs.com/jhr-k8s/defaultbackend:1.4


Mandatory commands
```
curl https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/namespace.yaml  | kubectl apply -f -
curl https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/default-backend.yaml | kubectl apply -f -
curl https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/configmap.yaml  | kubectl apply -f -
curl https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/tcp-services-configmap.yaml | kubectl apply -f -
curl https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/udp-services-configmap.yaml | kubectl apply -f -
```

Install with RBAC roles
```
wget https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/rbac.yaml
wget https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/with-rbac.yaml
   
vim with-rbac.yaml  修改三处
1. kind: Deployment 改成kind: DaemonSet
2. replicas: 1  删除
3. initContainers:上面一行加hostNetwork: true #两句平级

导入
kubectl create -f rbac.yaml 
kubectl create -f with-rbac.yaml


[root@master1 ~]# kubectl label node master1.example.com host=ingress
node "master1.example.com" labeled
[root@master1 ~]# kubectl label node master2.example.com host=ingress
node "master2.example.com" labeled
[root@master1 ~]# kubectl label node master3.example.com host=ingress
node "master3.example.com" labeled

      serviceAccountName: nginx-ingress-serviceaccount
      nodeSelector:
        host: ingress
      containers:
        - name: nginx-ingress-controller
          #image: quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.14.0
          image: registry.cn-hangzhou.aliyuncs.com/google_containers/nginx-ingress-controller:0.14.0
          args:

