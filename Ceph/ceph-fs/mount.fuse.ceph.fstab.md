## MOUNT.FUSE.CEPH – MOUNT CEPH-FUSE FROM /ETC/FSTAB.
### SYNOPSIS
```
mount.fuse.ceph [-h] [-o OPTIONS [OPTIONS …]] device [device …] mountpoint [mountpoint …]
DESCRIPTION
mount.fuse.ceph is a helper for mounting ceph-fuse from /etc/fstab.

To use mount.fuse.ceph, add an entry in /etc/fstab like:

DEVICE    PATH        TYPE        OPTIONS
none      /mnt/ceph   fuse.ceph   ceph.id=admin,_netdev,defaults  0 0
none      /mnt/ceph   fuse.ceph   ceph.name=client.admin,_netdev,defaults  0 0
none      /mnt/ceph   fuse.ceph   ceph.id=myuser,ceph.conf=/etc/ceph/foo.conf,_netdev,defaults  0 0
ceph-fuse options are specified in the OPTIONS column and must begin with ‘ceph.’ prefix. This way ceph related fs options will be passed to ceph-fuse and others will be ignored by ceph-fuse.
```
## OPTIONS
```
ceph.id=<username>
Specify that the ceph-fuse will authenticate as the given user.

ceph.name=client.admin
Specify that the ceph-fuse will authenticate as client.admin

ceph.conf=/etc/ceph/foo.conf
Sets ‘conf’ option to /etc/ceph/foo.conf via ceph-fuse command line.

Any valid ceph-fuse options can be passed this way.
```
### ADDITIONAL INFO
```
The old format /etc/fstab entries are also supported:
```
### DEVICE                              PATH        TYPE        OPTIONS
```
id=admin                            /mnt/ceph   fuse.ceph   defaults   0 0
id=myuser,conf=/etc/ceph/foo.conf   /mnt/ceph   fuse.ceph   defaults   0 0
```