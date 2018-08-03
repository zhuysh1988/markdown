## Helm快速入门


### 基本知识

> 痛点回顾： 没有Helm之前，我们在Kubernetes上部署一个稍微复杂点的应用：比如由Web UI项目和API项目、甚至还包含Mysql数据库组成的一个网站，我们需要

* 先创建API项目的K8s deployment，这部可能需要设定一系列环境变量
* 接着为了对外暴露服务创建K8s service，记住服务端口号和地址。
* 准备Web项目，指定API地址和其他相应环境变量，创建Web项目的K8s deployment
* 对外暴露服务 创建Web项目的K8s service
```
每次都需要操作这么多步骤才能Run起一个网站，想想好麻烦，有木有更好的方式，把这些步骤都组合起来一次执行完，而执行者不用关注各服务是如何连接和配置的？
Docker镜像是把一个单纯的App和它的安装环境整合在一起。
Kubertnetes管理Docker容器的生成和毁灭，保证Docker容器对应App的高可用（监控、自动创建）和易维护（部署和对外暴露、动态扩容、启动停止删除等）。
```
* Helm是为了方便配置和部署、升级和回滚应用，尤其是多个Service组合创建的一个大型应用，比如网站。


### 打七寸 - Helm的本质
* Helm本质就是
```
让K8s的清单（Deployment, Service等)可配置，能动态生成
Helm能够实现可配置的发布是通过模板加配置文件，动态生成K8s资源清单文件来完成的（deployment.yaml， service.yaml）。
按照动态生成的清单，调用Kubectl自动执行K8s资源部署
```
* 特别说明
```
本文提到Kubernetes时也可能会用它的简称 K8s
YAML文件没什么特别的，不要被它的名字吓到，它实际就是一种配置文件的格式，见过Json格式的配置文件不？ 它只是另一种格式而已。
```
#### 要点
```
Helm是一个Chart管理器: GitHub - kubernetes/helm: The Kubernetes Package Manager
Charts是一组配置好的Kubernetes资源（定义）组合
Release是一组已经部署到Kubernetes上的资源集合
Chart的基本结构

.
├── Chart.yaml
├── README.md
├── templates
│   ├── NOTES.txt
│   ├── _helpers.tpl
│   ├── deployment.yaml
│   ├── pvc.yaml
│   ├── secrets.yaml
│   └── svc.yaml
└── values.yaml

用途
创建可配置的Release
升级、删除、查看由Helm创建的Release
组成
helm客户端
制作、拉取、查找和验证 Chart
安装服务端Tiller
指示服务端Tiller做事，比如根据chart创建一个Release
helm服务端 tiller
安装在Kubernetes集群内的一个应用， 用来执行客户端发来的命令，管理Release

```
## 安装
```
安装Helm客户端

在Mac上，使用Homebrew命令

brew install kubernetes-helm
直接下载编译好的包

下载期望的版本
解压 tar -zxvf helm-v2.0.0-linux-amd64.tgz
在解压后的文件夹中找到Helm命令所在位置, 将它移动到期望位置（要在shell默认搜索的位置） mv linux-amd64/helm /usr/local/bin/helm
使用sh脚本安装， 它会自动安装最新版的Helm

$ curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh
$ chmod 700 get_helm.sh
$ ./get_helm.sh
安装服务端
安装好 Helm 后，通过键入如下命令，在 Kubernetes 群集上安装或升级 Tiller：

helm init --upgrade
在缺省配置下， Helm 会利用 “gcr.io/kubernetes-helm/tiller” 镜像在Kubernetes集群上安装配置 Tiller；并且利用 “https://kubernetes-charts.storage.googleapis.com“ 作为缺省的 stable repository 的地址。由于在国内可能无法访问 “gcr.io”, “storage.googleapis.com” 等域名，阿里云容器服务为此提供了镜像站点。

请执行如下命令利用阿里云的镜像来配置 Helm服务端 Tiller

helm init --upgrade -i registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:v2.6.2 --stable-repo-url https://kubernetes.oss-cn-hangzhou.aliyuncs.com/chart
安装好后，可以使用kubectl get pods --namespace kube-system 查看安装情况。

同理，Helm客户端的 stable repo地址也需要更新

helm init -c --stable-repo-url https://kubernetes.oss-cn-hangzhou.aliyuncs.com/chart
客户端也可以通过修改 ~/.helm/repository/repositories.yaml 中的repositories.url来实现
```

