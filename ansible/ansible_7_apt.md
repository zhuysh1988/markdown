## apt模块
>这个模块是ubuntu作为远端节点的OS的时候，用的最多的。Apt是啥就不多说了，ubuntu/debian的包管理工具。

### 模块参数
|参数名|是否必须|默认值|选项值|参数说明|
|:-|:-|:-|:-|:-|
|cache_valid_time|no|||如果update_cache参数起作用的时候，这个参数才会起作用。其用来控制update_cache的整体有效时间|
|deb|no|||这个用于安装远程机器上的.deb后缀的软件包|
|default_release|no|||同于apt命令的-t选项，这里就不多说了|
|force|no|no|yes/no|强制执行apt install/remove|
|install_recommends|no|Ture|yes/no|这个参数可以控制远程电脑上是否只是下载软件包，还是下载后安装，默认参数为true,设置为false的时候光下载软件包，不安装|
|name|no|||apt要下载的软件包名字，支持name=git=1.6 这种制定版本的模式|
|purge|no||yes/no|如果state参数值为absent,这个参数为yes的时候，将会强行干净的卸载|
|state|no|present|latest/absent/present|定义软件包的最终状态，latest时为安装最新软件|
|update_cache|no|yes/no|当这个参数为yes的时候等于apt-get update|
|upgrade|no|yes|yes/safe/full/dist|如果参数为yes或者safe，等同于apt-get upgrade.如果是full就是完整更新。如果是dist等于apt-get dist-upgrade。|

## 使用案例

### 在安装foo软件包前更新然后安装foo
    - apt: name=foo update_cache=yes

### 移除foo软件包
    - apt: name=foo state=absent

### 安装foo软件包
    - apt: name=foo state=present

### 安装foo 1.0软件包
    - apt: name=foo=1.00 state=present

### 安装nginx最新的名字为squeeze-backport发布包，并且安装前执行更新
    - apt: name=nginx state=latest default_release=squeeze-backports update_cache=yes

### 只下载openjdk-6-jdk最新的软件包，不安装
    - apt: name=openjdk-6-jdk state=latest install_recommends=no

### 安装所有软件包到最新版本
    - apt: upgrade=dist

### 更新apt-get的list
    - apt: update_cache=yes

### 3600秒后停止update_cache
    - apt: update_cache=yes cache_valid_time=3600


### 安装远程节点上的/tmp/mypackage.deb软件包
    - apt: deb=/tmp/mypackage.deb
