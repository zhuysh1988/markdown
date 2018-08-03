hostPath
hostPath 卷将主机节点的文件系统中的文件或目录挂载到集群中。该功能大多数 Pod 都用不到，但它为某些应用程序提供了一个强大的解决方法。

例如，hostPath 的用途如下：

运行需要访问 Docker 内部的容器；使用 /var/lib/docker 的 hostPath
在容器中运行 cAdvisor；使用 /dev/cgroups 的 hostPath
允许 pod 指定给定的 hostPath 是否应该在 pod 运行之前存在，是否应该创建，以及它应该以什么形式存在
除了所需的 path 属性之外，用户还可以为 hostPath 卷指定 type。

type 字段支持以下值：

值	行为
空字符串（默认）用于向后兼容，这意味着在挂载 hostPath 卷之前不会执行任何检查。
DirectoryOrCreate	如果在给定的路径上没有任何东西存在，那么将根据需要在那里创建一个空目录，权限设置为 0755，与 Kubelet 具有相同的组和所有权。
Directory	给定的路径下必须存在目录
FileOrCreate	如果在给定的路径上没有任何东西存在，那么会根据需要创建一个空文件，权限设置为 0644，与 Kubelet 具有相同的组和所有权。
File	给定的路径下必须存在文件
Socket	给定的路径下必须存在 UNIX 套接字
CharDevice	给定的路径下必须存在字符设备
BlockDevice	给定的路径下必须存在块设备
使用这种卷类型是请注意，因为：

由于每个节点上的文件都不同，具有相同配置（例如从 podTemplate 创建的）的 pod 在不同节点上的行为可能会有所不同
当 Kubernetes 按照计划添加资源感知调度时，将无法考虑 hostPath 使用的资源
在底层主机上创建的文件或目录只能由 root 写入。您需要在特权容器中以 root 身份运行进程，或修改主机上的文件权限以便写入 hostPath 卷