### 帮助文档
```
helm help 查看helm支持的命令
helm somecommand -h 查看某个命令的使用方法
helm version 查看客户端和服务端的版本，如果只显示了客户端版本，说明没有连上服务端。 它会自动去K8s上kube-system命名空间下查找是否有Tiller的Pod在运行，除非你通过 --tiller-namespace标签 or TILLER_NAMESPACE环境变量指定
```
## 使用Chart
### 核心命令
```
helm search 查找可用的Charts
helm inspect 查看指定Chart的基本信息
helm install 根据指定的Chart 部署一个Release到K8s
helm create 创建自己的Chart
helm package 打包Chart，一般是一个压缩包文件
示例

Example: 安装Mysql

helm repo update
helm install stable/mysql
Released smiling-penguin
每次安装都有一个Release被创建， 所以一个Chart可以在同一个集群中被安装多次，每一个都是独立管理和升级的。
其中 stable/mysql是Chart名， smiling-penguid 是Release名，后面管理Release时都是用的这个名字。

在使用一个Chart前，查看它的默认配置，然后使用配置文件覆盖它的默认设置
$ helm inspect values stable/mariadb
Fetched stable/mariadb-0.3.0.tgz to /Users/mattbutcher/Code/Go/src/k8s.io/helm/mariadb-0.3.0.tgz
## Bitnami MariaDB image version
## ref: https://hub.docker.com/r/bitnami/mariadb/tags/
##
## Default: none
imageTag: 10.1.14-r3
## Specify a imagePullPolicy
## Default to 'Always' if imageTag is 'latest', else set to 'IfNotPresent'
## ref: http://kubernetes.io/docs/user-guide/images/#pre-pulling-images
##
# imagePullPolicy:
## Specify password for root user
## ref: https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#setting-the-root-password-on-first-run
##
# mariadbRootPassword:
## Create a database user
## ref: https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#creating-a-database-user-on-first-run
##
# mariadbUser:
# mariadbPassword:
## Create a database
## ref: https://github.com/bitnami/bitnami-docker-mariadb/blob/master/README.md#creating-a-database-on-first-run
##
# mariadbDatabase:
$ echo '{mariadbUser: user0, mariadbDatabase: user0db}' > config.yaml
$ helm install -f config.yaml stable/mariadb
有两种方式在安装Chart前修改配置，上面的例子展示了其中一种。

--values (or -f): 使用一个YAML文件，内含要覆盖Chart的配置值。
--set: 指定具体要覆盖的默认配置值。
--set name1=val1,name2=val2
--set outer.inner=value 当Key有层级关系时
--set name={a, b, c} 当Value为数组时
--set servers[0].port=80 当要给定数组中第1个元素的某个Key赋值时
--set servers[0].port=80,servers[0].host=example 当同时要给数组中第1个元素的多个key赋值时
--set name=value1\,value2 Value中含有特殊字符时，使用转义字符
--set nodeSelector."kubernetes\.io/role"=master，Key中含有特殊字符时，使用双引号
如果以上两种方式同时使用， set的优先级高于另一种，并且合并进-f指定的配置中。
```
## 管理Release
### 核心命令
```
helm list 列出已经部署的Release
helm delete [RELEASE] 删除一个Release. 并没有物理删除， 出于审计需要，历史可查。
helm status [RELEASE] 查看指定的Release信息，即使使用helm delete命令删除的Release.
helm upgrade 升级某个Release
helm rollback [RELEASE] [REVISION] 回滚Release到指定发布序列
helm get values [RELEASE] 查看Release的配置文件值
```
## 管理Chart Repository
### 核心命令 helm repo
```
helm repo list
helm repo add [RepoName] [RepoUrl]
helm repo update
```
## 高级部分：自定义Chart
```
官方详细的定义Chart的文档helm/charts.md at master · kubernetes/helm · GitHub
```
* Helm使用的包文件组织格式叫做Charts. 一个Chart其实就是一组文件集合， 描述了一套相关的Kubernetes资源。它可以对应一个简单应用，也可以对应一个负责应用。

