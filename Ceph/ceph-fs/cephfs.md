# CEPH FILESYSTEM

## create cephfs 
```txt
一个cephfs 需要至少两个RADOS Pools: 
    一个存储data
    一个存储metadata
注: 
对元数据池使用更高的复制级别，因为此池中的任何数据丢失都可能导致整个文件系统无法访问。 
为元数据池使用SSD等较低延迟的存储，因为这将直接影响客户端上文件系统操作的观察延迟。
```
* create two pool 
``` bash

ceph osd pool create cephfs_data <pg_num>
ceph osd pool create cephfs_metadata <pg_num>
```

* create cephfs
``` bash
ceph fs new cephfs cephfs_metadata cephfs_data
ceph fs ls
name: cephfs, metadata pool: cephfs_metadata, data pools: [cephfs_data ]
```

* show mds 
```bash
ceph mds stat
e5: 1/1/1 up {0=a=up:active}
```

## mount cephfs with the kernel driver
```  bash
#要挂载Ceph文件系统，您可以在知道监视器主机IP地址的情况下使用mount命令，或使用mount.ceph实用程序将监视器主机名解析为IP地址。
#例如：
sudo mkdir /mnt/mycephfs
sudo mount -t ceph 192.168.0.1:6789:/ /mnt/mycephfs

# 要启用启用cephx认证的Ceph文件系统，您必须指定用户名和密码
sudo mount -t ceph 192.168.0.1:6789:/ /mnt/mycephfs -o name=admin,secret=AQATSKdNGBnwLhAAnNDKnH65FmVKpXZJVasUeQ==

# 上述用法在Bash历史中留下了秘密。更安全的方法是从文件中读取秘密。例如：
sudo mount -t ceph 192.168.0.1:6789:/ /mnt/mycephfs -o name=admin,secretfile=/etc/ceph/admin.secret
```
* 如果您有多个文件系统，请使用mds_namespace选项指定要挂载的文件系统，例如-o mds_namespace = myfs。 有关cephx的详细信息，请参阅用户管理。

* 要卸载Ceph文件系统，可以使用umount命令。例如：
``` bash
sudo umount /mnt/mycephfs
```

## mount ceph fs as a fuse 
```
用户空间挂载 CEPH 文件系统
Ceph v0.55 及后续版本默认开启了 cephx 认证。从用户空间（ FUSE ）挂载一 Ceph 文件系统前，确保客户端主机有一份 Ceph 配置副本、和具备 Ceph 元数据服务器能力的密钥环。

在客户端主机上，把监视器主机上的 Ceph 配置文件拷贝到 /etc/ceph/ 目录下。

sudo mkdir -p /etc/ceph
sudo scp {user}@{server-machine}:/etc/ceph/ceph.conf /etc/ceph/ceph.conf
在客户端主机上，把监视器主机上的 Ceph 密钥环拷贝到 /etc/ceph 目录下。

sudo scp {user}@{server-machine}:/etc/ceph/ceph.keyring /etc/ceph/ceph.keyring
确保客户端机器上的 Ceph 配置文件和密钥环都有合适的权限位，如 chmod 644 。

cephx 如何配置请参考 CEPHX 配置参考。

要把 Ceph 文件系统挂载为用户空间文件系统，可以用 ceph-fuse 命令，例如：

sudo mkdir /home/usernname/cephfs
sudo ceph-fuse -m 192.168.0.1:6789 /home/username/cephfs
```
## MOUNT CEPH FS IN YOUR FILE SYSTEMS TABLE
```
If you mount Ceph FS in your file systems table, the Ceph file system will mount automatically on startup.

KERNEL DRIVER
To mount Ceph FS in your file systems table as a kernel driver, add the following to /etc/fstab:

{ipaddress}:{port}:/ {mount}/{mountpoint} {filesystem-name}     [name=username,secret=secretkey|secretfile=/path/to/secretfile],[{mount.options}]
For example:

10.10.10.10:6789:/     /mnt/ceph    ceph    name=admin,secretfile=/etc/ceph/secret.key,noatime,_netdev    0       2
Important The name and secret or secretfile options are mandatory when you have Ceph authentication running.
See User Management for details.

FUSE
To mount Ceph FS in your file systems table as a filesystem in user space, add the following to /etc/fstab:

#DEVICE PATH       TYPE      OPTIONS
none    /mnt/ceph  fuse.ceph ceph.id={user-ID}[,ceph.conf={path/to/conf.conf}],_netdev,defaults  0 0
For example:

none    /mnt/ceph  fuse.ceph ceph.id=myuser,_netdev,defaults  0 0
none    /mnt/ceph  fuse.ceph ceph.id=myuser,ceph.conf=/etc/ceph/foo.conf,_netdev,defaults  0 0
Ensure you use the ID (e.g., admin, not client.admin). You can pass any valid ceph-fuse option to the command line this way.
```