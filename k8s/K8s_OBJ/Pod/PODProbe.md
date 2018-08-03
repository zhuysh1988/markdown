

# livenessProbe
```
一个程序在长时间运行后或者有bug trigger的情况下，会进入不正常的状态，这个不正常状态是如此严重，以至于我们需要将容器内的进程杀死，重启整个容器/POD，使POD恢复到最初始的状态。liveness指令可以让你在系统出现这样的状态时让Kubernetes帮你重启这个POD。

通过kubernetes的livenessProbe配置，可以为POD里面的每一个容器指定一个区分是否要重启容器的条件或者范围，这个条件的瞬时值可以通过定时在容器内执行命令、确认某个TCP端口是否可达或者访问容器暴露的HTTP状态查询端口获得，可以定义在连续的有限次的不满足这个条件的情况下，liveness探测失败，进而重启POD。

livenessProbe支持如下三种探测方式：

exec：在容器内执行命令
httpGet：访问容器的http服务，可以指定httpHeaders
tcpSocket：访问容器的TCP端口
```

# readinessProbe

```
readiness探测器的配置方式和liveness是一样的，区别在于它们对于Kubernetes的意义不一样。在readiness探测失败之后，POD和容器并不会被删除，而是会被标记成特殊状态，进入这个状态之后，如果这个POD是在某个serice的endpoint列表里面的话，则会被从这个列表里面清除，以保证外部请求不会被转发到这个POD上。在一段时间之后如果容器恢复正常之后，POD也会恢复成正常状态，也会被加回到endpoint的列表里面，继续对外服务。
```

# 探测器的配置

```
kubernetes的探测器有一些精细的配置来更细粒度的控制liveness和readiness探测：

initialDelaySeconds：容器启动后第一次执行探测是需要等待多少秒。
periodSeconds：执行探测的频率，默认是10秒。
timeoutSeconds：探测超时时间，默认1秒。
successThreshold：探测失败后，最少连续探测成功多少次才被认定为成功，默认是 1。
failureThreshold：探测成功后，最少连续探测失败多少次才被认定为失败，默认是 3。
```

## for command :
```yaml 
          readinessProbe:
            exec:
              command:
              - /bin/bash
              - -c
              - curl --noproxy '*' -s -u ${maven_ADMIN_USERNAME}:${maven_ADMIN_PASSWORD}
                'http://localhost:8080/manager/jmxproxy/?get=Catalina%3Atype%3DServer&att=stateName'
                |grep -iq 'stateName *= *STARTED'

        readinessProbe:
          exec:
            command:
            - sh
            - -c
            - "zookeeper-ready 2181"
          initialDelaySeconds: 10
          timeoutSeconds: 5
        livenessProbe:
          exec:
            command:
            - sh
            - -c
            - "zookeeper-ready 2181"
          initialDelaySeconds: 10
          timeoutSeconds: 5
```
## for http :
``` yaml
          livenessProbe:
            failureThreshold: 1
            httpGet:
              path: /
              port: 80
              scheme: HTTP
            initialDelaySeconds: 10
            periodSeconds: 10
            successThreshold: 1
            timeoutSeconds: 3
          readinessProbe:
            failureThreshold: 1
            httpGet:
              path: /
              port: 80
              scheme: HTTP
            initialDelaySeconds: 10
            periodSeconds: 10
            successThreshold: 1
            timeoutSeconds: 3
```
## for tcp :
```yaml 
          livenessProbe:
              tcpSocket:
                port: 389
              initialDelaySeconds: 60
              timeoutSeconds: 5
          readinessProbe:
              tcpSocket:
                port: 389
              timeoutSeconds: 5
```