Chart组成
表现形式就是一个目录，然后里面有一堆文件。
目录名就这个Chart的名字，注意名字中不体现版本号。
至少包含两部分

一个自描述文件 (Chart.yaml)
必须包含 name和version
一个或多个模板文件，其中包含了Kubernetes说明文件。 既然叫模板，就有默认值给它填充，对应的文件是 values.yaml。
比如名为wordpress的Chart目录格式 （来自官方说明）

wordpress/
  Chart.yaml          # A YAML file containing information about the chart
  LICENSE             # OPTIONAL: A plain text file containing the license for the chart
  README.md           # OPTIONAL: A human-readable README file
  requirements.yaml   # OPTIONAL: A YAML file listing dependencies for the chart
  values.yaml         # The default configuration values for this chart
  charts/             # OPTIONAL: A directory containing any charts upon which this chart depends.
  templates/          # OPTIONAL: A directory of templates that, when combined with values,
                      # will generate valid Kubernetes manifest files.
  templates/NOTES.txt # OPTIONAL: A plain text file containing short usage notes
创建一个简单的Chart
Chart名称为 ”hello-world”, 实际就是创建一个 hello-world文件夹，然后里面放上必须的文件。

创建文件夹

$ mkdir ./hello-world
$ cd ./hello-world
创建自描述文件 Chart.yaml , 这个文件必须有 name和version定义

$ cat <<'EOF' > ./Chart.yaml
name: hello-world
version: 1.0.0
EOF
创建模板文件， 用于生成 Kubernetes资源清单（manifests）
本例中我们需要创建一个 K8s的deployment和service

$ mkdir ./templates
$ cat <<'EOF' > ./templates/deployment.yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: hello-world
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: hello-world
    spec:
      containers:
        - name: hello-world
          image: gcr.io/google-samples/node-hello:1.0
          ports:
            - containerPort: 8080
              protocol: TCP
EOF
$ cat <<'EOF' > ./templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: hello-world
spec:
  type: NodePort
  ports:
  - port: 8080
    targetPort: 8080
    protocol: TCP
  selector:
    app: hello-world
EOF
以上就完成一个Chart的创建

使用Chart来发布一个应用, 学习Release, Inspection, Removal, Rollback和Purge管理Helm Release的生命周期
使用命令 helm install RELATIVE_PATH_TO_CHART 创建一次Release

$ helm install .
NAME:   cautious-shrimp
LAST DEPLOYED: Thu Jan  5 11:32:04 2017
NAMESPACE: default
STATUS: DEPLOYED
RESOURCES:
==> v1/Service
NAME          CLUSTER-IP   EXTERNAL-IP   PORT(S)          AGE
hello-world   10.0.0.175   <nodes>       8080:31419/TCP   0s
==> extensions/Deployment
NAME          DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
hello-world   1         1         1            0           0s
helm install .命令使用./templates目录下的 Kubernetes清单创建了一个一个K8s（即Kubernetes缩写）的Deployment和Service

