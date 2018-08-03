# Test Network Policy 

## set network policy 
```
curl -o ./migrate-network-policy.sh https://raw.githubusercontent.com/openshift/origin/master/contrib/migration/migrate-network-policy.sh

chmod +x migrate-network-policy.sh 


./migrate-network-policy.sh 

```
* out 
```
NAMESPACE: default
Namespace is global: adding label legacy-netid=0

NAMESPACE: kube-public
networkpolicy "default-deny" created
networkpolicy "allow-from-self" created
networkpolicy "allow-from-global-namespaces" created

NAMESPACE: kube-service-catalog
Namespace is global: adding label legacy-netid=0

NAMESPACE: kube-system
networkpolicy "default-deny" created
networkpolicy "allow-from-self" created
networkpolicy "allow-from-global-namespaces" created

NAMESPACE: logging
networkpolicy "default-deny" created
networkpolicy "allow-from-self" created
networkpolicy "allow-from-global-namespaces" created

NAMESPACE: management-infra
networkpolicy "default-deny" created
networkpolicy "allow-from-self" created
networkpolicy "allow-from-global-namespaces" created

NAMESPACE: openshift
networkpolicy "default-deny" created
networkpolicy "allow-from-self" created
networkpolicy "allow-from-global-namespaces" created

NAMESPACE: openshift-infra
networkpolicy "default-deny" created
networkpolicy "allow-from-self" created
networkpolicy "allow-from-global-namespaces" created

NAMESPACE: openshift-metrics
networkpolicy "default-deny" created
networkpolicy "allow-from-self" created
networkpolicy "allow-from-global-namespaces" created

NAMESPACE: openshift-node
networkpolicy "default-deny" created
networkpolicy "allow-from-self" created
networkpolicy "allow-from-global-namespaces" created

NAMESPACE: openshift-template-service-broker
networkpolicy "default-deny" created
networkpolicy "allow-from-self" created
networkpolicy "allow-from-global-namespaces" created

NAMESPACE: openshift-web-console
networkpolicy "default-deny" created
networkpolicy "allow-from-self" created
networkpolicy "allow-from-global-namespaces" created

Renumbering formerly-shared namespaces: kube-service-catalog

```


# 启用 network policy 

## 修改/etc/ansible/hosts

```
# -----------------This network 
#os_sdn_network_plugin_name='redhat/openshift-ovs-multitenant'
os_sdn_network_plugin_name='redhat/openshift-ovs-networkpolicy'


```

## 两种方法生效
### 1) Run the deploy_cluster playbook to update all of the nodes in the cluster. It takes about 20 minutes.
```
ansible-playbook -f 20 /usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml
```

### 2) Alternatively, change the plug-in directly in the node-config.yaml and master-config.yaml configuration files:

```bash
ansible masters -m shell -a "sed -i -e 's/openshift-ovs-multitenant/openshift-ovs-networkpolicy/g' /etc/origin/master/master-config.yaml"
ansible nodes -m shell -a "sed -i -e 's/openshift-ovs-multitenant/openshift-ovs-networkpolicy/g' /etc/origin/node/node-config.yaml"

ansible masters -m shell  -a"systemctl stop atomic-openshift-master-api"
ansible masters -m shell -a"systemctl stop atomic-openshift-master-controllers"
ansible nodes -m shell -a"systemctl stop atomic-openshift-node"
ansible nodes -m shell -a"systemctl restart openvswitch"

sleep 30

ansible masters -m shell -a"systemctl start atomic-openshift-master-api"
ansible masters -m shell -a"systemctl start atomic-openshift-master-controllers"

sleep 15

ansible masters -m shell -a"systemctl start atomic-openshift-node" # (make sure masters are up before nodes)

sleep 10

ansible nodes -m shell -a"systemctl start atomic-openshift-node"

``` yaml
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: allow-3306
  namespace
spec:
 podSelector:
   matchLabels:
     app: mysql
 ingress:
 - from:
   - podSelector:
       matchLabels:
         app: emailsvc
   ports:
   - protocol: TCP
     port: 3306
