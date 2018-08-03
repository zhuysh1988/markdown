

## create app projects 

```bash
GUID=mydemo
oc new-project pipeline-${GUID}-dev --description="Cat of the Day Development Environment" --display-name="Cat Of The Day - Dev"
oc new-project pipeline-${GUID}-test --description="Cat of the Day Testing Environment" --display-name="Cat Of The Day - Test"
oc new-project pipeline-${GUID}-prod --description="Cat of the Day Production Environment" --display-name="Cat Of The Day - Prod"

oc project pipeline-${GUID}-dev



```

## 部署Jenkins以控制构建和部署管道
```bash
oc new-app jenkins-persistent -p JENKINS_PASSWORD=openshiftpipelines  -n pipeline-${GUID}-dev
```
```
--> Deploying template "jenkins-persistent" in project "openshift" for "jenkins-persistent"
     With parameters:
      Jenkins Service Name=jenkins
      Jenkins JNLP Service Name=jenkins-jnlp
      Jenkins Password=openshiftpipelines
      Memory Limit=512Mi
      Volume Capacity=1Gi
      Jenkins ImageStream Namespace=openshift
      Jenkins ImageStreamTag=jenkins:latest
--> Creating resources ...
    route "jenkins" created
    persistentvolumeclaim "jenkins" created
    deploymentconfig "jenkins" created
    serviceaccount "jenkins" created
    rolebinding "jenkins_edit" created
    service "jenkins-jnlp" created
    service "jenkins" created
--> Success
    Run 'oc status' to view your app.
```
> 记下Jenkins管理员密码。 密码由JENKINS_PASSWORD参数定义

## 启用Jenkins服务帐户来管理管道中的资源
```bash
oc policy add-role-to-user edit system:serviceaccount:pipeline-${GUID}-dev:jenkins -n pipeline-${GUID}-test
oc policy add-role-to-user edit system:serviceaccount:pipeline-${GUID}-dev:jenkins -n pipeline-${GUID}-prod
```

* 启用从管道中提取图像 - $ {GUID} -dev项目到管道 - $ {GUID} -test和管道 - $ {GUID} -prod项目
```bash
oc policy add-role-to-group system:image-puller system:serviceaccounts:pipeline-${GUID}-test -n pipeline-${GUID}-dev
oc policy add-role-to-group system:image-puller system:serviceaccounts:pipeline-${GUID}-prod -n pipeline-${GUID}-dev
```

# 部署模拟应用程序
* 在开发项目中部署“Cat of the Day”（cotd）应用程序：
```bash
oc new-app php~https://github.com/StefanoPicozzi/cotd.git -n pipeline-${GUID}-dev
```
* 观察构建日志，直到构建完成
```
sleep 5 # give OpenShift a chance to start the build
oc logs -f build/cotd-1 -n pipeline-${GUID}-dev
```
* 检查构建是否已完成并标记图像
```
oc tag cotd:latest cotd:testready -n pipeline-${GUID}-dev
oc tag cotd:testready cotd:prodready -n pipeline-${GUID}-dev
```
* 检查图像流以查看标签是否已创建
```
oc describe is cotd -n pipeline-${GUID}-dev

Name:			cotd
Created:		About an hour ago
Labels:			app=cotd
Annotations:		openshift.io/generated-by=OpenShiftNewApp
Docker Pull Spec:	172.30.99.85:5000/pipeline-mydemo-dev/cotd

Tag		Spec				Created			PullSpec							Image
latest		<pushed>			About an hour ago	172.30.99.85:5000/pipeline-mydemo-dev/cotd@sha256:21c16f04309942...	<same>
prodready	cotd@sha256:21c16f04309942...	About an hour ago	172.30.99.85:5000/pipeline-mydemo-dev/cotd@sha256:21c16f04309942...	<same>
testready	cotd@sha256:21c16f04309942...	About an hour ago	172.30.99.85:5000/pipeline-mydemo-dev/cotd@sha256:21c16f04309942...	<same>
```
* 在测试和prod项目中部署cotd应用程序：
```
oc new-app pipeline-${GUID}-dev/cotd:testready --name=cotd -n pipeline-${GUID}-test
oc new-app pipeline-${GUID}-dev/cotd:prodready --name=cotd -n pipeline-${GUID}-prod
```
* 为所有三个应用程序创建路由
```
oc expose service cotd -n pipeline-${GUID}-dev
oc expose service cotd -n pipeline-${GUID}-test
oc expose service cotd -n pipeline-${GUID}-prod
```
* 禁用演示中所有部署配置的自动部署
```
oc get dc cotd -o yaml -n pipeline-${GUID}-dev | sed 's/automatic: true/automatic: false/g' | oc replace -f -
oc get dc cotd -o yaml -n pipeline-${GUID}-test| sed 's/automatic: true/automatic: false/g' | oc replace -f -
oc get dc cotd -o yaml -n pipeline-${GUID}-prod | sed 's/automatic: true/automatic: false/g' | oc replace -f -
```


# Create Initial Build Config Pipeline
```yml
apiVersion: v1
items:
- kind: "BuildConfig"
  apiVersion: "v1"
  metadata:
    name: "pipeline-demo"
  spec:
    triggers:
          - github:
              secret: 5Mlic4Le
            type: GitHub
          - generic:
              secret: FiArdDBH
            type: Generic
    strategy:
      type: "JenkinsPipeline"
      jenkinsPipelineStrategy:
        jenkinsfile: |
                          node {
                              stage ("Build")
                                    echo '*** Build Starting ***'
                                    openshiftBuild bldCfg: 'cotd', buildName: '', checkForTriggeredDeployments: 'false', commitID: '', namespace: '', showBuildLogs: 'true', verbose: 'true'
                                    openshiftVerifyBuild bldCfg: 'cotd', checkForTriggeredDeployments: 'false', namespace: '', verbose: 'false'
                                    echo '*** Build Complete ***'
                              stage ("Deploy and Verify in Development Env")
                                    echo '*** Deployment Starting ***'
                                    openshiftDeploy depCfg: 'cotd', namespace: '', verbose: 'false', waitTime: ''
                                    openshiftVerifyDeployment authToken: '', depCfg: 'cotd', namespace: '', replicaCount: '1', verbose: 'false', verifyReplicaCount: 'false', waitTime: ''
                                    echo '*** Deployment Complete ***'
                               }

kind: List
metadata: {}
```

> 在继续之前，请验证是否已部署Jenkins，并确保可以使用admin / openshiftpipelines凭据连接到Jenkins Web界面。