$ kubectl get po,svc
NAME                            READY     STATUS    RESTARTS   AGE
po/hello-world-52480365-gntxz   1/1       Running   0          1m
NAME              CLUSTER-IP   EXTERNAL-IP   PORT(S)    AGE
svc/hello-world   10.0.0.175   <nodes>       8080/TCP   1m
svc/kubernetes    10.0.0.1     <none>        443/TCP    6d
使用 helm ls 列出已经部署的Release

$ helm ls
NAME            REVISION UPDATED                  STATUS   CHART
cautious-shrimp 1        Thu Jan  5 11:32:04 2017 DEPLOYED hello-world-1.0.0
使用helm status RELEASE_NAME 查询一个特定的Release的状态

$ helm status cautious-shrimp
LAST DEPLOYED: Thu Jan  5 11:32:04 2017
NAMESPACE: default
STATUS: DEPLOYED
RESOURCES:
==> v1/Service
NAME          CLUSTER-IP   EXTERNAL-IP   PORT(S)          AGE
hello-world   10.0.0.175   <nodes>       8080:31419/TCP   6m
==> extensions/Deployment
NAME          DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
hello-world   1         1         1            1           6m
使用helm delete RELEASE_NAME 移除所有与这个Release相关的 Kubernetes资源

$ helm delete cautious-shrimp
使用helm ls --deleted 列出已经删除的Release

使用helm rollback RELEASE_NAME REVISION_NUMBER 回滚已经删除的Release到指定版本

$ helm rollback cautious-shrimp 1
Rollback was a success! Happy Helming!
$ helm ls
NAME            REVISION UPDATED                  STATUS   CHART
cautious-shrimp 2        Thu Jan  5 11:47:57 2017 DEPLOYED hello-world-1.0.0
$ helm status cautious-shrimp
LAST DEPLOYED: Thu Jan  5 11:47:57 2017
NAMESPACE: default
STATUS: DEPLOYED
RESOURCES:
==> v1/Service
NAME          CLUSTER-IP   EXTERNAL-IP   PORT(S)          AGE
hello-world   10.0.0.42    <nodes>       8080:32367/TCP   2m
==> extensions/Deployment
NAME          DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
hello-world   1         1         1            1           2m
使用 helm delete --purge RELEASE_NAME 移除所有与指定Release相关的Kubernetes资源和所有这个Release的记录

$ helm delete --purge cautious-shrimp
$ helm ls --deleted
Helm最重要的部分-可配置的Release
Helm Chart的模板使用GO模板语言写的， 拥有50多个来自于Sprig库和少部分专有的模板功能

配置体现在配置文件 values.yaml

$ cat <<'EOF' > ./values.yaml
image:
  repository: gcr.io/google-samples/node-hello
  tag: '1.0'
EOF
这个文件中定义的值，在模板文件中可以通过 .VAlues对象访问到，比如：

$ cat <<'EOF' > ./templates/deployment.yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: hello-world
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: hello-world
    spec:
      containers:
        - name: hello-world
          image: {{ .Values.image.repository }}:{{ .Values.image.tag }}
          ports:
            - containerPort: 8080
              protocol: TCP
EOF
在 values.yaml中的值可以被部署release时用到的参数--values YAML_FILE_PATH 或 --set key1=value1, key2=value2覆盖掉， 比如

$ helm install --set image.tag='latest' .
优先级： --set设置的值会覆盖--value设置的值， --value设置的值会覆盖 values.yaml中定义的值

Debug
使用模板动态生成K8s资源清单，非常需要能提前预览生成的结果。
使用--dry-run --debug选项来打印出生成的清单文件内容，而不执行部署

$ helm install . --dry-run --debug --set image.tag=latest
Created tunnel using local port: '49636'
SERVER: "localhost:49636"
CHART PATH: /Users/gajus/Documents/dev/gajus/hello-world
NAME:   eyewitness-turkey
REVISION: 1
RELEASED: Thu Jan  5 13:02:49 2017
CHART: hello-world-1.0.0
USER-SUPPLIED VALUES:
image:
  tag: latest
