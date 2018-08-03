

``` bash
kubectl run demo-nginx --replicas=2 --labels="app=nginx" --image=nginx --port=80
kubectl get pods --selector="app=nginx"

[root@master1 .kube]# kubectl get pods --selector="app=nginx"
NAME                          READY     STATUS    RESTARTS   AGE
demo-nginx-5b76fb656b-gjvrn   1/1       Running   0          1m
demo-nginx-5b76fb656b-nnz7r   1/1       Running   0          1m


kubectl expose deployment demo-nginx --type=NodePort --name=demo-nginx-svc


kubectl run busybox -it --image=busybox --restart=Never --rm
```