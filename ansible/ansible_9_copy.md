## copy模块

>copy模块在ansible里的角色就是把ansible执行机器上的文件拷贝到远程节点上。
>与fetch模块相反的操作。

### 常用模块参数
|参数名|是否必须|默认值|选项|说明|
|:-|:-|:-|:-|:-|
|src| 	no| 	|	|用于定位ansible执行的机器上的文件，需要绝对路径。如果拷贝的是文件夹，那么文件夹会整体拷贝，如果结尾是”/”,那么只有文件夹内的东西被考过去。一切的感觉很像rsync|
|content| 	no| 	||		用来替代src，用于将指定文件的内容，拷贝到远程文件内|
|dest |	yes| 	||		用于定位远程节点上的文件，需要绝对路径。如果src指向的是文件夹，这个参数也必须是指向文件夹|
|backup| 	no| 	no| 	yes/no| 	备份远程节点上的原始文件，在拷贝之前。如果发生什么意外，原始文件还能使用。|
|directory_mode |	no 	|||		这个参数只能用于拷贝文件夹时候，这个设定后，文件夹内新建的文件会被拷贝。而老旧的不会被拷贝|
|followe| 	no| 	no| 	yes/no| 	当拷贝的文件夹内有link存在的时候，那么拷贝过去的也会有link|
|force| 	no| 	yes| 	yes/no| 	默认为yes,会覆盖远程的内容不一样的文件（可能文件名一样）。如果是no，就不会拷贝文件，如果远程有这个文件|
|group |	no |||			设定一个群组拥有拷贝到远程节点的文件权限|
|mode 	|no |||			等同于chmod，参数可以为“u+rwx or u=rw,g=r,o=r”|
|owner| 	no||| 			设定一个用户拥有拷贝到远程节点的文件权限|

### 案例

- #### 把/srv/myfiles/foo.conf文件拷贝到远程节点/etc/foo.conf，并且它的拥有者是foo，拥有它的群组是foo，权限是0644
      - copy: src=/srv/myfiles/foo.conf dest=/etc/foo.conf owner=foo group=foo mode=0644

- #### 跟上面的案例一样，不一样的只是权限的写法
      - copy: src=/srv/myfiles/foo.conf dest=/etc/foo.conf owner=foo group=foo mode="u=rw,g=r,o=r"

- #### 另外一个权限的写法
      - copy: src=/srv/myfiles/foo.conf dest=/etc/foo.conf owner=foo group=foo mode="u+rw,g-wx,o-rwx"

- #### 拷贝/mine/ntp.conf到远程节点/etc/ntp.conf，并且备份远程节点的/etc/ntp.conf。
      - copy: src=/mine/ntp.conf dest=/etc/ntp.conf owner=root group=root mode=644 backup=yes


### 常用参数返回值
|参数名 |	参数说明 |	返回值 |	返回值类型 |	样例|
|:-|:-|:-|:-|:-|
|src |	位于ansible执行机上的位置 |	changed 	|string |	/home/httpd/.ansible/tmp/ansible-tmp-1423796390.97-147729857856000/source |
|backup_file 	|将原文件备份 |	changed and if backup=yes |	string |	/path/to/file.txt.2015-02-12@22:09~|
|uid |	在执行后，拥有者的ID |	success |	int |	100|
|dest |	远程节点的目标目录或文件 |	success |	string| 	/path/to/file.txt|
|checksum 	|拷贝文件后的checksum值 |	success |	string |	6e642bb8dd5c2e027bf21dd923337cbb4214f827|
|md5sum 	|拷贝文件后的md5 checksum值 |	when supported |	string |	2a5aeecc61dc98c4d780b14b330e3282|
|state |	执行后的状态 |	success |	string 	|file|
|gid |	执行后拥有文件夹、文件的群组ID |	success |	int |	100|
|mode |	执行后文件的权限 |	success |	string |	0644|
|owner |	执行后文件所有者的名字 |	success |	string |	httpd|
|group 	|执行后文件所有群组的名字 |	success |	string |	httpd|
|size |	执行后文件大小 |	success |	int |	1220|
