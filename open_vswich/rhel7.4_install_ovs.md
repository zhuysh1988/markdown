## RHEL 7.4 Install Open vSwitch 

### install base RPM 
``` bash 
yum install  -y gcc make \
python-devel openssl-devel \
kernel-devel graphviz \
kernel-debug-devel autoconf \
automake rpm-build redhat-rpm-config \ 
libtool

```

### Create Build Dir and Download open vswich 
``` bash 
mkdir -p ~/rpmbuild/SOURCES
cd ~/rpmbuild/SOURCES
wget http://openvswitch.org/releases/openvswitch-2.5.4.tar.gz
tar xf openvswitch-2.5.4.tar.gz
cd openvswitch-2.5.4

```

### Build RPM With Open vSwitch 
``` bash 
rpmbuild -bb rhel/openvswitch.spec
```


### Install Open vSwitch RPM 
``` bash 
cd /root/rpmbuild/RPMS/x86_64
yum install ./openvswitch-2.5.4-1.x86_64.rpm  -y
```



### Start Open vSwitch 
``` bash 
/etc/init.d/openvswitch start 
```

## Use Open vSwitch 

### client与组件对应关系
``` 
ovs-dpctl	datapath控制器,可以创建删除DP,控制DP中的FlowTables,最常使用show命令，其他很少手动操作
ovs-ofctl	流表控制器，控制bridge上的流表，查看端口统计信息等
ovsdb-tool	专门管理ovsdb的client
ovs-vsctl	最常用的命令,通过操作ovsdb去管理相关的bridge,ports什么的
ovs-appctl	这个可以直接与openvswitch daemon进行交互,上图中没有列出来,这么命令较少使用

```



### 常用子命令说明
``` bash 
ovs-dpctl show -s
ovs-ofctl show, dump-ports, dump-flows, add-flow, mod-flows, del-flows
ovsdb-tools show-log -m
ovs-vsctl
show 显示数据库内容
关于桥的操作 add-br, list-br, del-br, br-exists.
关于port的操作 list-ports, add-port, del-port, add-bond, port-to-br.
关于interface的操作 list-ifaces, iface-to-br
ovs-vsctl list/set/get/add/remove/clear/destroy table record column [value], 常见的表有bridge, controller,interface,mirror,netflow,open_vswitch,port,qos,queue,ssl,sflow.
ovs-appctl list-commands, fdb/show, qos/show
```


