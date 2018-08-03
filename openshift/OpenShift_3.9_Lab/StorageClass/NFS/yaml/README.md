``` bash
oc create -f rbac.yaml 
oc adm policy add-scc-to-user hostmount-anyuid system:serviceaccount:default:nfs-client-provisioner
oc adm policy add-cluster-role-to-user nfs-client-provisioner-runner system:serviceaccount:default:nfs-client-provisioner
oc create -f deployer.yaml

oc create -f storageclass.yaml

# for test 
oc create -f Test-nginx-statefulset.yaml

```