```

```bash
for pro in msclient  msservices  msinfra ;do 
oc -n $pro get pod,svc,route,networkpolicy |tee ${pro}.objs.txt
done
```

## cat msinfra.objs.txt 
```
NAME                  READY     STATUS      RESTARTS   AGE
po/emailsvc-1-4bhn9   1/1       Running     0          2h
po/mysql-1-dq7sq      1/1       Running     0          2h
NAME           TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
svc/emailsvc   ClusterIP   172.30.10.202   <none>        8080/TCP   2h
svc/mysql      ClusterIP   172.30.11.232   <none>        3306/TCP   2h
NAME                         POD-SELECTOR   AGE
netpol/allow-3306            app=mysql      13m
netpol/allow-8080-emailsvc   app=emailsvc   4m
netpol/default-deny          <none>         4m
```
## cat msservices.objs.txt 
NAME                     READY     STATUS      RESTARTS   AGE
po/mongodb-1-tgjjr       1/1       Running     0          2h
po/twitter-api-1-bth2w   1/1       Running     0          2h
po/userregsvc-1-t4wph    1/1       Running     0          2h
NAME              TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                      AGE
svc/mongodb       ClusterIP   172.30.190.238   <none>        27017/TCP                    2h
svc/twitter-api   ClusterIP   172.30.148.154   <none>        8080/TCP,8443/TCP,8778/TCP   2h
svc/userregsvc    ClusterIP   172.30.137.167   <none>        8080/TCP                     2h
NAME                 HOST/PORT                                              PATH      SERVICES      PORT       TERMINATION   WILDCARD
routes/twitter-api   twitter-api-msservices.apps.99a0.example.opentlc.com             twitter-api   8080-tcp                 None
routes/userregsvc    userregsvc-msservices.apps.99a0.example.opentlc.com              userregsvc    8080-tcp                 None
NAME                           POD-SELECTOR      AGE
netpol/allow-27017             app=mongodb       4m
netpol/allow-8080-twitter      app=twitter-api   4m
netpol/allow-8080-userregsvc   app=userregsvc    4m
netpol/default-deny            <none>            5m

## cat msclient.objs.txt 
NAME                 READY     STATUS      RESTARTS   AGE
po/userreg-1-h9n96   1/1       Running     0          2h
NAME          TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)             AGE
svc/userreg   ClusterIP   172.30.112.75   <none>        8080/TCP,8443/TCP   2h
NAME             HOST/PORT                                        PATH      SERVICES   PORT       TERMINATION   WILDCARD
routes/userreg   userreg-msclient.apps.99a0.example.opentlc.com             userreg    8080-tcp                 None
NAME                         POD-SELECTOR   AGE
netpol/allow-8080-frontend   app=userreg    5m
netpol/default-deny          <none>         6m





## This run migrate-network-policy.sh 
* oc -n openshift get networkpolicy allow-from-global-namespaces allow-from-self default-deny -o yaml
```yaml
apiVersion: v1
items:
- apiVersion: extensions/v1beta1
  kind: NetworkPolicy
  metadata:
    name: allow-from-global-namespaces
    namespace: openshift
  spec:
    ingress:
    - from:
      - namespaceSelector:
          matchLabels:
            pod.network.openshift.io/legacy-netid: "0"
    podSelector: {}
    policyTypes:
    - Ingress
- apiVersion: extensions/v1beta1
  kind: NetworkPolicy
  metadata:
    name: allow-from-self
    namespace: openshift
  spec:
    ingress:
    - from:
      - podSelector: {}
    podSelector: {}
    policyTypes:
    - Ingress
- apiVersion: extensions/v1beta1
  kind: NetworkPolicy
  metadata:
    name: default-deny
    namespace: openshift
  spec:
    podSelector: {}
    policyTypes:
    - Ingress
kind: List
metadata:
  resourceVersion: ""
  selfLink: ""
```