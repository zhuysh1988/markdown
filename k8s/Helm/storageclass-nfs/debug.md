[debug] Created tunnel using local port: '37441'

[debug] SERVER: "127.0.0.1:37441"

[debug] Original chart version: ""
[debug] CHART PATH: /opt/gitroot/k8s/helm/storageclass-nfs

NAME:   listless-armadillo
REVISION: 1
RELEASED: Thu Jun  7 11:59:31 2018
CHART: storageclass-nfs-0.1.0
USER-SUPPLIED VALUES:
namespace: bocloud
provisioner:
  nfs: true
  nfspath: /nfs
  nfsserver: 192.168.6.85
rbac: bocloud-provisioner
resources:
  limits:
    cpu: 1000m
    memory: 1024Mi
  requests:
    cpu: 500m
    memory: 512Mi

COMPUTED VALUES:
image:
  imagepullpolicy: IfNotPresent
  repository: registry.cn-hangzhou.aliyuncs.com/jhr-k8s/nfs-client-provisioner
  tag: latest
lables:
  company:
    key: company
    value: BoCloud
  department:
    key: department
    value: services
  environment:
    key: environment
    value: dev-and-testing
  group:
    key: group
    value: poc-and-testing
namespace: bocloud
provisioner:
  localpath: /srv
  name: bocloud.com/nfs
  nfs: true
  nfspath: /nfs
  nfsserver: 192.168.6.85
rbac: bocloud-provisioner
replicaCount: 1
resources:
  limits:
    cpu: 1000m
    memory: 1024Mi
  requests:
    cpu: 500m
    memory: 512Mi
storageclass:
  isdefault: true
  name: nfs-bocloud
  systemservices: true

HOOKS:
MANIFEST:

---
# Source: storageclass-nfs/templates/namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: bocloud
---
# Source: storageclass-nfs/templates/storageclass.yaml
kind: StorageClass
apiVersion: storage.k8s.io/v1beta1
metadata:
  name: nfs-bocloud
  annotations:
    storageclass.beta.kubernetes.io/is-default-class: "true"
  
  labels:
    kubernetes.io/cluster-service: "true"
  
provisioner: bocloud.com/nfs
---
# Source: storageclass-nfs/templates/rbac.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: bocloud-provisioner
  namespace: bocloud
---
# Source: storageclass-nfs/templates/rbac.yaml
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: bocloud-provisioner
rules:
  - apiGroups: [""]
    resources: ["persistentvolumes"]
    verbs: ["get", "list", "watch", "create", "delete"]
  - apiGroups: [""]
    resources: ["persistentvolumeclaims"]
    verbs: ["get", "list", "watch", "update"]
  - apiGroups: ["storage.k8s.io"]
    resources: ["storageclasses"]
    verbs: ["get", "list", "watch"]
  - apiGroups: [""]
    resources: ["events"]
    verbs: ["watch", "create", "update", "patch", "list"]
  - apiGroups: [""]
    resources: ["services", "endpoints"]
    verbs: ["get"]
---
# Source: storageclass-nfs/templates/rbac.yaml
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: bocloud-provisioner
subjects:
  - kind: ServiceAccount
    name: bocloud-provisioner
    namespace: bocloud
roleRef:
  kind: ClusterRole
  name: bocloud-provisioner
  apiGroup: rbac.authorization.k8s.io
---
# Source: storageclass-nfs/templates/services.yaml
kind: Service
apiVersion: v1
metadata:
  name: bocloud-provisioner
  namespace: bocloud 
  labels:
    company: BoCloud
    department: services
    group: poc-and-testing
    environment: dev-and-testing
    app: bocloud-provisioner
    version: 0.1.0    
spec:
  ports:
    - name: nfs
      port: 2049
    - name: mountd
      port: 20048
    - name: rpcbind
      port: 111
    - name: rpcbind-udp
      port: 111
      protocol: UDP
  selector:
    company: BoCloud
    department: services
    group: poc-and-testing
    environment: dev-and-testing
    app: bocloud-provisioner
    version: 0.1.0
---
# Source: storageclass-nfs/templates/deployment-nfs-provisioner.yaml
kind: Deployment
apiVersion: extensions/v1beta1
metadata:
  name: bocloud-provisioner
  namespace: bocloud
  labels:
    company: BoCloud
    department: services
    group: poc-and-testing
    environment: dev-and-testing
    app: bocloud-provisioner
    version: 0.1.0    
spec:
  replicas: 1
  strategy:
    type: Recreate 
  template:
    metadata:
      labels:
        company: BoCloud
        department: services
        group: poc-and-testing
        environment: dev-and-testing
        app: bocloud-provisioner
        version: 0.1.0
    spec:
      serviceAccount: bocloud-provisioner
      containers:
        - name: bocloud-provisioner
          image: registry.cn-hangzhou.aliyuncs.com/jhr-k8s/nfs-client-provisioner:latest
          resources:
            limits:
              cpu: 1000m
              memory: 1024Mi
            requests:
              cpu: 500m
              memory: 512Mi
            
          env:
            - name: PROVISIONER_NAME
              value: bocloud.com/nfs
            - name: NFS_SERVER
              value: 192.168.6.85
            - name: NFS_PATH
              value: /nfs            
          imagePullPolicy: IfNotPresent
          volumeMounts:
            - name: export-volume
              mountPath: /persistentvolumes
      volumes:
        - name: export-volume
          nfs:
            server: 192.168.6.85
            path: /nfs
