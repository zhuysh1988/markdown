



dnsmasq server 192.168.4.169

address=/registry.example.com/192.168.4.169
address=/git.example.com/192.168.4.169 
address=/registry-ui.example.com/192.168.4.169 
address=/yum.example.com/192.168.1.34
address=/lb.example.com/192.168.4.160
address=/ocp39.example.com/192.168.4.160
address=/master1.example.com/192.168.4.161
address=/master2.example.com/192.168.4.162
address=/master3.example.com/192.168.4.163
address=/node1.example.com/192.168.4.164
address=/node2.example.com/192.168.4.165
address=/infranode1.example.com/192.168.4.166
address=/infranode2.example.com/192.168.4.167



## master1 
curl -o /etc/yum.repos.d/ocp39.repo http://192.168.1.34/repo_file/ocp39.repo
yum makecache fast 

yum install atomic-openshift-utils atomic-openshift-clients -y

vi /etc/ansible/hosts 



ssh-keyget -t rsa -b 2048

for host in lb master1 master2 master3 node1 node2 infranode1 infranode2 ;do 
ssh-copy-id $host.example.com && \
echo '-------------------------------------------------------------------'
done


## NAT 
```
openshift_hostname

This variable overrides the internal cluster host name for the system. Use this when the system’s default IP address does not resolve to the system host name.

openshift_public_hostname

This variable overrides the system’s public host name. Use this for cloud installations, or for hosts on networks using a network address translation (NAT).

openshift_ip

This variable overrides the cluster internal IP address for the system. Use this when using an interface that is not configured with the default route.openshift_ip can be used for etcd.

openshift_public_ip

This variable overrides the system’s public IP address. Use this for cloud installations, or for hosts on networks using a network address translation (NAT).
```

## stop firewalld
ansible all -m service -a 'name=firewalld state=stopped enabled=no'


## yum
```bash
ansible all -m copy -a 'src=/etc/yum.repos.d/ocp39.repo dest=/etc/yum.repos.d/ocp39.repo'
ansible all -m shell -a  'yum makecache fast'
ansible masters -m yum -a 'name=atomic-openshift-utils,atomic-openshift-clients state=installed '

ansible all -m shell -a 'yum install -y wget git net-tools bind-utils yum-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct'
```




##  NTP
yum install chrony -y 
sed -i '/rhel.pool.ntp.org/d' /etc/chrony.conf 
sed -i '3aserver registry.example.com iburst' /etc/chrony.conf 
systemctl enable chronyd 
systemctl restart chronyd 


ansible all -m yum -a 'name=chrony state=installed '
ansible all -m copy -a 'src=/etc/chrony.conf dest=/etc/chrony.conf'
ansible all -m service -a 'name=chronyd state=started enabled=yes'


## docker 
ansible nodes -m yum -a 'name=docker state=installed'

cat<<EOF>/etc/sysconfig/docker-storage-setup
DEVS=/dev/sdb
VG=docker-vg
SETUP_LVM_THIN_POOL=yes
EOF

ansible nodes -m copy -a 'src=/etc/sysconfig/docker-storage-setup dest=/etc/sysconfig/docker-storage-setup'

ansible nodes -m shell -a 'docker-storage-setup'

cat <<EOF > /etc/containers/registries.conf
[registries.search]
registries = ['registry.access.redhat.com']
[registries.insecure]
registries = ['registry.example.com:5000']
[registries.block]
registries = []
EOF

ansible nodes -m copy -a 'src=/etc/containers/registries.conf dest=/etc/containers/registries.conf'

ansible nodes -m service -a 'name=docker state=restarted enabled=yes'


## create ocp39 admin 
OCP_USER='admin'
OCP_PASSWORD='onceas'
OCP_AUTH_FILE_B='/root/htpasswd'
OCP_AUTH_FILE='/etc/origin/master/htpasswd'
htpasswd -cb $OCP_AUTH_FILE_B $OCP_USER $OCP_PASSWORD ; 


## update package
ansible all -m shell -a 'yum update -y'

## poweroff server 
poweroff # 制作一个快照 



## deployer ocp39 

```bash
ansible-playbook -f 20 /usr/share/ansible/openshift-ansible/playbooks/prerequisites.yml
```

## deploy cluster 
```bash
ansible-playbook -f 20 /usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml

```

nohup ansible-playbook -f 20 /usr/share/ansible/openshift-ansible/playbooks/deploy_cluster.yml  & 


ansible-playbook /usr/share/ansible/openshift-ansible/playbooks/adhoc/uninstall.yml
ansible nodes -a "rm -rf /etc/origin"
ansible nfs -a "rm -rf /srv/nfs/storage/*"



