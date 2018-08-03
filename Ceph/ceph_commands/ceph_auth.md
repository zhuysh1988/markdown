## Ceph 用户管理
### 用户管理
```
Ceph storage cluster的认证和授权默认是启用的。

Ceph的客户端用户要么是独立的个体用户，要么是系统中的一个应用，他们都使用ceph的客户端与ceph存储集群交互。 

当ceph启用认证和授权时，你必须要指定用户名和包含秘钥的钥匙环才可以使用客户端与集群进行交互。

如果不指定如：ceph heath，它会使用默认用户client.admin并自动通过keyring查找对用的key。 


指定用户和秘钥的方式： 
ceph –n client.admin –keyring=/etc/ceph/ceph.client.admin.keyring health 

和上面的指令的效果是相同的。 
不管什么类型的客户端（块，对象，文件系统，还是本地api）ceph把所有的数据都统一存储在池中。

用户必须要有对池的访问权限，而且ceph用户还要有执行权限，以便使用ceph的管理指令。
```

#### user：
```
用户可以是一个独立的个体，或者系统的一个角色如一个应用。创建了用户，才允许你访问存储集群，它的池，和池中的数据。 

Ceph中有用户type概念，用户的管理通常是client。

Ceph对用户的辨别是通过点分割的形式，它包含类型和用户名如：TYPE.ID格式client.admin，client.user1。

使用用户类型的原因是因为ceph monitors osds 和metadata 服务也都使用了cephx协议，但是他们不是客户端，类型就是用于区分的。

区分用户类型有助于在客户端用户和其他用户的访问控制，用户监控和跟踪的辨别。

注：ceph存储集群用户和ceph对象存储用户或者ceph文件系统用户是不一样的，ceph object gateway使用存储集群用户来进行gateway守护进程和存储集群之间交互。

但是gateway有他自己的终端用户管理功能。Ceph文件系统使用的是posix，与ceph文件系统相关的用户跟ceph存储集群用户也是不同的。 

Ceph使用“capability”来标识赋予已认证用户执行monitors ，osd，和metadata 服务功能的能力。

Capability严格控制对池中数据的访问或者池中命名空间的访问。当创建用户的时候由管理员用户来赋予用户capability。 
```
* Capability的语法如下：
```
{daemon-type}  ‘ allow  {capablility}’  [{daemon-type}  ‘allow  {capablility}’]

Monitor Caps:monitor capabilities 包括r,w,x和allow profile  {cap},例如：
mon ‘allow  rwx’
mon ‘allow profile osd’

OSD Caps:OSD capabilities包括r,w,x,class-read,class-write和profile osd，另外osdcapability也允许对pool和namaspace的设置。
osd ‘allow  {capability}’ [pool={poolname}] [namespace={namespace-name}]

Metadata Server Caps:metadata server capability需要allow，或者是空白而且不不解析任何特性。
mds ‘allow’ 

ceph auth list

	key: AQCM0AxbBv1TORAA5fySmeENSKR9e9lNXjdEzg==
	caps: [mgr] allow profile osd
	caps: [mon] allow profile osd
	caps: [osd] allow *
osd.5
	key: AQCX0AxbHb5aHhAAbMNayk8HkmPGh5MlnTyxxw==
	caps: [mgr] allow profile osd
	caps: [mon] allow profile osd
	caps: [osd] allow *
client.admin
	key: AQD5zwxbIxayABAAkc6To8Lj/XvKqQYEZDsZrA==
	caps: [mds] allow *
	caps: [mgr] allow *
	caps: [mon] allow *
	caps: [osd] allow *

```
```
注：ceph object gateway daemo (radosgw)是一个ceph存储集群客户端，所以它没有被标识为ceph存储集群的守护进程类型。
```

#### Pool：
```
Pool是对存储的逻辑划分，用户把数据都放到pool里，默认情况下，ceph storage cluster中有data pool，rbd pool，metadata pool。

在ceph的部署中为相似的数据创建一个pool来存放数据是很普遍的。

例如当把ceph作为opentack的后端时，典型的部署有volumes ，image，backups，和virtual machine pool，和用户如：client.glance，client.cinder，etc。
```

#### Namespace
```
池中对象的一个逻辑组织，池中的对象可以关联到该命名空间中。

用户访问的pool可以关联到一个池中，这样用户所做的读写尽在该命名空间中有效。

Pool中写在命名空间中的数据只有对该命名空间有访问权限的用户才可以访问。

命名空间对与使用librados写数据的应用是很有用的，但是像block device client，object storage client和filesystem 暂时还不支持该特性。
```
### 管理用户

* 用户管理功能在ceph集群中给ceph管理员直接创建，跟新，删除用户的能力。 

* * 列出所有ceph用户：
```bash
ceph auth list 
# 可以使用-o {filename}选项把输出内容打印到指定文件中。
```
* * 获取指定用户
```
ceph auth get {TYPE.ID}
```

* * 创建用户
```
创建用户会添加一个用户名，秘钥和capability 
用户的key使用户能通过ceph storage cluster认证，用户的capabilities使用户具有一定的monitors，osds，或者metadata server的功能。 

下面有三种创建用户的方式：

a)ceph auth add:这个命令可以创建用户，产生秘钥和添加一些指定的capabilities。


b)ceph auth get-or-create:这个命令会返回一个包含用户名和秘钥的keyfile 格式。
  如果用户已经存在，它就会以keyfile 格式返回用户名和key。


c)ceph auth get-or-create-key:这个命令创建用户但是只返回用户的key，如果想知道已存在用的key，这个命令是很有用的。可以使用-o {filename}选项把输出打印到指定文件。

如果只创建用户，没有赋予用户capabilities，那么用户基本是无用的，但是可以使用命令ceph auth caps 给其添加capabilities。 

下面是这些命令使用的例子：

ceph auth add client.john mon 'allow r' osd 'allow rw pool=liverpool'
ceph auth get-or-create client.paul mon 'allow r' osd 'allow rw pool=liverpool'
ceph auth get-or-create client.george mon 'allow r' osd 'allow rw pool=liverpool' -o george.keyring
ceph auth get-or-create-key client.ringo mon 'allow r' osd 'allow rw pool=liverpool' -o ringo.key

如果赋予用户osd的capability，但是没有指定特定的pool，则该用户对集群中所有的pool有访问权限。
```