COMPUTED VALUES:
image:
  repository: gcr.io/google-samples/node-hello
  tag: latest
HOOKS:
MANIFEST:
---
# Source: hello-world/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: hello-world
spec:
  type: NodePort
  ports:
  - port: 8080
    targetPort: 8080
    protocol: TCP
  selector:
    app: hello-world
---
# Source: hello-world/templates/deployment.yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: hello-world
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: hello-world
    spec:
      containers:
        - name: hello-world
          image: gcr.io/google-samples/node-hello:latest
          ports:
            - containerPort: 8080
              protocol: TCP
使用Helm Chart预定义对象
除了用户自己定义的配置values.yaml之外，我们还可以使用 Helm Chart预定义的值

.Release 用来指代一次release的结果对象， 比如 .Release.Name, .Release.Time
.Chart是配置文件Chart.yaml的引用
.Files用来指代chart目录下的文件
我习惯使用预定义对象来创建 label，它可以方便的检查Kubernetes资源

$ cat <<'EOF' > ./templates/deployment.yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: {{ printf "%s-%s" .Release.Name .Chart.Name | trunc 63 }}
  labels:
    app: {{ printf "%s-%s" .Release.Name .Chart.Name | trunc 63 }}
    version: {{ .Chart.Version }}
    release: {{ .Release.Name }}
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: {{ printf "%s-%s" .Release.Name .Chart.Name | trunc 63 }}
        version: {{ .Chart.Version }}
        release: {{ .Release.Name }}
    spec:
      containers:
        - name: hello-world
          image: {{ .Values.image.repository }}:{{ .Values.image.tag }}
          ports:
            - containerPort: 8080
              protocol: TCP
EOF
$ cat <<'EOF' > ./templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ printf "%s-%s" .Release.Name .Chart.Name | trunc 63 }}
  labels:
    app: {{ printf "%s-%s" .Release.Name .Chart.Name | trunc 63 }}
    version: {{ .Chart.Version }}
    release: {{ .Release.Name }}
spec:
  type: NodePort
  ports:
  - port: 8080
    targetPort: 8080
    protocol: TCP
  selector:
    app: {{ printf "%s-%s" .Release.Name .Chart.Name | trunc 63 }}
EOF
记住，所有的资源都必须有唯一的名字和标签（lables）。上例中，使用了.Release.Name 和 .Chart.Name来组合成资源名字。

{{ printf "%s-%s" .Release.Name .Chart.Name | trunc 63 }}
注： Kubebernetes资源标签和名字被限定为63个字符
http://kubernetes.io/docs/user-guide/labels/#syntax-and-character-set

Partials 配置文件中可以重复使用的部分
你可能已经注意到模板中重复出现的内容

app: {{ printf "%s-%s" .Release.Name .Chart.Name | trunc 63 }}
version: {{ .Chart.Version }}
release: {{ .Release.Name }}
我们给所有的资源使用了相同的label
而且，资源名字是限制了长度的。

{{ printf "%s-%s" .Release.Name .Chart.Name | trunc 63 }}
这种重复在大型应用中就更加明显了，因为里面有数十个资源。对此，我们可以做些什么呢？

我们创建一个文件，名为_helpers.tpl, 在其中声明我们其后会在模板中引用的部分。

在./templates目录中，以_开头的文件不会被当做Kubernetes的资源清单（manifests）。这些文件渲染生成的文件版本不会被发送给Kubernetes。

$ cat <<'EOF' > ./templates/_helpers.tpl
{{- define "hello-world.release_labels" }}
app: {{ printf "%s-%s" .Release.Name .Chart.Name | trunc 63 }}
version: {{ .Chart.Version }}
release: {{ .Release.Name }}
{{- end }}
{{- define "hello-world.full_name" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 -}}
{{- end -}}
EOF
这个文件创建了两个partial： hello-world.release_labels 和 hello-world.full_name， 可以用于模板中。

