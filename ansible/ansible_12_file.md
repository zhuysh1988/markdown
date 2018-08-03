## file模块

>在之前ansible命令行的时候有copy模块，在playbook的时代自然也有一个模块专门负责文件的拷贝，当然这个时代它不仅仅是文件拷贝那么简单。

>来自官方的解释：

    file模块它包含了文件、文件夹、超级链接类的创立、拷贝、移动、删除操作。

### 常用参数
|参数名 |	是否必须| 	默认值 |	选项 |	说明|
|:-|:-|:-|:-|:-|
|follow| no |	no |	yes/no |	如果原来的文件是link，拷贝后依旧是link|
|force |	no| 	no |	yes/no| 	强制执行，没说的|
|group |	no| 		||	设定一个群组拥有拷贝到远程节点的文件权限|
|mode 	|no |	||	等同于chmod，参数可以为“u+rwx or u=rw,g=r,o=r”|
|owner |	no| 	||		设定一个用户拥有拷贝到远程节点的文件权限|
|path 	|yes| 		||	目标路径，也可以用dest,name代替|
|src 	y|es |	||		待拷贝文件/文件夹的原始位置。|
|state |	no| 	file |	file/link/directory/hard/touch/absent |	file代表拷贝后是文件；link代表最终是个软链接；directory代表文件夹；hard代表硬链接；touch代表生成一个空文件；absent代表删除|

### 案例

- #### 修改文件的所有组、人、权限。
      - file: path=/etc/foo.conf owner=foo group=foo mode=0644
- #### 操作链接的案例
      - file: src=/file/to/link/to dest=/path/to/symlink owner=foo group=foo state=link
- #### 参数化案例
      - file: src=/tmp/{{ item.path }} dest={{ item.dest }} state=link
        with_items:
          - { path: 'x', dest: 'y' }
          - { path: 'z', dest: 'k' }

- #### 使用touch来创建一个空文件并定义权限
      - file: path=/etc/foo.conf state=touch mode="u=rw,g=r,o=r"

- #### touch一个空文件，并且修改权限
      - file: path=/etc/foo.conf state=touch mode="u+rw,g-wx,o-rwx"