#### 修改用户capability，
```
ceph auth caps USERTYPE.USERID {daemon} 'allow [r|w|x|*|...] [pool={pool-name}] [namespace={namespace-name}']

例如：

ceph auth caps client.john mon 'allow r' osd 'allow rw pool=liverpool'
ceph auth caps client.paul mon 'allow rw' osd 'allow rwx pool=liverpool'
ceph auth caps client.brian-manager mon 'allow *' osd 'allow *'
```
#### 删除用户的capabilities ,对权限指向空字符串。
```
ceph auth caps client.rngo mon ‘’ osd ‘’
```
#### 删除用户
```
ceph auth del {TYPE}.{ID}
```
#### 打印用户key
```
ceph auth print-key {TYPE}.{ID}
```
#### 导入用户
```
ceph auth import –I /path/to/keyring
注：ceph集群会添加新的用户，他们的keys和capabilities而且也会更新已经存在用户的keys和capabilities。
```

### Keyring管理
```
用户使用ceph client访问ceph时，ceph client会寻找本地的本地的keyring，ceph默认情况下预先对keyring做了下面四个文件的设置，所以你不必再设置它们，除非你想覆盖默认设置。

/etc/ceph/$cluster.$name.keyring 
/etc/ceph/$cluster.keyring  
/etc/ceph/keyring 
/etc/ceph/keyring.bin

变量cluster是集群的名字，它被ceph的配置文件名所定义，（例如：ceph.conf意思是集群的名字是ceph因此ceph.keyring），变量cluster是集群的名字，它被ceph的配置文件名所定义，（例如：ceph.conf意思是集群的名字是ceph因此ceph.keyring），变量name是用户类型和用户id（如client.admin因此ceph.client.admin.keyring）
```
#### 创建一个keyring
```
当你在用户管理中创建一个用户，然后需要要创建一个钥匙环，你需要给ceph client提供一个用户keys，这样ceph client才能检索到指定用户的key，然后通过ceph storage cluster的认证。

Ceph client 通过查询keyring来寻找用户名和用户的key。

ceph-authtool程序可以帮助你创建keyring，创建一个空的keyring，使用—create-keyring或ceph-authtool –create-keyring /path/to/keyring当你创建一个钥匙环供多个用户使用时，最好使用集群的名字作为钥匙环的名字，并保存在/etc/ceph/目录下，因为keyring的默认设置会检索这个配置文件而不需要你在单独指定本地配置文件的副本。

例如ceph.keyring。
 ceph-authtool –C /etc/ceph/ceph.keyring

当创建的钥匙环为单个用户使用，最好使用集群的名字，用户的类型和用户的名字，并保存在/etc/ceph目录下。

例如client.admin用户的钥匙环ceph.client.admin.keyring。 

在/etc/ceph目录下创建钥匙环，必须使用root用户。这意味着只有root用户才有钥匙环rw权限，当钥匙环包含的是管理源的keys，这样就比较合理了。

如果你打算为某个特定的用户，或者用户组使用一个特定的钥匙环，要确保使用chown或者chmod来建立适当的keyring所有权和访问权。
```
#### 添加用户到钥匙环
```
如果想为每个用户都建立一个钥匙环的话，可以使用下面这个命令，添加一个-o选项，把输出保存到keyring文件格式中。如：为用会client.admin创建钥匙环。

 ceph auth get client.admin –o /etc/ceph/ceph.client.admin.keyring

注：要为对个的个体用户，使用推荐的文件格式。

当想把已经存在的用户导入到keyring中时，可以使用ceph-authtool工具来完成，要指定目的钥匙环和源钥匙环。如
：

 ceph-authtool /etc/ceph/ceph.keyring  --import-keyring /etc/ceph/ceph.client.admin.keyring
```

#### 创建用户
```
ceph提供了添加用户功能来直接在集群中创建用户，然而你也可以直接在ceph 
client中创建用户，key和capabilities。然后在把用户导入到ceph集群中。
 ceph-authtool –n client.`这里写代码片`ringo –cap osd ‘allow rwx’ –cap mon ‘allow rwx’ /etc/ceph/ceph.keyring

也可以把创建钥匙环和添加新用户同时进行。如：
 ceph-authtool –C /etc/ceph/ceph.keyring –n client.ringo –cap osd ‘allow rwx’ –cap mon ‘allow rwx’ –gen-key

在上述场景中新用户client.ringo仅仅存在于keyring中，要把新用户添加到ceph storage 
cluster中，你必须添加新的用户到ceph storage cluster中。
 ceph auth add client.ringo –I /eetc/ceph/ceph.keyring
```

#### 修改用户
```
更改记录在keyring中的用户的capabilities，通过capabilities指定keyring和用户名：

 ceph-authtool /etc/ceph/ceph.keyring –n client.ringo –cap osd ‘allow rwx’ –cap mon ’allow rxx’

这里写代码片更新用户到ceph storage cluster中，在ceph storage cluster 
中你必须要更新keyring中的用户实体。
 ceph auth import –I /etc/ceph/ceph.keyring 
你也可以在集群中直接更新用户的capabilities，把结果存储在keyring文件中，然后把keyring导入到你的主要ceph.keyring中。
```