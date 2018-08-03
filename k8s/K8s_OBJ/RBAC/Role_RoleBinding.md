一些角色定义的例子
在以下示例中，我们仅截取展示了rules部分的定义。

允许读取core API Group中定义的资源”pods”：

rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list", "watch"]
允许读写在”extensions”和”apps” API Group中定义的”deployments”：

rules:
- apiGroups: ["extensions", "apps"]
  resources: ["deployments"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
允许读取”pods”以及读写”jobs”：

rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["batch", "extensions"]
  resources: ["jobs"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
允许读取一个名为”my-config”的ConfigMap实例（需要将其通过RoleBinding绑定从而限制针对某一个命名空间中定义的一个ConfigMap实例的访问）：

rules:
- apiGroups: [""]
  resources: ["configmaps"]
  resourceNames: ["my-config"]
  verbs: ["get"]
允许读取core API Group中的”nodes”资源（由于Node是集群级别资源，所以此ClusterRole定义需要与一个ClusterRoleBinding绑定才能有效）：

rules:
- apiGroups: [""]
  resources: ["nodes"]
  verbs: ["get", "list", "watch"]
允许对非资源endpoint “/healthz”及其所有子路径的”GET”和”POST”请求（此ClusterRole定义需要与一个ClusterRoleBinding绑定才能有效）：

rules:
- nonResourceURLs: ["/healthz", "/healthz/*"] # 在非资源URL中，'*'代表后缀通配符
  verbs: ["get", "post"]
对角色绑定主体（Subject）的引用
RoleBinding或者ClusterRoleBinding将角色绑定到角色绑定主体（Subject）。 角色绑定主体可以是用户组（Group）、用户（User）或者服务账户（Service Accounts）。

用户由字符串表示。可以是纯粹的用户名，例如”alice”、电子邮件风格的名字，如 “bob@example.com” 或者是用字符串表示的数字id。由Kubernetes管理员配置认证模块 以产生所需格式的用户名。对于用户名，RBAC授权系统不要求任何特定的格式。然而，前缀system:是 为Kubernetes系统使用而保留的，所以管理员应该确保用户名不会意外地包含这个前缀。

Kubernetes中的用户组信息由授权模块提供。用户组与用户一样由字符串表示。Kubernetes对用户组 字符串没有格式要求，但前缀system:同样是被系统保留的。

服务账户拥有包含 system:serviceaccount:前缀的用户名，并属于拥有system:serviceaccounts:前缀的用户组。

角色绑定的一些例子
以下示例中，仅截取展示了RoleBinding的subjects字段。

一个名为”alice@example.com”的用户：

subjects:
- kind: User
  name: "alice@example.com"
  apiGroup: rbac.authorization.k8s.io
一个名为”frontend-admins”的用户组：

subjects:
- kind: Group
  name: "frontend-admins"
  apiGroup: rbac.authorization.k8s.io
kube-system命名空间中的默认服务账户：

subjects:
- kind: ServiceAccount
  name: default
  namespace: kube-system
名为”qa”命名空间中的所有服务账户：

subjects:
- kind: Group
  name: system:serviceaccounts:qa
  apiGroup: rbac.authorization.k8s.io
在集群中的所有服务账户：

subjects:
- kind: Group
  name: system:serviceaccounts
  apiGroup: rbac.authorization.k8s.io
所有认证过的用户（version 1.5+）：

subjects:
- kind: Group
  name: system:authenticated
  apiGroup: rbac.authorization.k8s.io
所有未认证的用户（version 1.5+）：

subjects:
- kind: Group
  name: system:unauthenticated
  apiGroup: rbac.authorization.k8s.io
所有用户（version 1.5+）：

subjects:
- kind: Group
  name: system:authenticated
  apiGroup: rbac.authorization.k8s.io
- kind: Group
  name: system:unauthenticated
  apiGroup: rbac.authorization.k8s.io