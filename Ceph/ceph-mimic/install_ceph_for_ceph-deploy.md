# CEPH Install CentOS 7.3 1611

## 三台服务器(VMware vHost)
|IP1|IP2|Hostname|CPU|MEM|HD1|HD2|
|-|-|-|-|-|-|-|-|-|
|192.168.1.119|172.30.1.119|node1|4c|4g|sdb|sdc|
|192.168.1.118|172.30.1.118|node2|4c|4g|sdb|sdc|
|192.168.1.117|172.30.1.117|node3|4c|4g|sdb|sdc|

## Init OS 
* disabled selinux
* * all node
``` bash
setenforce 0 
sed -i 's#^SELINUX=.*$#SELINUX=disabled#g' /etc/selinux/config
```

* stop firewalld
* * all node
``` bash
systemctl stop firewalld
systemctl disable firewalld
```

* Config limits
* * all node
```bash
cat > /etc/security/limits.d/20-nproc.conf << EOF
*          soft    nproc     unlimited
root       soft    nproc     unlimited
EOF

cat > /etc/security/limits.conf << EOF
*               soft    noproc          65535
*               hard    noproc          65535
*               soft    nofile          65535
*               hard    nofile          65535
root            soft    noproc          65535
root            hard    noproc          65535
root            soft    nofile          65535
root            hard    nofile          65535
EOF
```

* Config sysctl 
* * all node 
```
echo "kernel.pid_max = 4194303" >> /etc/sysctl.conf
sysctl -p 
```

* Config Yum repo 
* * all node
```
mkdir /opt/yumrepo_bak
mv /etc/yum.repos.d/* /opt/yumrepo_bak
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo

cat > /etc/yum.repos.d/ceph.repo << EOF
[Ceph]
name=Ceph packages for x86_64
baseurl=http://mirrors.163.com/ceph/rpm-mimic/el7/x86_64
enabled=1
gpgcheck=0
type=rpm-md
gpgkey=https://mirrors.163.com/ceph/keys/release.asc
priority=1

[Ceph-noarch]
name=Ceph noarch packages
baseurl=http://mirrors.163.com/ceph/rpm-mimic/el7/noarch
enabled=1
gpgcheck=0
type=rpm-md
gpgkey=https://mirrors.163.com/ceph/keys/release.asc
priority=1

[ceph-source]
name=Ceph source packages
baseurl=http://mirrors.163.com/ceph/rpm-mimic/el7/SRPMS
enabled=1
gpgcheck=0
type=rpm-md
gpgkey=https://mirrors.163.com/ceph/keys/release.asc
priority=1

EOF
```
* Install openssh-server chrony
* * all node
```
yum install openssh-server chrony yum-plugin-priorities  ceph-deploy -y 
```
* Config ntp service
* * all node
```
cat > /etc/chrony.conf <<EOF
server time1.aliyun.com iburst
server time2.aliyun.com iburst
server time3.aliyun.com iburst
server time4.aliyun.com iburst
driftfile /var/lib/chrony/drift
makestep 1.0 3
rtcsync
logdir /var/log/chrony
EOF 

systemctl enable chronyd 
systemctl restart chronyd
```
* create ceph deploy user and config sudo no paaswd  
* * all node
```
useradd -d /home/ceph-user -m ceph-user
passwd ceph-user
echo "ceph-user ALL = (root) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/ceph-user
chmod 0440 /etc/sudoers.d/ceph-user
```

* Config /etc/hosts
* * all node
```
# add /etc/hosts
192.168.1.119 node1
192.168.1.118 node2
192.168.1.117 node3
172.30.1.119 inode1
172.30.1.118 inode2
172.30.1.117 inode3
```
* Config ceph-user ssh-key 
* * node1
```
su -i ceph-user
ssh-keygen
for i in 1 2 3 ;do ssh-copy-id ceph-user@node$i ;done
for i in 1 2 3 ;do ssh-copy-id ceph-user@inode$i ;done

cat > /home/ceph-user/.ssh/config << EOF
Host node1
    Hostname node1
    User ceph-user
Host node2
    Hostname node2
    User ceph-user
Host node3
    Hostname node3
    User ceph-user
EOF

chmod 0600 config
```

* Reboot You OS 
* * all node 

## storage cluster start 
* * host:node1  path: ceph-cluster

* create dir 
``` 
mkdir ceph-cluster
cd ceph-cluster 
```

* start over command
```
# this command clean ceph rpm and ceph.repo 
ceph-deploy purge node1 node2 node3 
ansible all -m copy -a 'src=/etc/yum.repos.d/ceph.repo.rpmsave dest=/etc/yum.repos.d/ceph.repo '

# this command clean /etc/ceph /var/lib/ceph
ceph-deploy purgedata node1 node2 node3

ceph-deploy forgetkeys
rm ceph.*



```

* create the cluster 

```
ceph-deploy new node1 node2 node3 

# vi ceph.conf
# add this for [global]
# 配置ceph pool default 副本数 为 2 
cat >> ceph.conf << EOF 
osd pool default size = 2
public network = 192.168.0.0/21
cluster network = 172.30.1.0/24
EOF
```

sudo iptables -A INPUT -i ens160 -p tcp --dport  6800:7300 -j ACCEPT
sudo iptables -A INPUT -i ens160 -p tcp --dport  6789 -j ACCEPT
sudo iptables -A INPUT -i ens160 -p tcp --dport  6808 -j ACCEPT

* install ceph packages
```
ceph-deploy install node1 node2 node3 
```

* Deploy the initial monitor(s) and gather the keys:
```
ceph-deploy mon create-initial

ls 
#ceph.bootstrap-mds.keyring  ceph.bootstrap-rgw.keyring ceph-deploy-ceph.log
#ceph.bootstrap-mgr.keyring  ceph.client.admin.keyring ceph.mon.keyring
# ceph.bootstrap-osd.keyring  ceph.conf

```

* deploy admin key 
```
ceph-deploy admin node1 node2 node3
```

* deploy osd sdb 
```
for i in 1 2 3 ;do 
  for y in b c ;do 
    ceph-deploy osd create node$i  --data /dev/sd$y 
  done
done
```

* deploy mds 
```
ceph-deploy mds create node3
```

* deploy mgr
```
ceph-deploy mgr create  node2
```

* show ceph cluster 
```
sudo ceph -s 
  cluster:
    id:     d57d987e-b470-4043-b76d-c49c7c48caf5
    health: HEALTH_OK
 
  services:
    mon: 3 daemons, quorum node3,node2,node1
    mgr: node2(active)
    osd: 6 osds: 6 up, 6 in
 
  data:
    pools:   0 pools, 0 pgs
    objects: 0 objects, 0B
    usage:   6.02GiB used, 294GiB / 300GiB avail
    pgs:   

sudo ceph -v
ceph version 13.1.1 (11ce2b3e36738ddc9b1ab421db5d25741cdb07c7) mimic (rc)

```

ceph-deploy install 192.168.1.112
ceph-deploy admin 192.168.1.112 

ceph osd pool create jihongrui 128 2
ceph osd pool get jihongrui size


yum -y install ceph ceph-radosgw



rbd pool init jihongrui

rbd create --pool jihongrui foo --size 10240 --image-feature layering

rbd map foo --pool jihongrui --name client.admin

mkfs.xfs  /dev/rbd0
mkdir -p /ceph-rbd-device/jihongrui/foo
mount /dev/rbd0 /ceph-rbd-device/jihongrui/foo/