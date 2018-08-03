



## roles user bindings 关系图

* The relationships between cluster roles, local roles, cluster role bindings, local role bindings, users, groups and service accounts are illustrated below.

* 集群角色，本地角色，集群角色绑定，本地角色绑定，用户，组和服务帐户之间的关系如下所示。

![rbac](./images/rbac-user.png)


## role or cluster-role
* oc get clusterrole basic-user -o yaml
```yaml
apiVersion: authorization.openshift.io/v1
kind: ClusterRole
metadata:
  annotations:
    openshift.io/description: A user that can get basic information about projects.
    openshift.io/reconcile-protect: "false"
  name: basic-user
rules:
- apiGroups:
  - ""
  - user.openshift.io
  attributeRestrictions: null
  resourceNames:
  - "~"
  resources:
  - users
  verbs:
  - get
- apiGroups:
  - ""
  - project.openshift.io
  attributeRestrictions: null
  resources:
  - projectrequests
  verbs:
  - list
- apiGroups:
  - ""
  - authorization.openshift.io
  attributeRestrictions: null
  resources:
  - clusterroles
  verbs:
  - get
  - list
- apiGroups:
  - rbac.authorization.k8s.io
  attributeRestrictions: null
  resources:
  - clusterroles
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - storage.k8s.io
  attributeRestrictions: null
  resources:
  - storageclasses
  verbs:
  - get
  - list
- apiGroups:
  - ""
  - project.openshift.io
  attributeRestrictions: null
  resources:
  - projects
  verbs:
  - list
  - watch
- apiGroups:
  - ""
  - authorization.openshift.io
  attributeRestrictions: null
  resources:
  - selfsubjectrulesreviews
  verbs:
  - create
- apiGroups:
  - authorization.k8s.io
  attributeRestrictions: null
  resources:
  - selfsubjectaccessreviews
  verbs:
  - create
```

* oc get clusterrolebinding  system:basic-user -o yaml 
```yaml
apiVersion: authorization.openshift.io/v1
groupNames:
- system:authenticated
- system:unauthenticated
kind: ClusterRoleBinding
metadata:
  annotations:
    openshift.io/reconcile-protect: "false"
  labels:
    kubernetes.io/bootstrapping: rbac-defaults
  name: system:basic-user
  resourceVersion: "260"
  selfLink: /apis/authorization.openshift.io/v1/clusterrolebindings/system%3Abasic-user
  uid: a5f18b5e-834b-11e8-8ba6-0a9c9de99c0e
roleRef:
  name: system:basic-user
subjects:
- kind: SystemGroup
  name: system:authenticated
- kind: SystemGroup
  name: system:unauthenticated
userNames: null
```