# OpenvSwitch操作实例
## 日常操作
### 查看bridge,ports,interfaces以及相互之间的对应关系
* ovs-vsctl --help
``` bash 
 ovs-vsctl --help
ovs-vsctl: ovs-vswitchd management utility
usage: ovs-vsctl [OPTIONS] COMMAND [ARG...]

Open vSwitch commands:
  init                        initialize database, if not yet initialized
  show                        print overview of database contents
  emer-reset                  reset configuration to clean state

Bridge commands:
  add-br BRIDGE               create a new bridge named BRIDGE
  add-br BRIDGE PARENT VLAN   create new fake BRIDGE in PARENT on VLAN
  del-br BRIDGE               delete BRIDGE and all of its ports
  list-br                     print the names of all the bridges
  br-exists BRIDGE            exit 2 if BRIDGE does not exist
  br-to-vlan BRIDGE           print the VLAN which BRIDGE is on
  br-to-parent BRIDGE         print the parent of BRIDGE
  br-set-external-id BRIDGE KEY VALUE  set KEY on BRIDGE to VALUE
  br-set-external-id BRIDGE KEY  unset KEY on BRIDGE
  br-get-external-id BRIDGE KEY  print value of KEY on BRIDGE
  br-get-external-id BRIDGE  list key-value pairs on BRIDGE

Port commands (a bond is considered to be a single port):
  list-ports BRIDGE           print the names of all the ports on BRIDGE
  add-port BRIDGE PORT        add network device PORT to BRIDGE
  add-bond BRIDGE PORT IFACE...  add bonded port PORT in BRIDGE from IFACES
  del-port [BRIDGE] PORT      delete PORT (which may be bonded) from BRIDGE
  port-to-br PORT             print name of bridge that contains PORT

Interface commands (a bond consists of multiple interfaces):
  list-ifaces BRIDGE          print the names of all interfaces on BRIDGE
  iface-to-br IFACE           print name of bridge that contains IFACE

Controller commands:
  get-controller BRIDGE      print the controllers for BRIDGE
  del-controller BRIDGE      delete the controllers for BRIDGE
  set-controller BRIDGE TARGET...  set the controllers for BRIDGE
  get-fail-mode BRIDGE       print the fail-mode for BRIDGE
  del-fail-mode BRIDGE       delete the fail-mode for BRIDGE
  set-fail-mode BRIDGE MODE  set the fail-mode for BRIDGE to MODE

Manager commands:
  get-manager                print the managers
  del-manager                delete the managers
  set-manager TARGET...      set the list of managers to TARGET...

SSL commands:
  get-ssl                     print the SSL configuration
  del-ssl                     delete the SSL configuration
  set-ssl PRIV-KEY CERT CA-CERT  set the SSL configuration

Auto Attach commands:
  add-aa-mapping BRIDGE I-SID VLAN   add Auto Attach mapping to BRIDGE
  del-aa-mapping BRIDGE I-SID VLAN   delete Auto Attach mapping VLAN from BRIDGE
  get-aa-mapping BRIDGE              get Auto Attach mappings from BRIDGE

Switch commands:
  emer-reset                  reset switch to known good state

Database commands:
  list TBL [REC]              list RECord (or all records) in TBL
  find TBL CONDITION...       list records satisfying CONDITION in TBL
  get TBL REC COL[:KEY]       print values of COLumns in RECord in TBL
  set TBL REC COL[:KEY]=VALUE set COLumn values in RECord in TBL
  add TBL REC COL [KEY=]VALUE add (KEY=)VALUE to COLumn in RECord in TBL
  remove TBL REC COL [KEY=]VALUE  remove (KEY=)VALUE from COLumn
  clear TBL REC COL           clear values from COLumn in RECord in TBL
  create TBL COL[:KEY]=VALUE  create and initialize new record
  destroy TBL REC             delete RECord from TBL
  wait-until TBL REC [COL[:KEY]=VALUE]  wait until condition is true
Potentially unsafe database commands require --force option.

Options:
  --db=DATABASE               connect to DATABASE
                              (default: unix:/var/run/openvswitch/db.sock)
  --no-wait                   do not wait for ovs-vswitchd to reconfigure
  --retry                     keep trying to connect to server forever
  -t, --timeout=SECS          wait at most SECS seconds for ovs-vswitchd
  --dry-run                   do not commit changes to database
  --oneline                   print exactly one line of output per command

Logging options:
  -vSPEC, --verbose=SPEC   set logging levels
  -v, --verbose            set maximum verbosity level
  --log-file[=FILE]        enable logging to specified FILE
                           (default: /var/log/openvswitch/ovs-vsctl.log)
  --syslog-method=(libc|unix:file|udp:ip:port)
                           specify how to send messages to syslog daemon
  --syslog-target=HOST:PORT  also send syslog msgs to HOST:PORT via UDP
  --no-syslog             equivalent to --verbose=vsctl:syslog:warn

Active database connection methods:
  tcp:IP:PORT             PORT at remote IP
  ssl:IP:PORT             SSL PORT at remote IP
  unix:FILE               Unix domain socket named FILE
Passive database connection methods:
  ptcp:PORT[:IP]          listen to TCP PORT on IP
  pssl:PORT[:IP]          listen for SSL on PORT on IP
  punix:FILE              listen on Unix domain socket FILE
PKI configuration (required to use SSL):
  -p, --private-key=FILE  file with private key
  -c, --certificate=FILE  file with certificate for private key
  -C, --ca-cert=FILE      file with peer CA certificate

Other options:
  -h, --help                  display this help message
  -V, --version               display version information

```



### 
``` bash 

```



### 
``` bash 

```

