# BLOCK DEVICE COMMANDS



## CREATE A BLOCK DEVICE POOL
```
On the admin node, use the ceph tool to create a pool.
On the admin node, use the rbd tool to initialize the pool for use by RBD:

在管理节点上，使用ceph工具创建一个池。 
在管理节点上，使用rbd工具初始化RBD使用的池
```

```
rbd pool init <pool-name>
```

## CREATE A BLOCK DEVICE USER
```
Unless specified, the rbd command will access the Ceph cluster using the ID admin. This ID allows full administrative access to the cluster. It is recommended that you utilize a more restricted user wherever possible.

To create a Ceph user, with ceph specify the auth get-or-create command, user name, monitor caps, and OSD caps:

除非指定，否则rbd命令将使用ID admin访问Ceph集群。此ID允许对群集进行完全管理访问。建议您尽可能使用更受限制的用户。 要创建Ceph用户，使用ceph指定auth get-or-create命令，用户名，显示器大小和OSD大小：
```
```
ceph auth get-or-create client.{ID} mon 'profile rbd' osd 'profile {profile name} [pool={pool-name}][, profile ...]'
```
```
For example, to create a user ID named qemu with read-write access to the pool vms and read-only access to the pool images, execute the following:
例如，要创建名为qemu的用户ID，并具有对池vms的读写访问权和对池映像的只读访问权，请执行以下操作：
```
```
ceph auth get-or-create client.qemu mon 'profile rbd' osd 'profile rbd pool=vms, profile rbd-read-only pool=images'
```
```
The output from the ceph auth get-or-create command will be the keyring for the specified user, which can be written to /etc/ceph/ceph.client.{ID}.keyring.

Note The user ID can be specified when using the rbd command by providing the --id {id} optional argument.
ceph auth get-or-create命令的输出将是指定用户的密钥环，可以写入/etc/ceph/ceph.client.{ID}.keyring。 注意通过提供--id {id}可选参数来使用rbd命令时，可以指定用户标识。
```


## CREATING A BLOCK DEVICE IMAGE
```
Before you can add a block device to a node, you must create an image for it in the Ceph Storage Cluster first. To create a block device image, execute the following:
在将块设备添加到节点之前，必须先在Ceph存储群集中为其创建映像。要创建块设备映像，请执行以下操作：
```
```
rbd create --size {megabytes} {pool-name}/{image-name}
```
```
For example, to create a 1GB image named bar that stores information in a pool named swimmingpool, execute the following:
```
```
rbd create --size 1024 swimmingpool/bar
```
```
If you don’t specify pool when creating an image, it will be stored in the default pool rbd. For example, to create a 1GB image named foo stored in the default pool rbd, execute the following:
如果您在创建映像时未指定池，则会将其存储在默认池rbd中。例如，要创建存储在默认池rbd中的名为foo的1GB映像，请执行以下操作：
```
```
rbd create --size 1024 foo
```
```
Note You must create a pool first before you can specify it as a source. See Storage Pools for details.
```
## LISTING BLOCK DEVICE IMAGES

> To list block devices in the rbd pool, execute the following (i.e., rbd is the default pool name):
```
rbd ls
```
> To list block devices in a particular pool, execute the following, but replace {poolname} with the name of the pool:
```
rbd ls {poolname}
```
* For example:

rbd ls swimmingpool
To list deferred delete block devices in the rbd pool, execute the following:

rbd trash ls
To list deferred delete block devices in a particular pool, execute the following, but replace {poolname} with the name of the pool:

rbd trash ls {poolname}
For example:

rbd trash ls swimmingpool
RETRIEVING IMAGE INFORMATION
To retrieve information from a particular image, execute the following, but replace {image-name} with the name for the image:

rbd info {image-name}
For example:

rbd info foo
To retrieve information from an image within a pool, execute the following, but replace {image-name} with the name of the image and replace {pool-name} with the name of the pool:

rbd info {pool-name}/{image-name}
For example:

rbd info swimmingpool/bar
RESIZING A BLOCK DEVICE IMAGE
Ceph Block Device images are thin provisioned. They don’t actually use any physical storage until you begin saving data to them. However, they do have a maximum capacity that you set with the --size option. If you want to increase (or decrease) the maximum size of a Ceph Block Device image, execute the following:

rbd resize --size 2048 foo (to increase)
rbd resize --size 2048 foo --allow-shrink (to decrease)
REMOVING A BLOCK DEVICE IMAGE
To remove a block device, execute the following, but replace {image-name} with the name of the image you want to remove:

rbd rm {image-name}
For example:

rbd rm foo
To remove a block device from a pool, execute the following, but replace {image-name} with the name of the image to remove and replace {pool-name} with the name of the pool:

rbd rm {pool-name}/{image-name}
For example:

rbd rm swimmingpool/bar
To defer delete a block device from a pool, execute the following, but replace {image-name} with the name of the image to move and replace {pool-name} with the name of the pool:

rbd trash mv {pool-name}/{image-name}
For example:

rbd trash mv swimmingpool/bar
To remove a deferred block device from a pool, execute the following, but replace {image-id} with the id of the image to remove and replace {pool-name} with the name of the pool:

rbd trash rm {pool-name}/{image-id}
For example:

rbd trash rm swimmingpool/2bf4474b0dc51
Note
You can move an image to the trash even it has shapshot(s) or actively in-use by clones, but can not be removed from trash.
You can use –delay to set the defer time (default is 0), and if its deferment time has not expired, it can not be removed unless you use force.
RESTORING A BLOCK DEVICE IMAGE
To restore a deferred delete block device in the rbd pool, execute the following, but replace {image-id} with the id of the image:

rbd trash restore {image-d}
For example:

rbd trash restore 2bf4474b0dc51
To restore a deferred delete block device in a particular pool, execute the following, but replace {image-id} with the id of the image and replace {pool-name} with the name of the pool:

rbd trash restore {pool-name}/{image-id}
For example:

rbd trash restore swimmingpool/2bf4474b0dc51
Also you can use –image to rename the iamge when restore it, for example:

rbd trash restore swimmingpool/2bf4474b0dc51 --image new-name