模板名字是全局的，因为在Subcharts中的模板被编译为顶级模板， 所以在给模板命名时小心，最好使用与Chart相关的名称。这也正是本例中使用Chart名字作为模板名称前缀。

$ cat <<'EOF' > ./templates/deployment.yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: {{ template "hello-world.full_name" . }}
  labels:
    {{- include "hello-world.release_labels" . | indent 4 }}
spec:
  replicas: 1
  template:
    metadata:
      labels:
        {{- include "hello-world.release_labels" . | indent 8 }}
    spec:
      containers:
        - name: hello-world
          image: {{ .Values.image.repository }}:{{ .Values.image.tag }}
          ports:
            - containerPort: 8080
              protocol: TCP
EOF
$ cat <<'EOF' > ./templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: {{ template "hello-world.full_name" . }}
  labels:
    {{- include "hello-world.release_labels" . | indent 4 }}
spec:
  type: NodePort
  ports:
  - port: 8080
    targetPort: 8080
    protocol: TCP
  selector:
    app: {{ template "hello-world.full_name" . }}
EOF
上例中有时候用 template有时候用include 来引入Partial。 他们的具体说明在此， 简单说 template输出的内容都会靠右对齐，除第一行其余行不会缩进，同时template是条指令，不是funciton，它的输出不能用在pipeline中再供其他function使用。 为了，Helm引入了function include，它输出的文本可以通过pipeline传递给其他function，比如 indent。

最后，在debug模式下预览输出的Kubernetes清单内容

$ helm install . --dry-run --debug
Created tunnel using local port: '50655'
SERVER: "localhost:50655"
CHART PATH: /Users/gajus/Documents/dev/gajus/hello-world
NAME:   kindred-deer
REVISION: 1
RELEASED: Thu Jan  5 14:46:41 2017
CHART: hello-world-1.0.0
USER-SUPPLIED VALUES:
{}
COMPUTED VALUES:
image:
  repository: gcr.io/google-samples/node-hello
  tag: "1.0"
HOOKS:
MANIFEST:
---
# Source: hello-world/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: kindred-deer-hello-world
  labels:
    app: kindred-deer-hello-world
    version: 1.0.0
    release: kindred-deer
spec:
  type: NodePort
  ports:
  - port: 8080
    targetPort: 8080
    protocol: TCP
  selector:
    app: kindred-deer-hello-world
---
# Source: hello-world/templates/deployment.yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: kindred-deer-hello-world
  labels:
    app: kindred-deer-hello-world
    version: 1.0.0
    release: kindred-deer
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: kindred-deer-hello-world
        version: 1.0.0
        release: kindred-deer
    spec:
      containers:
        - name: hello-world
          image: gcr.io/google-samples/node-hello:1.0
          ports:
            - containerPort: 8080
              protocol: TCP
It’s Cool！

加分环节： 生成一个 cheksum（文件签名）
你可能注意到之前例子中都是把deployment和service的定义分开，Helm不要求一定这样。 无论如何，有理由保持两个定义独立。

考虑一个场景： 你有一个ConfigMap资源用于控制deployment的行为，如

$ cat <<'EOF' > ./templates/config-map.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ template "hello-world.full_name" . }}
  labels:
    {{- include "hello-world.release_labels" . | indent 4 }}
data:
  magic-number: '11'
EOF
$ cat <<'EOF' > ./templates/deployment.yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: {{ template "hello-world.full_name" . }}
  labels:
    {{- include "hello-world.release_labels" . | indent 4 }}
spec:
  replicas: 1
  template:
    metadata:
      labels:
        {{- include "hello-world.release_labels" . | indent 8 }}
    spec:
      containers:
        - name: hello-world
          image: {{ .Values.image.repository }}:{{ .Values.image.tag }}
          ports:
            - containerPort: 8080
              protocol: TCP
          env:
            - name: MAGIC_NUMBER
              valueFrom:
                configMapKeyRef:
                  name: {{ template "hello-world.full_name" . }}
                  key: magic-number
