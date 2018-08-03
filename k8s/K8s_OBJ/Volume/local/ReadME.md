local
这个 alpha 功能要求启用 PersistentLocalVolumes feature gate。

注意：从 1.9 开始，VolumeScheduling feature gate 也必须启用。

local 卷表示挂载的本地存储设备，如磁盘、分区或目录。

本地卷只能用作静态创建的 PersistentVolume。

与 HostPath 卷相比，local 卷可以以持久的方式使用，而无需手动将 pod 调度到节点上，因为系统会通过查看 PersistentVolume 上的节点关联性来了解卷的节点约束。

但是，local 卷仍然受底层节点的可用性影响，并不适用于所有应用程序。

注意：本地 PersistentVolume 清理和删除需要手动干预，无外部提供程序。

从 1.9 开始，本地卷绑定可以被延迟，直到通过具有 StorageClass 中的 WaitForFirstConsumer 设置为volumeBindingMode 的 pod 开始调度。请参阅示例。延迟卷绑定可确保卷绑定决策也可以使用任何其他节点约束（例如节点资源需求，节点选择器，pod 亲和性和 pod 反亲和性）进行评估。

有关 local 卷类型的详细信息，请参见本地持久化存储用户指南。