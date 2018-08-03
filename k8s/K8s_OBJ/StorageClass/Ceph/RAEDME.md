## ceph admin key 在kube-system  , k8s key 在default 

* Create a Ceph admin secret

```bash
ceph auth get client.admin 2>&1 |grep "key = " |awk '{print  $3'} |xargs echo -n > /tmp/secret
kubectl create secret generic ceph-admin-secret --from-file=/tmp/secret --namespace=kube-system
```

* Create a Ceph pool and a user secret

```bash
ceph osd pool create rbd 8 8
ceph auth add client.k8s mon 'allow r' osd 'allow rwx pool=rbd'
ceph auth get client.k8s 2>&1 |grep "key = " |awk '{print  $3'} |xargs echo -n > /tmp/secret
kubectl create secret generic ceph-secret --from-file=/tmp/secret --namespace=default
```

* Create a Ceph pool and a user secret

```bash
ceph osd pool create kube 8 8
ceph auth add client.kube mon 'allow r' osd 'allow rwx pool=kube'
ceph auth get client.kube 2>&1 |grep "key = " |awk '{print  $3'} |xargs echo -n > /tmp/secret
kubectl create secret generic ceph-secret --from-file=/tmp/secret --namespace=kube-system
```