EOF
$ helm install . --name demo
$ kubectl get po,svc,cm -l app=demo-hello-world
NAME                                   READY     STATUS    RESTARTS   AGE
po/demo-hello-world-2159237003-fr5gk   1/1       Running   0          8s
NAME                   CLUSTER-IP   EXTERNAL-IP   PORT(S)    AGE
svc/demo-hello-world   10.0.0.68    <nodes>       8080/TCP   8s
NAME                  DATA      AGE
cm/demo-hello-world   1         8s
以上部署了一个release
现在magic-number改变了，更新config-map.yaml然后部署一个新的release

$ cat <<'EOF' > ./templates/config-map.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ template "hello-world.full_name" . }}
  labels:
    {{- include "hello-world.release_labels" . | indent 4 }}
data:
  magic-number: '12'
EOF
$ helm upgrade demo .
注意到 K8s中ConfigMap资源被重新创建，但是K8s中的Deployment没有重建

$ kubectl get po,svc,cm -l app=demo-hello-world
NAME                                   READY     STATUS    RESTARTS   AGE
po/demo-hello-world-2159237003-fr5gk   1/1       Running   0          1m
NAME                   CLUSTER-IP   EXTERNAL-IP   PORT(S)    AGE
svc/demo-hello-world   10.0.0.68    <nodes>       8080/TCP   1m
NAME                  DATA      AGE
cm/demo-hello-world   1         1m
这是因为deployment.yaml没有发生变化。

我们使用 include函数将config-map.yaml的内容输出并使用sha256sum函数计算出config-map文件的SHA256 checksum.

{{ include (print $.Chart.Name "/templates/config-map.yaml") . | sha256sum }}
利用这个值为 deployment生成一个 annotation（注释）

$ cat <<'EOF' > ./templates/deployment.yaml
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: {{ template "hello-world.full_name" . }}
  labels:
    {{- include "hello-world.release_labels" . | indent 4 }}
spec:
  replicas: 1
  template:
    metadata:
      labels:
        {{- include "hello-world.release_labels" . | indent 8 }}
      annotations:
        checksum/config-map: {{ include (print $.Chart.Name "/templates/config-map.yaml") . | sha256sum }}
    spec:
      containers:
        - name: hello-world
          image: {{ .Values.image.repository }}:{{ .Values.image.tag }}
          ports:
            - containerPort: 8080
              protocol: TCP
          env:
            - name: MAGIC_NUMBER
              valueFrom:
                configMapKeyRef:
                  name: {{ template "hello-world.full_name" . }}
                  key: magic-number
EOF
现在我们再次改变magic-number，然后升级release

$ cat <<'EOF' > ./templates/config-map.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ template "hello-world.full_name" . }}
  labels:
    {{- include "hello-world.release_labels" . | indent 4 }}
data:
  magic-number: '13'
EOF
$ helm upgrade demo .
$ kubectl get po,svc,cm -l app=demo-hello-world
NAME                                   READY     STATUS              RESTARTS   AGE
po/demo-hello-world-2130866520-l77rf   1/1       Terminating         0          58s
po/demo-hello-world-3814420630-jrglp   0/1       ContainerCreating   0          2s
NAME                   CLUSTER-IP   EXTERNAL-IP   PORT(S)    AGE
svc/demo-hello-world   10.0.0.68    <nodes>       8080/TCP   4m
NAME                  DATA      AGE
cm/demo-hello-world   1         4m
文件config-map.yaml的checksum改变了，release的annotation（注释）也改变了，因为相关的K8s中的Pods被重建。

本文基本涵盖了Helm最常使用的命令，没有涉及到声明依赖和建立Chart Repositories，建议继续阅读 Helm官方文档