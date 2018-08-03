## zypper模块

>zypper本身是suse或opensuse的rpm包管理工具。这里指的是ansible的zypper模块

## 模块参数

|参数名|是否必须|默认值|选项值|参数说明|
|:-|:-|:-|:-|:-|
|disable_gpg_check|no|no|yes/no|该参数管GPG检查包的签名的功能，默认是检查，这个参数会影响state参数为present及latest时的情况|
|disable_recommends |no|no|yes/no|等同于zypper命令的–no-recommends参数，默认是yes，no的时候就不会安装recommend的软件包|
|name| 	yes|||软件包名字|
|state 	|no|present|present/latest/absent| 	软件包的最后状态。present代表安装完毕，latest代表安装最新版，absent代表移除|

### 案例

- ### 安装nmap
      - zypper: name=nmap state=present

- ### 安装apache2以及recommends的包
      - zypper: name=apache2 state=present disable_recommends=no

- ### 移除nmap
      - zypper: name=nmap state=absent
